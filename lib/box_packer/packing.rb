require 'delegate'

module BoxPacker
  class Packing < SimpleDelegator
    attr_reader :remaining_area

    def initialize(total_area)
      super([])
      @remaining_area = total_area
    end

    def <<(item)
      @remaining_area -= item.area
      super
    end

    def fit?(item)
      return false if include?(item)
      return false if remaining_area < item.area
      true
    end

    def used_width(offset_left = 0)
      max_value = max{|a, b| (a.position + a.dimensions).x <=> (b.position + b.dimensions).x}

      (max_value.position + max_value.dimensions).x - offset_left
    end

    def used_height(offset_bottom = 0)
      max_value = max{|a, b| (a.position + a.dimensions).y <=> (b.position + b.dimensions).y}

      (max_value.position + max_value.dimensions).y - offset_bottom
    end

    def to_s
      s = "|  Packing| Remaining Area:#{remaining_area}"
      s << "\n"
      s << map(&:to_s).join
    end
  end
end
