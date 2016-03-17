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

    def to_s
      s = "|  Packing| Remaining Area:#{remaining_area}"
      s << "\n"
      s << map(&:to_s).join
    end
  end
end
