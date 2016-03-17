require 'box_packer/dimensions'

module BoxPacker
  describe Dimensions do
    subject(:dimensions) { Dimensions[2, 10] }

    describe '#area' do
      it { expect(dimensions.area).to eql(20) }
    end

    describe '#>=' do
      context 'when compared with Dimensions that are all bigger' do
        let(:other_dimensions) { Dimensions[1, 5] }
        it { expect(dimensions >= other_dimensions).to be(true) }
      end

      context 'when compared with Dimensions where some are bigger and some are equal' do
        let(:other_dimensions) { Dimensions[2, 5] }
        it { expect(dimensions >= other_dimensions).to be(true) }
      end

      context 'when compared with Dimensions that are all equal' do
        let(:other_dimensions) { Dimensions[2, 10] }
        it { expect(dimensions >= other_dimensions).to be(true) }
      end

      context 'when compared with Dimensions where some are bigger and some are smaller' do
        let(:other_dimensions) { Dimensions[5, 5] }
        it { expect(dimensions >= other_dimensions).to be(false) }
      end

      context 'when compared with Dimensions where none are bigger' do
        let(:other_dimensions) { Dimensions[5, 15] }
        it { expect(dimensions >= other_dimensions).to be(false) }
      end
    end

    describe '#each_rotation' do
      let(:rotations)do
        [
          Dimensions[2, 10],
          Dimensions[10, 2]
        ]
      end

      it 'matches all rotations' do
        results = []
        dimensions.each_rotation { |r| results.push(r) }
        expect(results).to match_array(rotations)
      end
    end
  end
end
