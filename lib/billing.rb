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

      regular_total_on_item = regular_total(quantity, unit_price)
      regular_bill += regular_total_on_item

      if item.sale.available
        # sale = Sale.const_get(name.upcase)
        final_bill += special_total(item.sale.quantity, item.sale.price, quantity, unit_price)
      else
        final_bill += regular_total_on_item
      end
    end
    {
      final: final_bill.round(2),
      savings: (regular_bill - final_bill).round(2),
    }
  end

  private

  def regular_total(quantity, unit_price)
    quantity * unit_price
  end

  def special_total(sale_unit_quantity, sale_unit_price, quantity, unit_price)
    units_on_offer = quantity / sale_unit_quantity
    special_total_on_item = units_on_offer * sale_unit_price

    units_on_regular_price = quantity - (units_on_offer * sale_unit_quantity)
    regular_total_on_item = regular_total(units_on_regular_price, unit_price)

    special_total_on_item + regular_total_on_item
  end
end
