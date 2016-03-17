require 'rasem'

module BoxPacker
  class SVGExporter
    def initialize(container, opts = {})
      @container = container
      @images = []
      @margin  = opts[:margin] || 10

      dimensions = container.dimensions.to_a
      longest_side = dimensions.max
      legend_size = 20
      legend_padding = 10
      scale_longest_side_to = opts[:scale_longest_side_to] || 400

      @scale = scale_longest_side_to / longest_side.to_f
      @image_width  = (dimensions[0] * scale) + (margin * 3)
      @image_height = ((dimensions[1] * scale + ((legend_padding + legend_size) * container.packing.count)))  + (margin * 3)
    end

    def save(filename)
      images.each_with_index do |image, i|
        image.close

        File.open("#{filename}#{i + 1}.svg", 'w') do |f|
          f << image.output
        end
      end
    end

    def draw
      container.packings.each do |packing|
        Face.reset(margin, scale, container.dimensions)
        new_image

        face = Face.new(packing)
        image.rectangle(*face.outline, stroke: 'black', stroke_width: 1, fill: 'white')
        face.rectangles_and_labels.each do |h|
          image.rectangle(*h[:rectangle])
          image.rectangle(*h[:legend][:rectangle])
          image.text(*h[:legend][:label])
        end
      end
    end

    private

    attr_reader :container, :scale, :margin, :images, :image, :image_width, :image_height

    def new_image
      @image = Rasem::SVGImage.new(image_width, image_height)
      images << image
    end

    class Face
      attr_reader :width, :height, :axes

      def self.reset(margin, scale, container_dimensions)
        @@coords_mapping = [:x, :y]
        @@front = true
        @@margin = margin
        @@axes = [margin, margin]
        @@scale = scale
        @@container_dimensions = container_dimensions
        @@legend_padding = 10
      end

      def iterate_class_variables
        if front
          @@axes[0] = width + @@margin
        else
          @@coords_mapping.rotate!
          @@axes[0] = @@margin
          @@axes[1] += height + @@margin
        end
        @@front = !@@front
      end

      def initialize(packing)
        @i, @j = @@coords_mapping.dup
        @front = @@front
        @axes = @@axes.dup
        @width = @@container_dimensions.width.x * @@scale
        @height = @@container_dimensions.height.y * @@scale
        iterate_class_variables
        @items = sorted_items(packing)
      end

      def outline
        @axes + [width, height]
      end

      def rectangles_and_labels
        items.each_with_index.map do |item, index|
          x = axes[0] + item.position.send(i) * @@scale
          y = axes[1] + item.position.send(j) * @@scale
          width = item.dimensions.send(i) * @@scale
          height = item.dimensions.send(j) * @@scale
          label_x = x + width / 2 - item.label.length
          label_y = y + height / 2
          legend_x = 10
          legend_y = @height + @@legend_padding + (20 * index) + @@legend_padding * (index + 1)
          label_legend_x = legend_x + 25
          label_legend_y = legend_y + 15
          {
            rectangle: [x, y, width, height, fill: "##{item.color}", stroke: 'black', stroke_width: 1, :"stroke-dasharray" => "2,2"],
            label: [label_x, label_y, item.label],
            legend: {
              rectangle: [legend_x, legend_y, 20, 20, fill: "##{item.color}", stroke: 'black', stroke_width: 1],
              label: [label_legend_x, label_legend_y, "#{item.label}"]
            }
          }
        end
      end

      private

      attr_reader :packing, :i, :j, :front, :items

      def sorted_items(packing)
        items = packing
        items.reverse! unless front
        items
      end
    end
  end
end
