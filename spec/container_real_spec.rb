require 'box_packer/container'

module BoxPacker
  describe Container do
    subject(:container) { Container.new([30, 32]) }

    it "ss" do
      box = nil

      height = 0
      loop do
        box = BoxPacker.container [100, height], packings_limit: 1, orientation: :height do
          add_item [100,300], label: 'L1', allow_rotation: false
          add_item  [70,100], label: 'L2', allow_rotation: false
          add_item  [70,200], label: 'L3', allow_rotation: false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_1")

      height = 0
      loop do
        box = BoxPacker.container [150, height], packings_limit: 1, orientation: :height do
          add_item [100,300], label: 'L1', allow_rotation: false
          add_item  [70,100], label: 'L2', allow_rotation: false
          add_item  [70,200], label: 'L3', allow_rotation: false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_2")

      height = 0
      loop do
        box = BoxPacker.container [200, height], packings_limit: 1, orientation: :height do
          add_item [100,300], label: 'L1', allow_rotation: false
          add_item  [70,100], label: 'L2', allow_rotation: false
          add_item  [70,200], label: 'L3', allow_rotation: false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_3")

      offsets = {
        top:    5,
        bottom: 5,
        left:   0,
        right:  0
      }
      height = 0
      loop do
        box = BoxPacker.container [200, height], packings_limit: 1, orientation: :height, offsets: offsets do
          add_item [100,300], label: 'L1', allow_rotation: false
          add_item  [70,100], label: 'L2', allow_rotation: false
          add_item  [70,200], label: 'L3', allow_rotation: false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_4")

      height = 0
      loop do
        box = BoxPacker.container [height, 100], packings_limit: 1, orientation: :width do
          add_item [300,100], label: 'L1', allow_rotation: false
          add_item  [100,70], label: 'L2', allow_rotation: false
          add_item  [200,70], label: 'L3', allow_rotation: false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_5")

      height = 0
      loop do
        box = BoxPacker.container [height, 150], packings_limit: 1, orientation: :width do
          add_item [300,100], label: 'L1', allow_rotation: false
          add_item  [100,70], label: 'L2', allow_rotation: false
          add_item  [200,70], label: 'L3', allow_rotation: false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_6")

      height = 0
      loop do
        box = BoxPacker.container [height, 200], packings_limit: 1, orientation: :width do
          add_item [300,100], label: 'L1', allow_rotation: false
          add_item  [100,70], label: 'L2', allow_rotation: false
          add_item  [200,70], label: 'L3', allow_rotation: false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_6")

      offsets = {
        left:   5,
        right:  5,
        top:    0,
        bottom: 0
      }
      height = 0
      loop do
        box = BoxPacker.container [height, 200], packings_limit: 1, orientation: :width, offsets: offsets do
          add_item [300,100], label: 'L1', allow_rotation: false
          add_item  [100,70], label: 'L2', allow_rotation: false
          add_item  [200,70], label: 'L3', allow_rotation: false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_7")
    end
  end
end
