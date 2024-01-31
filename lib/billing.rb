require_relative 'sale'

class Billing
  def initialize(inventory)
    @inventory = inventory
  end

  def total(cart)
    regular_bill = 0
    final_bill = 0

    @inventory.each do |item|
      begin
        name = item.name
        quantity = cart.fetch(name)
        unit_price = item.price
      rescue
        next
      end

      total = item_total(item, quantity)

      final_bill += (total[:special] || total[:regular])
      regular_bill += total[:regular]
    end
    {
      final: final_bill.round(2),
      savings: (regular_bill - final_bill).round(2),
    }
  end

  private

  def item_total(item, quantity)
    bill = {regular: nil, special: nil}

    bill[:special] = special_total_on_item(item.sale.quantity, item.sale.price, quantity, item.price) if item.sale.available
    bill[:regular] = regular_total_on_item(quantity, item.price)

    bill
  end

  def regular_total_on_item(quantity, unit_price)
    quantity * unit_price
  end

  def special_total_on_item(sale_unit_quantity, sale_unit_price, quantity, unit_price)
    units_on_offer = quantity / sale_unit_quantity
    special_total_on_item = units_on_offer * sale_unit_price

    units_on_regular_price = quantity - (units_on_offer * sale_unit_quantity)

    special_total_on_item + regular_total_on_item(units_on_regular_price, unit_price)
  end
end
