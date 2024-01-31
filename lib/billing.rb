require_relative 'sale'

class Billing
  attr_reader :invoice

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

      bill = invoice_on_item

      yield(bill, name, quantity) if block_given?

      final_bill += (bill[:special] || bill[:regular])
      regular_bill += bill[:regular]
    end
    { regular: regular_bill, final: final_bill }
  end

  def invoice_pretty_print(cart)
    regular_bill = 0
    final_bill = 0
    puts 'Name    Quantity    Regular Price    Final Price'
    puts '----    --------    -------------    -----------'
    total(cart) do |item_bill, name, quantity|
      regular_bill += item_bill[:regular]
      final_bill += item_bill[:special]
      puts "#{name}    #{quantity}    $#{item_bill[:regular].round(2)}    $#{item_bill[:special].round(2)}"
    end
    puts "Your total bill is #{final_bill.round(2)}"
    puts "You saved #{(regular_bill - final_bill).round(2)} today!"
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

  def invoice_on_item
    bill = { regular: nil, special: nil }

    bill[:regular] = item_total(quantity_ordered, item.price)

    return bill unless item.sale.available

    bill[:special] = (item_total(units_eligible_for_offer,
item.sale.price) + item_total(units_on_regular_price, item.price))

    bill
  end

  def item_total(quantity, unit_price)
    quantity * unit_price
  end
end
