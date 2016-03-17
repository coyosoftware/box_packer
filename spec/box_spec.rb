require 'box_packer/box'
require 'box_packer/item'

module BoxPacker
  describe Box do
    subject(:box) { Box.new(dimensions, position: position) }
    let(:dimensions) { Dimensions[25, 30] }
    let(:position) { Position[10, 25] }
    let(:item) { Item.new(Dimensions[5, 2]) }

    context 'if no position is given' do
      let(:position) { nil }

      it 'defaults to origin position' do
        expect(box.position).to eql(Position[0, 0])
      end
    end

    describe '#orient!' do
      before { box.orient! }
      it { expect(box.dimensions).to eql(Dimensions[25, 30]) }
    end

    describe '#sub_boxes_args' do
      let(:expected_args) do
        [
          [Dimensions[20, 2], position: Position[15, 25]],
          [Dimensions[25, 28],  position: Position[10, 27]]
        ]
      end

      it 'calculates the correct dimensions and positions' do
        expect(box.send(:sub_boxes_args, item)).to eql(expected_args)
      end
    end

    describe '#sub_boxes' do
      it 'orders sub-boxes by areas' do
        sub_boxes = box.sub_boxes(item)
        expect(sub_boxes[0].area).to be >= (sub_boxes[1].area)
      end

      context 'with an item that reaches a side' do
        let(:item) { Box.new(Dimensions[15, 2]) }

        it 'only returns 2 sub-boxes' do
          sub_boxes = box.sub_boxes(item)
          expect(sub_boxes.length).to eql(2)
        end
      end
    end
  end
end
