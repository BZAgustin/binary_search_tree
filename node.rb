# frozen_string_literal: true

class Node
  attr_accessor :value, :left_child, :right_child

  def initialize(value, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end

  def deconstruct
    puts "deconstruct called"
    [@value, @left_child, @right_child]
  end

  def is_leaf?
    self.left_child == nil && self.right_child == nil
  end

  def has_2_children?
    self.left_child && self.right_child
  end
end