require 'box_packer/container'

module BoxPacker
  describe Container do
    subject(:container) { Container.new([30, 32]) }

    it "ss" do
      box = nil

      height = 0
      loop do
        box = BoxPacker.container [100, height], packings_limit: 1, orientation: :height do
          add_item [100,300], label: 'L1', :allow_rotation => false
          add_item  [70,100], label: 'L2', :allow_rotation => false
          add_item  [70,200], label: 'L3', :allow_rotation => false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_1.svg")

      height = 0
      loop do
        box = BoxPacker.container [150, height], packings_limit: 1, orientation: :height do
          add_item [100,300], label: 'L1', :allow_rotation => false
          add_item  [70,100], label: 'L2', :allow_rotation => false
          add_item  [70,200], label: 'L3', :allow_rotation => false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_2.svg")

      height = 0
      loop do
        box = BoxPacker.container [200, height], packings_limit: 1, orientation: :height do
          add_item [100,300], label: 'L1', :allow_rotation => false
          add_item  [70,100], label: 'L2', :allow_rotation => false
          add_item  [70,200], label: 'L3', :allow_rotation => false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_3.svg")

      height = 0
      loop do
        box = BoxPacker.container [height, 100], packings_limit: 1, orientation: :width do
          add_item [300,100], label: 'L1', :allow_rotation => false
          add_item  [100,70], label: 'L2', :allow_rotation => false
          add_item  [200,70], label: 'L3', :allow_rotation => false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_4.svg")

      height = 0
      loop do
        box = BoxPacker.container [height, 150], packings_limit: 1, orientation: :width do
          add_item [300,100], label: 'L1', :allow_rotation => false
          add_item  [100,70], label: 'L2', :allow_rotation => false
          add_item  [200,70], label: 'L3', :allow_rotation => false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_5.svg")

      height = 0
      loop do
        box = BoxPacker.container [height, 200], packings_limit: 1, orientation: :width do
          add_item [300,100], label: 'L1', :allow_rotation => false
          add_item  [100,70], label: 'L2', :allow_rotation => false
          add_item  [200,70], label: 'L3', :allow_rotation => false
          pack!
        end

        height = height + 1
        
        break if box.packed_successfully
      end
      box.draw!("example_6.svg")
    end
  end
end
