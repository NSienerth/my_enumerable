# frozen_string_literal: true

# Rewriting all Enumerable functions in my own idiom
module Enumerable

  def my_each
    return self.to_enum(:my_each) unless block_given?

    for k, v in self
      yield v.nil? ? k : [k, v]
    end
  end

  def my_each_with_index
    return self.to_enum(:my_each_with_index) unless block_given?

    index = 0
    for k, v in self
      v.nil? ? yield(k, index) : yield([k, v], index)
      index += 1
    end
  end

  def my_select
    return to_enum(:my_each_with_index) unless block_given?

    selections = self.class.new
    my_each do |key, value|
      if value.nil? && yield(key)
        selections << key
      elsif yield(key, value)
        selections[key] = value
      end
    end
    selections
  end

  def my_all?(*args)
    return (my_all? { |obj| args[0] === obj }) if args.size.positive?
    return (my_all? { |obj| obj }) unless block_given?

    my_each do |obj|
      return false unless yield obj
    end
    true
  end

  def my_any?(*args)
    return (my_any? { |obj| args[0] === obj }) if args.size.positive?
    return (my_any? { |obj| obj }) unless block_given?

    my_each do |obj|
      return true if yield obj
    end
    false
  end

  def my_none?(*args)
    return (my_none? { |obj| args[0] === obj }) if args.size.positive?
    return (my_none? { |obj| obj }) unless block_given?

    my_each do |obj|
      return false if yield obj
    end
    true
  end

  def my_count(arg = nil, &my_block)
    return (my_select { |obj| obj == arg }).size if arg
    return my_select(&my_block).size if block_given?

    size
  end
end
