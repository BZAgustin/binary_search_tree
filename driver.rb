# frozen_string_literal: true

require_relative 'tree.rb'

module Driver
  tree = Tree.new(Array.new(15) { rand(1..100) })

  tree.pretty_print

  p tree.balanced?

  p tree.preorder

  p tree.postorder

  p tree.inorder

  rand(4..7).times do |i|
    tree.insert(rand(100..300))
  end

  tree.pretty_print

  p tree.balanced?

  tree.rebalance

  tree.pretty_print

  p tree.balanced?

  p tree.preorder

  p tree.postorder

  p tree.inorder  
end
