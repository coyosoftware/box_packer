require 'box_packer/packer'
require 'box_packer/container'

module BoxPacker
  describe Packer do
    subject(:container) { Container.new(dimensions) }
    let(:dimensions) { [10, 15] }
    let(:opts) { nil }
    let(:items)do
      [
        Item.new([1, 1]),
        Item.new([3, 1]),
        Item.new([5, 5]),
      ]
    end

    describe '#pack' do
      context 'with items that fit exactly in one packing' do
        before do
          20.times { container.items << items[0].dup }
          10.times { container.items << items[1].dup }
          4.times { container.items << items[2].dup }
        end

        it do
          expect(container.pack!).to eql(1)
          expect(container.packed_successfully).to be(true)
        end
      end

      context 'with items that fit exactly in three packings' do
        before do
          35.times { container.items << items[0].dup }
          30.times { container.items << items[1].dup }
          10.times { container.items << items[2].dup }
        end

        it do
          expect(container.pack!).to eql(3)
          expect(container.packed_successfully).to be(true)
        end
      end

      context 'with a packing limit of one and too many items' do
        before do
          container.packings_limit = 1
          35.times { container.items << items[0].dup }
          30.times { container.items << items[1].dup }
          10.times { container.items << items[2].dup }
        end

        it do
          expect(container.pack!).to be(false)
          expect(container.packed_successfully).to be(false)
        end
      end

      context 'with random container and random items' do
        let(:dimensions) { [x, y] }
        let(:x) { rand(1..75) }
        let(:y) { rand(1..75) }

        let(:items) do
          (1..rand(1..100)).map do
            Item.new([x / rand(1..5), y / rand(1..5)])
          end
        end

        before do
          container.items = items
          container.pack!
        end

        it { expect(container.packed_successfully).to be(true) }
      end
    end
  end
end
