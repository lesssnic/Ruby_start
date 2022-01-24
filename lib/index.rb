# frozen_string_literal: true

# lib/index.rb

require_relative 'check/check'

# check = Check.new('./temp/BOM.txt')
# p check.check_and_fix_file

blockbusters = [['will smith', 'i am legend'], ['brad pitt', 'fight club'], ['frodo', 'the hobbit']]
result = blockbusters.each_with_object({}) do |elem, acc|
  acc[elem[0].to_sym] = elem[1]
end

pp result
