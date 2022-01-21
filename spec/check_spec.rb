require './lib/index'

RSpec.describe Check do
  let(:file_path) { 'temp/test.txt' }
  let(:new_file_path) { 'temp/new-test.txt' }
  let(:empty_file_path) { 'temp/not_exists.txt' }

  before do
    File.new(file_path, 'w+')
  end

  after do
    File.delete(file_path)
  end

  describe 'BOM check' do
    subject(:result) do
      described_class.new(file_path).check_and_fix_file
    end

    context 'when file is empty' do
      it 'expected path' do
        expect(result[0]).to eq(nil)
      end

      it 'Path not expected string' do
        expect(result[0]).not_to be_a(String)
      end

      it 'expected message' do
        expect(result[1]).to eq('File is empty')
      end

      it 'Status not expected nil' do
        expect(result[1]).not_to eq(nil)
      end

      it 'file should be empty' do
        result
        expect(File.zero?(file_path)).to eq(true)
      end

      it 'file should not be fill' do
        result
        expect(File.zero?(file_path)).not_to eq(false)
      end
    end

    context 'when file not exists' do
      subject(:result) do
        described_class.new(empty_file_path).check_and_fix_file
      end

      it 'expected path' do
        expect(result[0]).to eq(nil)
      end

      it 'Path not expected string' do
        expect(result[0]).not_to be_a(String)
      end

      it 'expected message' do
        expect(result[1]).to eq('File not exists')
      end

      it 'Status not expected nil' do
        expect(result[1]).not_to eq(nil)
      end

      it 'file should not be exists' do
        result
        expect(File.file?(empty_file_path)).to eq(false)
      end

      it 'file should be exists' do
        described_class.new(file_path).check_and_fix_file
        expect(File.file?(file_path)).not_to eq(false)
      end
    end

    context 'when file without BOM' do
      before do
        opened_file = File.open(file_path, 'w+')
        opened_file.rewind
        opened_file.puts('test text without BOM')
        opened_file.rewind
        opened_file.close
      end

      it 'expected path' do
        expect(result[0]).to eq(file_path)
      end

      it 'Path not expected nil' do
        expect(result[0]).not_to eq(nil)
      end

      it 'expected message' do
        expect(result[1]).to eq('Normal file')
      end

      it 'Status not expected nil' do
        expect(result[1]).not_to eq(nil)
      end

      it 'file should not be a changed' do
        result
        opened_file = File.open(file_path, 'r')
        expect(opened_file.read).to eq("test text without BOM\n")
      end
    end

    context 'when file with BOM' do
      before do
        opened_file = File.open(file_path, 'w+')
        opened_file.rewind
        opened_file.puts("#{[239, 187, 191].pack('C*')}With BOM")
        opened_file.rewind
        opened_file.close
      end

      it 'expected path' do
        expect(result[0]).to eq(new_file_path)
      end

      it 'Path not expected nil' do
        expect(result[0]).not_to eq(nil)
      end

      it 'expected message' do
        expect(result[1]).to eq('Success')
      end

      it 'Status not expected nil' do
        expect(result[1]).not_to eq(nil)
      end

      it 'file should be a changed' do
        result
        opened_file = File.open(new_file_path, 'r')
        expect(opened_file.read).to eq("With BOM\n")
        File.delete(new_file_path)
      end
    end
  end
end
