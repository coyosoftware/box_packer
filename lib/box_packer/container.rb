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

    def initialize(dimensions, opts = {}, &b)
      super(Dimensions[*dimensions])
      @label = opts[:label]
      @packings_limit = opts[:packings_limit]
      @orientation = opts[:orientation].nil? ? :width : opts[:orientation]
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
      exporter = SVGExporter.new(self, opts)
      exporter.draw
      exporter.save(filename)
    end

    def used_width
      return nil unless @packed_successfully
      @packings.map do |packing|
        max = packing.max{|a, b| (a.position + a.dimensions).x <=> (b.position + b.dimensions).x}

        (max.position + max.dimensions).x
      end
    end

    def used_height
      return nil unless @packed_successfully
      @packings.map do |packing|
        max = packing.max{|a, b| (a.position + a.dimensions).y <=> (b.position + b.dimensions).y}

        (max.position + max.dimensions).y
      end
    end

    def remaining_width
      return nil unless @packed_successfully
      
      used_widths = used_width

      used_widths.map do |_used_width|
        dimensions.x - _used_width
      end
    end

    def remaining_height
      return nil unless @packed_successfully
      
      used_heights = used_height

      used_heights.map do |_used_height|
        dimensions.y - _used_height
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
