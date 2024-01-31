require_relative 'item'
require_relative 'billing'

milk = Item.new(:Milk, 3.97)
milk.sale.set_offer(price: 5, quantity: 2)

bread = Item.new(:Bread, 2.17)
bread.sale.set_offer(price: 6, quantity: 3)

banana = Item.new(:Banana, 0.99)
apple = Item.new(:Apple, 0.89)

inventory = [milk, bread, banana, apple]
billing = Billing.new(inventory)

puts 'Enter the products seperated by space'
products = gets.chomp.split(' ')
products.map!(&:capitalize).map!(&:to_sym)
cart = products.group_by { |item| item }.
  transform_values! { |item| item.count }

bill = billing.total(cart)

puts "Your total bill is #{bill[:final]}"
puts "You saved #{bill[:savings]} today!"
