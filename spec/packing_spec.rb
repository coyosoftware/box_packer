require 'box_packer/packing'
require 'box_packer/item'

module BoxPacker
  describe Packing do
    subject(:packing) { Packing.new(total_area) }
    let(:total_area) { 60 }
    let(:items) do
      [
        Item.new([2, 4]),
        Item.new([5, 2]),
        Item.new([8, 4])
      ]
    end

    it 'defaults to empty' do
      expect(packing).to eql([])
    end

    describe '#<<' do
      before { items.each { |i| packing << i } }

      it { expect(packing.remaining_area).to eql(10) }
    end

    describe '#fit?' do
      before { items.each { |i| packing << i } }

      context 'with item that fits' do
        let(:item) { Item.new([1, 5]) }
        it { expect(packing.fit?(item)).to be(true) }
      end

      context 'with item thats already packed' do
        it { expect(packing.fit?(items[0])).to be(false) }
      end

      context 'with item thats too large' do
        let(:item) { Item.new([3, 5]) }
        it { expect(packing.fit?(item)).to be(false) }
      end
    end
  end
end
