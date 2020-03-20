class Tree
  attr_reader :root

  def initialize(arr)
    # sort and remove duplicates
    arr.sort!.uniq!

    @root = build_tree(arr)
  end

  def build_tree(arr)
    # catch the exceptions
    return unless arr[0]
    return Node.new(arr[0]) if arr.length <= 1

    middle = arr.length/2

    root = Node.new(arr[middle])
    root.left = build_tree(arr[0...middle])
    root.right = build_tree(arr[middle+1..-1])
    root
  end

  def insert(value)
    current = @root

    # loop forever until an endpoint is found
    loop do
      # if the value already exists, don't insert
      if current == value
        return
      # if the value is smaller, go to the left
      elsif current > value
        next_node = current.left
      # otherwise go to the right
      else
        next_node = current.right
      end

      # if we have no next value, break out of the loop
      break if next_node == nil

      # if we haven't broken out of the loop set the current node to the
      # next one
      current = next_node
    end

    # when the last node was found, insert the value
    if current > value
      current.left = Node.new(value=value)
    else
      current.right = Node.new(value=value)
    end
  end

  def level_order
    # start with the root
    current = @root
    # create a queue to store all the nodes in to traverse
    queue = []

    result = []
    loop do
      # if a block was given, yield the current value to it and otherwise
      # append the value to an array
      if block_given?
        yield current.value
      else
        result << current.value
      end

      # if we have next values, append them to the queue
      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?

      # stop when the queue is empty
      break if queue.empty?

      # finally set the current value to the next one from the queue
      current = queue.shift
    end

    # if a block was given, return nil otherwise, the array with all the
    # results
    if block_given?
      nil
    else
      result
    end
  end

  # recursive version of level_order
  def level_order_rec(current=@root, result=[], queue=[], &block)
    # if a block was given, yield the current value to the block
    if block_given?
      yield current.value
    else
      result << current.value
    end

    # if we have next values, append them to the queue
    queue << current.left unless current.left.nil?
    queue << current.right unless current.right.nil?

    # stop if the queue is empty and return either nil or the
    # results-array
    if queue.empty?
      if block_given?
        return
      else
        return result
      end
    end

    #recursively call the function with the new values
    level_order_rec(queue.shift, result, queue, &block)
  end

  # Extra Bonus challenge
  # first define an array with the names of the functions to be defined
  ORDERS = ['preorder', 'inorder', 'postorder']
  ORDERS.each do |method|
    # define_method takes a string for the name of the new function and a
    # block that has the arguments to the function as arguments itself
    # (the things between the pipe characters)
    define_method "#{method}" do |current=@root, result=[], &block|
      # base case
      return if current == nil

      # if order is preorder, yield before the recursive calls
      if method == ORDERS[0]
        block ? block.call(current.value) : result << current.value
      end

      # the send method executes a method that is specified by the first
      # argument to the send method. It can be a string or a symbol
      # I believe self is the instance of the tree that calls the method.
      # The rest of the arguments to the send call are the parameters that
      # get passed to the call of 'method'
      self.send(method, current.left, result, &block)

      # if order is inorder, yield between the recursive calls
      if method == ORDERS[1]
        block ? block.call(current.value) : result << current.value
      end

      self.send(method, current.right, result, &block)

      # if order is postorder, yield after the recursive calls
      if method == ORDERS[2]
        block ? block.call(current.value) : result << current.value
      end

      # return either nil or the result-array
      block ? nil : result
    end
  end

  def find(value, current=@root)
    # if no node was found, return false
    return false if current == nil
    # return the node if the value matches
    return current if current == value

    begin
      if current > value
        find(value, current.left)
      else
        find(value, current.right)
      end
    # if the comparison fails, because of incorrect types, return false
    rescue ArgumentError
      return false
    end
  end

  def delete(value)
    node = find(value)
    # return false if the node doesn't exist
    if node == false
      return false
    end

    parent = find_parent(node)

    # if the node has no childs
    if node.left == nil and node.right == nil
      delete_leaf(node, parent)
    # if the node has only one child
    elsif ( node.left != nil ) ^ ( node.right != nil )
      child = (node.left or node.right)

      # special case if we delete the root with only one child (it has no
      # parent)
      if node == @root
        old_root = @root
        @root = child
        return old_root
      end

      if node > parent
        parent.right = child
      else
        parent.left = child
      end
      node
    # if the node has 2 children
    else
      next_biggest_node = find_next_biggest_node(node)
      # delete the next_biggest node recursively
      delete(next_biggest_node)

      # replace the current node with the next biggest one
      node.value = next_biggest_node.value
    end
  end

  def depth(node, current_depth=0)
    return current_depth if node == nil
    return current_depth if (node.left == nil) and (node.right == nil)
    current_depth += 1

    [depth(node.left, current_depth), depth(node.right, current_depth)].max
  end

  def balanced?
    (depth(@root.left) - depth(@root.right)).abs <= 1
  end

  def rebalance!
    @root = build_tree(level_order)
  end

  private

  def find_parent(node)
    # the root has no parent
    if @root == node
      return
    end

    # find the parent node
    current = @root
    loop do
      if current.left == node or current.right == node
        break
      elsif current > node
        current = current.left
      else
        current = current.right
      end
    end
    return current
  end

  def delete_leaf(node, parent)
    # return false if the node is not a leaf
    return false if node.left != nil or node.right != nil

    # otherwise delete the reference to it from the parent
    if parent.left == node
      parent.left = nil
      node
    elsif parent.right == node
      parent.right = nil
      node
    else
      false
    end
  end

  def find_next_biggest_node(node)
    # start with the node to the right
    next_node = node.right
    # return the node itself if it has no right nodes
    return node if next_node == nil

    # while you can go left, do so
    while next_node.left != nil do
      next_node = next_node.left
    end

    next_node
  end
end
