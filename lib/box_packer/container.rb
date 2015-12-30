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
    attr_accessor :label, :weight_limit, :packings_limit
    attr_reader :items, :packing, :packings, :packed_successfully

    def initialize(dimensions, opts = {}, &b)
      super(Dimensions[*dimensions])
      @label = opts[:label]
      @weight_limit = opts[:weight_limit]
      @packings_limit = opts[:packings_limit]
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
      @packing = Packing.new(volume, weight_limit)
      @packings << @packing
    end

    def to_s
      s = "\n|Container|"
      s << " #{label}" if label
      s << " #{dimensions}"
      s << " Weight Limit:#{weight_limit}" if weight_limit
      s << " Packings Limit:#{packings_limit}" if packings_limit
      s << "\n"
      s << (packed_successfully ? packings.map(&:to_s).join : '|         | Did Not Pack!')
    end

    def draw!(filename, opts = {})
      exporter = SVGExporter.new(self, opts)
      exporter.draw
      exporter.save(filename)
    end

    private

    def packable?
      return false if items.empty?
      total_weight = 0

      items.each do |item|
        if weight_limit && item.weight
          return false if item.weight > weight_limit
          total_weight += item.weight
        end

        return false unless self >= item
      end

      if weight_limit && packings_limit
        return total_weight <= weight_limit * packings_limit
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
