class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value=nil, left=nil, right=nil)
    @value = value
    @left = left
    @right = right
  end

  def <=>(other)
    if other.class == Node
      value <=> other.value
    else
      value <=> other
    end
  end

  def to_s
    @value.to_s
  end
end

