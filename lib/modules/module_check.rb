module Expander
  def fix_string(string)
    array = string.bytes
    array.shift(3)
    array.pack('C*')
  end

  def generate_path(old_path)
    return nil if old_path.split('/').length <= 0

    new_path = old_path.split('/')
    new_path[new_path.length - 1] = "new-#{new_path[new_path.length - 1]}"
    new_path.join('/')
  end
end
