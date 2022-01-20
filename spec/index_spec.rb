require './lib/index'

RSpec.describe Check do
  # let(:file) { 'spec/test.txt' }
  file_path = 'spec/test.txt'
  empty_file_path = 'spec/not_exists.txt'
  before(:all) do
    File.new(file_path, 'w+')
  end

  after(:all) do
    File.delete(file_path)
  end

  describe 'BOM check' do
    let(:file) { File.open(file_path, 'w+') }

    context 'when file is empty' do
      let(:result) do
        described_class.new(file_path).check_and_fix_file
      end

      it 'expected path' do
        expect(result[0]).to eq(nil)
      end

      it 'expected message' do
        expect(result[1]).to eq('File is empty')
      end
    end

    context 'when file not exists' do
      let(:result) do
        described_class.new(empty_file_path).check_and_fix_file
      end

      it 'expected path' do
        expect(result[0]).to eq(nil)
      end

      it 'expected message' do
        expect(result[1]).to eq('File not exists')
      end
    end

    context 'when file without BOM' do
      let(:result) do
        opened_file = file
        opened_file.rewind
        opened_file.puts('test text without BOM')
        opened_file.rewind
        opened_file.close
        described_class.new(file_path).check_and_fix_file
      end

      it 'expected path' do
        expect(result[0]).to eq(file_path)
      end

      it 'expected message' do
        expect(result[1]).to eq('Normal file')
      end
    end

    context 'when file with BOM' do
      let(:result) do
        opened_file = file
        opened_file.rewind
        opened_file.puts("#{[239, 187, 191, 32, 54, 87, 10].pack('C*')} with BOM")
        opened_file.rewind
        opened_file.close
        described_class.new(file_path).check_and_fix_file
      end

      it 'expected path' do
        expect(result[0]).to eq(file_path)
      end
      # it 'not expected nil' do
      #   expect(result[0]).to.not eq(nil)
      # end

      it 'expected message' do
        expect(result[1]).to eq('Success')
      end
    end
    # context 'test private method' do
    #   it {
    #     check = Check.new('./test.txt')
    #     expect(check.send(:fix_file)).to eql([[], 'Success'])
    #   }
    # end
  end
end
