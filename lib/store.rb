class Store
  attr_reader :name, :items
  def initialize(name)
    @name = name
    @items = []
  end

  def add_item(item)
    @items << item
    item
  end

  def delete_item(item)
    @items.delete(item)
  end
end
