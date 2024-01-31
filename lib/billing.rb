require_relative 'sale'

class Billing
  def initialize(inventory)
    @inventory = inventory
  end

  def total(cart)
    regular_bill = 0
    final_bill = 0

    @inventory.each do |item|
      next unless cart.key?(item.name)

      item_total = item_total(item, cart[item.name])

      final_bill += (item_total[:special] || item_total[:regular])
      regular_bill += item_total[:regular]
    end
    {
      final: final_bill.round(2),
      savings: (regular_bill - final_bill).round(2),
    }
  end

  private

  def item_total(item, quantity)
    bill = { regular: nil, special: nil }

    if item.sale.available
      bill[:special] =
        special_item_total(item.sale.quantity, item.sale.price, quantity, item.price)
    end
    bill[:regular] = regular_item_total(quantity, item.price)

    bill
  end

  def regular_item_total(quantity, unit_price)
    quantity * unit_price
  end

  def special_item_total(sale_unit_quantity, sale_unit_price, quantity, unit_price)
    units_on_offer = quantity / sale_unit_quantity
    special_item_total = units_on_offer * sale_unit_price

    units_on_regular_price = quantity - (units_on_offer * sale_unit_quantity)

    special_item_total + regular_item_total(units_on_regular_price, unit_price)
  end
end
