# frozen_string_literal: true

# Rewriting all Enumerable functions in my own idiom
module Enumerable

  def my_each
    return to_enum(:my_each) unless block_given?

    for k, v in self
      yield v.nil? ? k : [k, v]
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

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

  def my_map(my_proc = nil)
    return to_enum(:my_map) unless block_given? || my_proc

    result = []
    if my_proc
      my_each { |item| result.push(my_proc.call(item)) }
    else
      my_each { |item| result.push(yield item) }
    end
    result
  end

  def my_inject(memo = nil, mod = nil)
    return to_enum(:my_inject) unless block_given? || mod.is_a?(Symbol) || memo.is_a?(Symbol)

    mod, memo = memo, mod if memo.is_a?(Symbol)
    collection = to_a
    memo ||= collection.shift
    if mod
      collection.my_each { |k| memo = memo.send(mod, k) }
    else
      collection.my_each { |k| memo = yield(memo, k) }
    end
    memo
  end
end
