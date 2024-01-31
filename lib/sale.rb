class Sale
  attr_reader :price, :quantity, :available

  def initialize
    @available = false
  end

  def set_offer(**args)
    @available = true
    @quantity = args[:quantity]
    @price = args[:price]
    check_if_vars_were_set_properly
  end

  def unset_offer
    @available = false
    @quantity = nil
    @price = nil
  end

  private

  def check_if_vars_were_set_properly
    raise 'Quantity has to be a natural number' unless quantity >= 1
    raise 'Quantity has to be a natural number' unless quantity.integer?
    raise 'Price has to be greater than 0' unless price > 0
  end
end
