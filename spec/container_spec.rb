require 'box_packer/container'

module BoxPacker
  describe Container do
    subject(:container) { Container.new([30, 32]) }

    it { expect(container.packings).to eql(nil) }

    context 'with items' do
      let(:items) do
        [
          Item.new([15, 26]),
          Item.new([2,  1]),
          Item.new([9,  9])
        ]
      end
      before { container.items = items }

      context 'with container prepared' do
        before do
          container.send(:prepare_to_pack!)
        end

        describe '#prepare_to_pack!' do
          let(:expected_dimensions)do
            [
              Dimensions[15, 26],
              Dimensions[2, 1],
              Dimensions[9, 9]
            ]
          end

          it { expect(container.items.map(&:dimensions)).to eql(expected_dimensions) }
          it { expect(container.packings).to eql([]) }
        end

        context 'with some items packed' do
          before do
            container.new_packing!
            container.packing << items[1]
            container.packing << items[2]
          end

          it { expect(container.packings.length).to eql(1) }
          it { expect(container.packing).to match_array([items[1], items[2]]) }

          describe '#new_packing!!' do
            before { container.new_packing! }
            it { expect(container.packings.length).to eql(2) }
            it { expect(container.packing).to eql([]) }
          end
        end
      end

      describe '#packable?' do
        context 'with no items' do
          before { container.items = [] }
          it { expect(container.send(:packable?)).to be(false) }
        end

        context 'with items that fit' do
          it { expect(container.send(:packable?)).to be(true) }
        end

        context 'with an item to large' do
          before { container.items[0].dimensions = Dimensions[26, 34] }
          it { expect(container.send(:packable?)).to be(false) }
        end
      end

      describe "#used_width" do
        context "not packed yet" do
          it { expect(container.send(:used_width)).to be_nil }
        end

        context "packed" do
          context "for width orientation" do
            subject(:container) { Container.new([30, 32], orientation: :width) }

            before do
              container.send(:pack!)
            end

            it { expect(container.send(:used_width)).to match_array([24]) }
          end

          context "for height orientation" do
            subject(:container) { Container.new([30, 32], orientation: :height) }

            before do
              container.send(:pack!)
            end

            it { expect(container.send(:used_width)).to match_array([24]) }
          end
        end
      end

      describe "#remaining_width" do
        context "not packed yet" do
          it { expect(container.send(:remaining_width)).to be_nil }
        end

        context "packed" do
          context "for width orientation" do
            subject(:container) { Container.new([30, 32], orientation: :width) }

            before do
              container.send(:pack!)
            end

            it { expect(container.send(:remaining_width)).to match_array([6]) }
          end

          context "for height orientation" do
            subject(:container) { Container.new([30, 32], orientation: :height) }

            before do
              container.send(:pack!)
            end

            it { expect(container.send(:remaining_width)).to match_array([6]) }
          end
        end
      end

      describe "#used_height" do
        context "not packed yet" do
          it { expect(container.send(:used_height)).to be_nil }
        end

        context "packed" do
          context "for width orientation" do
            subject(:container) { Container.new([30, 32], orientation: :width) }

            before do
              container.send(:pack!)
            end

            it { expect(container.send(:used_height)).to match_array([26]) }
          end

          context "for height orientation" do
            subject(:container) { Container.new([30, 32], orientation: :height) }

            before do
              container.send(:pack!)
            end

            it { expect(container.send(:used_height)).to match_array([26]) }
          end
        end
      end

      describe "#remaining_height" do
        context "not packed yet" do
          it { expect(container.send(:remaining_height)).to be_nil }
        end

        context "packed" do
          context "for width orientation" do
            subject(:container) { Container.new([30, 33], orientation: :width) }

            before do
              container.send(:pack!)
            end

            it { expect(container.send(:remaining_height)).to match_array([7]) }
          end

          context "for height orientation" do
            subject(:container) { Container.new([30, 33], orientation: :height) }

            before do
              container.send(:pack!)
            end

            it { expect(container.send(:remaining_height)).to match_array([7]) }
          end
        end
      end
    end
  end
end
