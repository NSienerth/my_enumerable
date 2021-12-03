# frozen_string_literal: true

require './my_enumerable'

tests = [[1, 2, 3, 4, 5], %w[a b c d e], [1, 'b', 3, 'd', false], { a: 'b', c: 5, 6 => 'f' }]
puts 'Testing'
tests.size.times do |set|
  print(tests[set].count { |obj| obj =~ /\w/ })
  puts ''
  print(tests[set].my_count { |obj| obj =~ /\w/ })
  puts ''
end
