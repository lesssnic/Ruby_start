# class Check
#   BYTE8 = [239, 187, 191].freeze
#   BYTE16 = [254, 255].freeze
#   def initialize(file_path)
#     @path = file_path
#   end
#
#   def check_and_fix_file
#     return [nil, 'File not exists'] unless File.file?(@path)
#
#     return [nil, 'File is empty'] if File.zero?(@path)
#
#     @file = File.open(@path, 'r+')
#     pos = @file.pos
#     @array = @file.gets.force_encoding(Encoding::BINARY)
#     test = @array.bytes
#     # @array = @file.gets.encode('UTF-16').bytes if @array.empty?
#     string = @array.gsub("\xEF\xBB\xBF".force_encoding(Encoding::BINARY), '')
#     # @array = @file.gets.bytes.map { |c| c.chr }
#     # @array = @file.gets.bytes.map { |c| c.chr } if @array.empty?
#     # array, status = fix_file(@array)
#     # temp = array.pack('U*')
#     @file.pos = 1
#     @file.write(string)
#     @file.rewind
#     temp2 = @file.gets.bytes
#     @file.close
#     [@path, status]
#   end
#
#   private
#
#   def fix_file(array)
#     te = array[0..1]
#     return [array, 'Normal file'] unless te == BYTE8
#
#     array.shift(3)
#     [array, 'Success']
#   end
# end
require_relative '../modules/module_check'

class Check
  include Expander
  BYTE8 = [239, 187, 191].freeze
  def initialize(file_path)
    @path = file_path
  end

  def check_and_fix_file
    return [nil, 'File not exists'] unless File.file?(@path)

    return [nil, 'File is empty'] if File.zero?(@path)

    @file = File.open(@path, 'r')
    return [@path, 'Normal file'] unless check_file(@file.gets)

    new_path = generate_path(@path)
    @file.rewind
    new_f = new_file(new_path)
    string = fix_string(@file.gets)
    new_f.write(string.downcase) if string.length > 2
    @file.readlines.each do |line|
      new_f.write(line.downcase) if line.length > 2
    end
    new_f.close
    @file.close
    [new_path, 'Success']
  end

  private

  def check_file(string)
    bytes_array = string.bytes
    return false unless bytes_array[0..2] == BYTE8

    true
  end

  def new_file(path)
    File.open(path, 'w+')
  end
end
