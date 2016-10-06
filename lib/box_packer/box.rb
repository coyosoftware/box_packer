require 'forwardable'
require_relative 'position'
require_relative 'dimensions'

module BoxPacker
  class Box
    extend Forwardable

    def initialize(dimensions, opts = {})
      @dimensions_wihout_offsets = dimensions

      position_x = 0
      position_y = 0

      if opts[:offsets].nil?
        @dimensions = dimensions
      else
        @dimensions = dimensions - Dimensions[opts[:offsets][:right].to_i, opts[:offsets][:top].to_i] - Dimensions[opts[:offsets][:left].to_i, opts[:offsets][:bottom].to_i]

        position_x = opts[:offsets][:left].to_i
        position_y = opts[:offsets][:bottom].to_i
      end

      @position = opts[:position] || Position[position_x, position_y]
    end

    def_delegators :dimensions, :area, :each_rotation, :width, :height
    attr_accessor :dimensions, :position, :dimensions_wihout_offsets

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
