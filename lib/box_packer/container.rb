require_relative 'dimensions'
require_relative 'item'
require_relative 'packer'
require_relative 'packing'
require_relative 'svg_exporter'
require_relative 'box'

module BoxPacker
  def self.container(*args, &b)
    Container.new(*args, &b)
  end

  class Container < Box
    attr_accessor :label, :packings_limit
    attr_reader :items, :packing, :packings, :packed_successfully, :orientation
    attr_reader :offset_left, :offset_top, :offset_right, :offset_bottom
    attr_reader :remove_exceeding

    def initialize(dimensions, opts = {}, &b)
      @offset_left    = (opts[:offsets].nil? || opts[:offsets][:left].nil?)   ? 0 : opts[:offsets][:left]
      @offset_top     = (opts[:offsets].nil? || opts[:offsets][:top].nil?)    ? 0 : opts[:offsets][:top]
      @offset_right   = (opts[:offsets].nil? || opts[:offsets][:right].nil?)  ? 0 : opts[:offsets][:right]
      @offset_bottom  = (opts[:offsets].nil? || opts[:offsets][:bottom].nil?) ? 0 : opts[:offsets][:bottom]

      super(Dimensions[*dimensions], opts)

      @orientation    = opts[:orientation].nil? ? :width : opts[:orientation]
      @label          = opts[:label]
      @packings_limit = opts[:packings_limit]
      @remove_exceeding = opts[:remove_exceeding].nil? ? false : opts[:remove_exceeding]
      @items = opts[:items] || []
      orient!
      instance_exec(&b) if b
    end

    def add_item(dimensions, opts = {})
      quantity = opts.delete(:quantity) || 1
      quantity.times do
        items << Item.new(dimensions, opts)
      end
    end

    def <<(item)
      items << item.dup
    end

    def items=(new_items)
      @items = new_items.map(&:dup)
    end

    def pack!
      prepare_to_pack!
      return unless packable?
      if @packed_successfully = Packer.pack(self)
        packings.count
      else
        @packings = []
        false
      end
    end

    def new_packing!
      @packing = Packing.new(area)
      @packings << @packing
    end

    def to_s
      s = "\n|Container|"
      s << " #{label}" if label
      s << " #{dimensions}"
      s << " Orientation:#{orientation.to_s}"
      s << " Packings Limit:#{packings_limit}" if packings_limit
      s << " Used width(s):#{used_width}"
      s << " Used height(s):#{used_height}"
      s << "\n"
      s << (packed_successfully ? packings.map(&:to_s).join : '|         | Did Not Pack!')
    end

    def draw!(filename, opts = {})
      exporter = SVGExporter.new(self, opts.merge(remove_exceeding: remove_exceeding))
      exporter.draw
      exporter.save(filename)
    end

    def used_width
      return nil unless @packed_successfully
      @packings.map do |packing|
        max = packing.used_width(offset_left)
      end
    end

    def used_height
      return nil unless @packed_successfully
      @packings.map do |packing|
        max = packing.used_height(offset_bottom)
      end
    end

    def remaining_width
      return nil unless @packed_successfully

      used_width.map do |_used_width|
        if remove_exceeding
          orientation == :width ? 0 : dimensions_without_offsets.x - _used_width
        else
          dimensions_without_offsets.x - _used_width
        end
      end
    end

    def remaining_height
      return nil unless @packed_successfully

      used_height.map do |_used_height|
        if remove_exceeding
          orientation == :height ? 0 : dimensions_without_offsets.y - _used_height
        else
          dimensions_without_offsets.y - _used_height
        end
      end
    end

    private

    def packable?
      return false if items.empty?

      items.each do |item|
        return false unless self >= item
      end

      true
    end

    def prepare_to_pack!
      items.each(&:orient!)
      @packings = []
      @packed_successfully = false
    end
  end
end
