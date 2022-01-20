byte = [239, 187, 191]
if !File.zero?('BOM.txt')
  file = File.open('BOM.txt', 'r+')
  array = file.readline.bytes
  array.shift(3) if array[0..2] == byte
  file.rewind
  file.puts(array.pack('C*'))
else
  p 'file is empty'
end

class Check
  @file
  def initialize(file_path)
    @path = file_path
    @byte8 = [239, 187, 191]
  end

  def isEmpty
    File.zero?(@path)
  end

  def check_and_fix_file
    if !isEmpty
      @file = File.open(@path, 'r+')
      array = @file.readline.bytes
      if array[0..2] == @byte8
        fixFile(array)
      else
        [nil, 'Normal file', @path]
      end
    else
      'file is empty'
    end
  end

  def fixFile(array)
    array.shift(3)
    @file.rewind
    @file.puts(array.pack('C*'))
    @file.close
    ['Success', @path]
  end
end

check = Check.new('tmp.csv')

puts check.check_and_fix_file
