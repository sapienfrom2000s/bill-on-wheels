require_relative 'admin'
require_relative 'store'
require_relative 'billing'
require_relative 'cashier'

rama_grocery = Store.new('Rama Grocery Store')
admin_raman = Admin.new('Raman', rama_grocery)

items = [
  { name: :Milk, price: 3.97 }, { name: :Bread, price: 2.17 }, { name: :Banana, price: 0.99 },
  { name: :Apple, price: 0.89 },
]

items.each do |item|
  admin_raman.add_item(item[:name], item[:price])
end

admin_raman.set_offer(name: :Milk, price: 5, quantity: 2)
admin_raman.set_offer(name: :Bread, price: 6, quantity: 3)

billing = Billing.new(rama_grocery.items)
cashier_joseph = Cashier.new(billing)

cashier_joseph.do_billing
