require_relative 'box'
require_relative 'dimensions'

module BoxPacker
  class Item < Box
    attr_accessor :label
    attr_reader :color
    attr_reader :id

    def initialize(dimensions, opts = {})
      super(Dimensions[*dimensions])
      @label          = opts[:label].to_s
      @color          = opts[:color] || '%06x' % (rand * 0xffffff)
      @allow_rotation = opts[:allow_rotation].nil? ?  true : opts[:allow_rotation]
      @id             = opts[:id]
    end

    def rotate_to_fit_into(box)
      if @allow_rotation
        each_rotation do |rotation|
          if box.dimensions >= rotation
            @dimensions = rotation
            return true
          end
        end
      else
        if box.dimensions >= dimensions
          @dimensions = dimensions
          return true
        end
      end
      false
    end

    def to_s
      s = '|     Item|'
      s << " #{label}" if label
      s << " #{dimensions} #{position} Area:#{area}"
      s << "\n"
    end
  end
end
