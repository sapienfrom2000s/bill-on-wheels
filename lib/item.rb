class Item
  attr_reader :name, :price, :on_sale

  def initialize(name, price, on_sale = false)
    @name = name
    @price = price
    @on_sale = on_sale
  end

  def info
    { name: , price: , on_sale: }
  end
end
