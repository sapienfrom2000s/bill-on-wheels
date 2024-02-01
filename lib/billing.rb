require 'tty-table'
require 'colorize'

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

      item_bill = calculate_invoice_on_item

      yield(item_bill, name, quantity) if block_given?

      final_bill += (item_bill[:special] || item_bill[:regular])
      regular_bill += item_bill[:regular]
    end
    { regular: regular_bill, final: final_bill }
  end

  def invoice_pretty_print(cart)
    table = TTY::Table.new(header: ['Name', 'Quantity', 'Regular Price', 'Final Price'])
    bill = total(cart) do |item_bill, name, quantity|
      table << [name, quantity, item_bill[:regular], item_bill[:special] || item_bill[:regular]]
    end
    puts table.render(:unicode, alignments: [:left, :center, :center, :center, :center])
    puts "Your total bill is $#{bill[:final].round(2)}"
    puts "You saved $#{(bill[:regular] - bill[:final]).round(2)} today!".colorize(:green)
  end

  private

  attr_reader :item, :quantity_ordered

  def find_item_in_inventory(name)
    item = @inventory.find { |product| product.name == name }
    puts "#{name} not found in inventory".colorize(:red) unless item
    item
  end

  def set_variables_for_item_invoice(item, quantity)
    @item = item
    @quantity_ordered = quantity
  end

  def calculate_units_eligible_for_offer
    0 unless item.sale.available
    quantity_ordered / item.sale.quantity
  end

  def calculate_quantity_ineligible_for_offer(units_on_offer)
    quantity_ordered - (units_on_offer * item.sale.quantity)
  end

  def calculate_invoice_on_item
    bill = { regular: nil, special: nil }

    bill[:regular] = calculate_regular_invoice_on_item

    return bill unless item.sale.available

    bill[:special] = calculate_special_invoice_on_item

    bill
  end

  def calculate_regular_invoice_on_item
    item_total(quantity_ordered, item.price)
  end

  def calculate_special_invoice_on_item
    units_on_offer = calculate_units_eligible_for_offer
    quantity_ineligible_for_offer = calculate_quantity_ineligible_for_offer(units_on_offer)

    item_total(units_on_offer,
item.sale.price) + item_total(quantity_ineligible_for_offer, item.price)
  end

  def item_total(quantity, unit_price)
    quantity * unit_price
  end
end
