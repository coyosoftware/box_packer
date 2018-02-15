require 'rasem'

module BoxPacker
  class SVGExporter
    def initialize(container, options = {})
      @container = container
      @opts = options
      @images = []
      @margin  = opts[:margin] || 0
      @desired_id = opts[:desired_id]
    end

    def save(filename)
      if @desired_id.nil?
        images.each_with_index do |image, i|
          image.close

          File.open("#{filename}#{i + 1}.svg", 'w') do |f|
            f << image.output
          end
        end
      else
        image = images.first
        image.close

        File.open("#{filename}.svg", 'w') do |f|
          f << image.output
        end
      end
    end

    def draw
      if @desired_id.nil?
        container.packings.each do |packing|
          image_for(packing)
        end
      else
        desired_packing = container.packings.find do |packing|
          packing.find do |item|
            item.id == @desired_id
          end
        end

        image_for(desired_packing)
      end
    end

    private

    attr_reader :container, :scale, :margin, :images, :image, :image_width, :image_height, :opts

    def image_for(packing)
      dimensions = if opts[:remove_exceeding]
        if container.orientation == :width
          Dimensions[packing.used_width, container.dimensions_without_offsets.y]
        else
          Dimensions[container.dimensions_without_offsets.x, packing.used_height]
        end
      else
        container.dimensions_without_offsets
      end

      legend_size = 20
      legend_padding = 10
      scale_size = opts[:scale_size] || :longest
      scale_size_to = opts[:scale_size_to] || 400

      side_to_scale = case opts[:scale_size]
      when :width
        dimensions.to_a[0]
      when :height
        dimensions.to_a[1]
      else
        dimensions.to_a.max
      end

      @scale = scale_size_to / side_to_scale.to_f
      @image_width  = (dimensions.to_a[0] * scale) + (margin * 3)
      @image_height = (dimensions.to_a[1] * scale) + (margin * 3)

      Face.reset(margin, scale, dimensions)
      new_image

      face = Face.new(packing)
      image.rectangle(*face.outline, stroke: 'black', stroke_width: 1, fill: 'white')
      face.rectangles_and_labels.each do |h|
        image.rectangle(*h[:rectangle])
        image.text(*h[:label])
      end
    end

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
          label_x = x + 5
          label_y = y + height / 2

          {
            rectangle: [x, y, width, height, fill: "##{item.color}", stroke: 'black', stroke_width: 1, :"stroke-dasharray" => "2,2"],
            label: [label_x, label_y, "#{item.label}", :"font-size" => "#{15 * @@scale}px"]
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
