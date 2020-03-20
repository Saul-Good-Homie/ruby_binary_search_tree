require_relative 'node.rb'
require_relative 'tree.rb'

def print_orders(tree)
  puts "BFS:"
  puts "============"
  puts "Level Order:"
  puts tree.level_order.join(", ")
  puts "DFS:"
  puts "============"
  puts "Preorder:"
  puts tree.preorder.join(", ")
  puts "Inorder:"
  puts tree.inorder.join(", ")
  puts "Postorder:"
  puts tree.postorder.join(", ")
end

def print_orders_with_block(tree, &block)
  puts "BFS:"
  puts "============"
  puts "Level Order:"
  tree.level_order &block
  puts "DFS:"
  puts "============"
  puts "Preorder:"
  tree.preorder &block
  puts "Inorder:"
  tree.inorder &block
  puts "Postorder:"
  tree.postorder &block
end

system "clear"
puts "1. Create a binary search tree from an array of random numbers."
puts "The Array:"

arr = Array.new(15) {rand(1..100)}
print arr
puts

t = Tree.new(arr)

puts
puts "2. Confirm that the tree is balanced by calling '#balanced?'"
print "Tree.balanced? : "
puts t.balanced?
puts "Tree depth: #{t.depth(t.root)}"

puts
puts "3.Print out all elements in level, pre, post, and in order:"
print_orders t

puts
puts "4. try to unbalance the tree by adding several numbers > 100"
puts "Adding 101"
t.insert(101)
puts "Adding 202"
t.insert(202)
puts "Adding 303"
t.insert(303)
puts "Adding 404"
t.insert(404)
puts "Adding 505"
t.insert(505)

puts
puts "5. Confirm that the tree is unbalanced by calling '#balanced?'"
print "Tree.balanced? : "
puts t.balanced?
puts "Tree depth: #{t.depth(t.root)}"

puts
puts "6. Balance the tree by calling '#rebalance!'"
t.rebalance!

puts "7. Confirm that the tree is balanced by calling '#balanced?'"
print "Tree.balanced? : "
puts t.balanced?
puts "Tree depth: #{t.depth(t.root)}"

puts
puts "8. Print out all the elements in level, pre, post and in order."
print_orders t
