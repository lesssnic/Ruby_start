require './lib/modules/module_check'

RSpec.describe Expander do
  let(:old_path) { './temp/file.csv' }
  let(:new_path) { './temp/new-file.csv' }
  let(:string_example) { 'ABC test string' }
  let(:string_fixed) { ' test string' }
  let(:dummy) { Class.new { extend Expander } }

  context 'when generate new path for new file' do
    it 'expected new path' do
      expect(dummy.generate_path(old_path)).to eq(new_path)
    end

    it 'not expected old path' do
      expect(dummy.generate_path(old_path)).not_to eq(old_path)
    end

    it 'expected nil' do
      expect(dummy.generate_path('')).to eq(nil)
    end

    it ' not expected nil' do
      expect(dummy.generate_path('test')).not_to eq(nil)
    end
  end

  context 'when change string' do
    it 'expected changed string' do
      expect(dummy.fix_string(string_example)).to eq(string_fixed)
    end

    it 'not expected old string' do
      expect(dummy.fix_string(string_example)).not_to eq(string_example)
    end

    it 'expected not changed empty string' do
      expect(dummy.fix_string('')).to eq('')
    end
  end
end
