# frozen_string_literal: true

# lib/index.rb

require_relative 'check/check'

check = Check.new('./temp/BOM.txt')
p check.check_and_fix_file
