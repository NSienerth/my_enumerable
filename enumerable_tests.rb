# frozen_string_literal: true

require './my_enumerable'
my_proc = proc { |count, obj| count + obj }
tests = [1..5, %w[a b c d e], { a: 'b', c: 5, 6 => 'f' }]
tests.size.times do |set|
  print(tests[set].inject(:+))
  puts ''
  print(tests[set].my_inject(:+))
  puts ''
end
