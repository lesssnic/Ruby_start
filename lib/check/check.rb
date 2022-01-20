class Check
  BYTE8 = [239, 187, 191].freeze
  def initialize(file_path)
    @path = file_path
  end

  def check_and_fix_file
    return [nil, 'File not exists'] unless File.file?(@path)

    return [nil, 'File is empty'] if File.zero?(@path)

    @file = File.open(@path, 'r+')

    @array = @file.gets.bytes
    @array = @file.gets.bytes if @array.empty?
    array, status = fix_file(@array)
    @file.rewind
    @file.puts(array.pack('C*'))
    @file.close
    [@path, status]
  end

  private

  def fix_file(array)
    return [array, 'Normal file'] unless array[0..2] == BYTE8

    array.shift(3)
    array.unshift(32)
    [array, 'Success']
  end
end
