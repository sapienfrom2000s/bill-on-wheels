require_relative 'item'
require_relative 'sale'

def items
  milk = Item.new(:Milk, 3.97)
  bread = Item.new(:Bread, 2.17)
  banana = Item.new(:Banana, 0.99)
  apple = Item.new(:Apple, 0.89)

  [milk, bread, banana, apple]
end

def input_products
  puts 'Enter the products seperated by space'
  products = gets.chomp.split(' ')
  products.map!(&:capitalize).map!(&:to_sym)
  products.group_by { |item| item }.
    transform_values! { |item| item.count }
end

def total(products)
  bill_with_discount = 0
  bill_without_discount = 0
  items.each do |item|
    begin
      quantity = products.fetch(item.name)
      unit_price = item.price
    rescue
      next
    end

    begin
      sale_info = Sale.const_get(item.name.upcase)
      sale_unit_quantity = sale_info[:quantity]
      sale_unit_price = sale_info[:price]
    rescue
      sale_unit_quantity = nil
    end

    bill_without_discount += quantity * unit_price
    if sale_unit_quantity.nil?
      bill_with_discount += quantity * unit_price
    else
      bill_with_discount += (sale_unit_price * (quantity / sale_unit_quantity))
      + ((quantity % sale_unit_quantity) * unit_price)
    end
  end
  {
    total: bill_with_discount.round(2),
    savings: (bill_without_discount - bill_with_discount).round(2),
  }
end

if __FILE__ == $PROGRAM_NAME
  products = input_products
  bill = total(products)

  puts "Your total bill is #{bill[:total]}"
  puts "You saved #{bill[:savings]} today!"
end
