require_relative 'sale'

class Billing
  def initialize(inventory)
    @inventory = inventory
  end

  def total(cart)
    regular_bill = 0
    final_bill = 0

    cart.each do |name, quantity|
      item = find_item_in_inventory(name)
      next unless item

      set_variables_for_item_invoice(item, quantity)

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

  def find_item_in_inventory(name)
    item = @inventory.find { |product| product.name == name }
    puts "#{name} not found in inventory" unless item
    item
  end

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
