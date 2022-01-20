require './lib/index'

RSpec.describe Check do
  # let(:file) { 'spec/test.txt' }
  file_path = 'spec/test.txt'
  before(:all) do
    File.new(file_path, 'w+')
    $file = File.open(file_path, 'r+')
  end
  after(:all) do
    File.delete(file_path)
  end

  describe 'BOM check' do
    context 'when file is empty' do
      it do
        check = Check.new(file_path)
        expect(check.check_and_fix_file).to eql([nil, 'File is empty'])
      end
    end
    context 'when file not exists' do
      it do
        check = Check.new('./BOM-not-exists.txt')
        expect(check.check_and_fix_file).to eql([nil, 'File not exists'])
      end
    end
    context 'when file without BOM' do
      let(:result) do
        $file.rewind
        $file.puts('test text without BOM')
        $file.rewind
        Check.new(file_path).check_and_fix_file
      end
      it 'expected path' do
        expect(result[0]).to eq(file_path)
      end
      it 'expected message' do
        expect(result[1]).to eq('Normal file')
      end
    end
    context 'when file with BOM' do
      it do
        $file.rewind
        $file.puts([239, 187, 191, 32, 54, 87, 10].pack('C*') + 'with BOM')
        $file.rewind
        check = Check.new(file_path)
        expect(check.check_and_fix_file).to eql([file_path, 'Success'])
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
