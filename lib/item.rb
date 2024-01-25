require_relative 'sale'

class Item
  attr_reader :name, :price, :sale

  def initialize(name, price)
    @name = name
    @price = price
    @sale = Sale.new
  end

  def info
    { name: , price: }
  end
end
