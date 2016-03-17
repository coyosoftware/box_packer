require 'forwardable'
require_relative 'position'
require_relative 'dimensions'

module BoxPacker
  class Box
    extend Forwardable

    def initialize(dimensions, opts = {})
      @dimensions = dimensions
      @position = opts[:position] || Position[0, 0]
    end

    def_delegators :dimensions, :area, :each_rotation, :width, :height
    attr_accessor :dimensions, :position

    def orient!
      @dimensions = Dimensions[*dimensions.to_a]
    end

    def >=(other)
      dimensions >= other.dimensions
    end

    def sub_boxes(item)
      sub_boxes = sub_boxes_args(item).select { |(d, _)| d.area > 0 }
      sub_boxes.map! { |args| Box.new(*args) }
      sub_boxes.sort_by!(&:area).reverse!
    end

    private

    def sub_boxes_args(item)
      if @orientation == :width
        [[width +           height - item.width,  position: position + item.width],
         [item.width +      height - item.height, position: position + item.height]]
       else
        [[width +           item.height - item.width,  position: position + item.width],
         [width +      height - item.height, position: position + item.height]]
      end
    end
  end
end
