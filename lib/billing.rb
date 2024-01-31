require_relative 'sale'

class Billing
  def initialize(inventory)
    @inventory = inventory
  end

  def total(cart)
    regular_bill = 0
    final_bill = 0

    @inventory.each do |item|
      name = item.name
      next unless cart.key?(name)

      set_variables_for_item_invoice(item, cart[name])

      bill = invoice_per_item

      final_bill += (bill[:special] || bill[:regular])
      regular_bill += bill[:regular]
    end
    {
      final: final_bill.round(2),
      savings: (regular_bill - final_bill).round(2),
    }
  end

  private

  attr_reader :item, :quantity_ordered

  def set_variables_for_item_invoice(item, quantity)
    @item = item
    @quantity_ordered = quantity
  end

  def units_eligible_for_offer
    0 unless item.sale.available
    quantity_ordered / item.sale.quantity
  end

  def units_on_regular_price
    quantity_ordered - (units_eligible_for_offer * item.sale.quantity)
  end

  def invoice_per_item
    bill = { regular: nil, special: nil }

    bill[:regular] = cost_per_item(quantity_ordered, item.price)

    return bill unless item.sale.available

    bill[:special] = (cost_per_item(units_eligible_for_offer,
item.sale.price) + cost_per_item(units_on_regular_price, item.price))

    bill
  end

  def cost_per_item(quantity, unit_price)
    quantity * unit_price
  end
end
