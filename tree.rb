# frozen_string_literal: true

require_relative './node.rb'

class Tree
  attr_accessor :root

  def initialize array
    @root = build_tree(array)
  end

  def build_tree(arr)
    # Remove duplicates and sort the array
    arr = arr.uniq.sort

    return Node.new(arr[0]) if arr.length == 1
    return Node.new(arr[0], nil, Node.new(arr[1])) if arr.length == 2
    
    middle = arr.length / 2
    left = arr[0..middle-1]
    right = arr[middle + 1..-1]
    
    Node.new(arr[middle], build_tree(left), build_tree(right))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  def insert(value, root_node = @root)
    if root_node.is_leaf?
      value < root_node.value ? root_node.left_child = Node.new(value) : root_node.right_child = Node.new(value)   
    elsif value < root_node.value
      if root_node.left_child
        insert(value, root_node.left_child) if root_node.left_child
      elsif root_node.right_child
        insert(value, root_node.right_child) if root_node.right_child
      end
    elsif value > root_node.value
      if root_node.right_child
        insert(value, root_node.right_child) if root_node.right_child
      elsif root_node.left_child
        insert(value, root_node.left_child) if root_node.left_child
      end
    else
      return nil
    end
  end

  def delete(value, root_node = @root)
    if root_node.left_child.value == value
      # remove left child
      case root_node.left_child.deconstruct
        in [v, nil, nil]
          root_node.left_child = nil
        in [v, ln, nil]
          root_node.left_child = ln
        in [v, nil, rn]
          root_node.left_child = rn
        in [v, ln, rn]
          root_node.left_child = reach_next_inorder(rn)
          root_node.left_child.left_child = ln
      end
          
    elsif root_node.right_child.value == value
      # remove right child
      case root_node.right_child.deconstruct
        in [v, nil, nil]
          root_node.right_child = nil
        in [v, ln, nil]
          root_node.right_child = ln
        in [v, nil, rn]
          root_node.right_child = rn
        in [v, ln, rn]
          root_node.right_child = reach_next_inorder(rn)
          root_node.right_child.left_child = ln
      end
    else
      delete(value, root_node.left_child) if value < root_node.value
      delete(value, root_node.right_child) if value > root_node.value
    end
  end

  def reach_next_inorder(node)
    return node if node.is_leaf? || node.left_child == nil

    reach_next_inorder(node.left_child)
  end

  def find(value, root_node = @root)
    return root_node if value == root_node.value || root_node.is_leaf?

    node = find(value, root_node.left_child) if value < root_node.value
    node = find(value, root_node.right_child) if value > root_node.value

    node
  end

  def level_order(root_node = @root)
    queue = [root_node]
    visited = []

    until queue.empty?
      queue.push(queue[0].left_child) if queue[0].left_child != nil
      queue.push(queue[0].right_child) if queue[0].right_child != nil
      visited.push(queue[0])
      queue.shift
    end

    if block_given?
      visited.each { |i| yield(i) }
    else
      visited.map { |i| i = i.value }
    end
  end

  def inorder(root_node = @root, stack = [])
    if root_node.has_2_children?
      inorder(root_node.right_child, stack)
      stack.unshift(root_node.value)
      inorder(root_node.left_child, stack)
    elsif root_node.left_child
      stack.unshift(root_node.value)
      inorder(root_node.left_child, stack)
    elsif root_node.right_child
      inorder(root_node.right_child, stack)
      stack.unshift(root_node.value)
    else
      stack.unshift(root_node.value)
      stack
    end
  end

  def preorder(root_node = @root, queue = [])
    if root_node.has_2_children?
      queue.push(root_node.value)
      preorder(root_node.left_child, queue)
      preorder(root_node.right_child, queue)
    elsif root_node.left_child
      queue.push(root_node.value)
      preorder(root_node.left_child, queue)
    elsif root_node.right_child
      queue.push(root_node.value)
      preorder(root_node.right_child, queue)
    else
      queue.push(root_node.value)
      queue
    end
  end

  def postorder(root_node = @root, queue = [])
    if root_node.has_2_children?
      postorder(root_node.left_child, queue)
      postorder(root_node.right_child, queue)
      queue.push(root_node.value)
    elsif root_node.left_child && !root_node.right_child
      postorder(root_node.left_child, queue)
      queue.push(root_node.value)
    elsif !root_node.left_child && root_node.right_child
      postorder(root_node.right_child, queue)
      queue.push(root_node.value)
    else
      queue.push(root_node.value)
      queue
    end
  end

  def yield_nodes(node_list)
    if block_given?
      node_list.each { |i| yield(i) }
    else
      node_list.map { |i| i = i.value }
    end
  end

  def height(node, height = 0)
    return height if node.is_leaf?

    if node.left_child && node.right_child
      left_height = height(node.left_child, height+1)
      right_height = height(node.right_child, height+1)
      left_height > right_height ? left_height : right_height
    elsif node.left_child
      left_height = height(node.left_child, height + 1)
    elsif node.right_child
      right_height = height(node.right_child, height + 1)
    end
  end
  
  def depth(node, depth = 0, root_node = @root)
    return depth if root_node.value == node.value

    if root_node.value > node.value
      depth(node, depth + 1, root_node.left_child)
    elsif root_node.value < node.value
      depth(node, depth + 1, root_node.right_child)
    else
      depth
    end
  end

  def balanced?(root_node = @root)
    left_height = height(root_node.left_child)
    right_height = height(root_node.right_child)

    return true if left_height == right_height

    left_height > right_height ? right_height + 1 == left_height : left_height + 1 == right_height
  end

  def rebalance(root_node = @root)
    tree = inorder()

    @root = build_tree(tree)
  end
end
