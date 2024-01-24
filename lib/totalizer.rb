require_relative 'item'
require_relative 'sale'

class Totalizer
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
        puts "Item #{name} not found in our inventory"
        next
      end

      regular_total_on_item = regular_total(quantity, unit_price)
      regular_bill += regular_total_on_item

      if item.on_sale
        sale = Sale.const_get(name.upcase)
        final_bill += special_total(sale[:quantity], sale[:price], quantity, unit_price)
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

milk = Item.new(:Milk, 3.97, true)
bread = Item.new(:Bread, 2.17, true)
banana = Item.new(:Banana, 0.99)
apple = Item.new(:Apple, 0.89)

inventory = [milk, bread, banana, apple]
totalizer = Totalizer.new(inventory)

if __FILE__ == $PROGRAM_NAME
  puts 'Enter the products seperated by space'
  products = gets.chomp.split(' ')
  products.map!(&:capitalize).map!(&:to_sym)
  products.group_by { |item| item }.
    transform_values! { |item| item.count }
  cart = input_products

  bill = totalizer.total(cart)

  puts "Your total bill is #{bill[:final]}"
  puts "You saved #{bill[:savings]} today!"
end
