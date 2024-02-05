require_relative 'item'
require_relative 'store'

class Admin
  def initialize(name, store)
    @name = name
    @store = store
  end

  def add_item(name, price)
    @store.add_item(Item.new(name, price))
  end

  def delete_item(name)
    item = find_item_in_store(name)
    @store.delete_item(item)
  end

  def set_offer(**args)
    item = find_item_in_store(args[:name])
    item.sale.set_offer(price: args[:price], quantity: args[:quantity])
  end

  def unset_offer(name)
    item = find_item_in_store(name)
    item.sale.unset_offer
  end

  private

  def find_item_in_store(name)
    @store.items.find { |item| item.name == name }
  end
end
