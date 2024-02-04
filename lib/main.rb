require_relative 'admin'
require_relative 'store'
require_relative 'billing'
require_relative 'cashier'
require 'yaml'

rama_grocery = Store.new('Rama Grocery Store')
admin_raman = Admin.new('Raman', rama_grocery)

inventory = YAML.safe_load_file(File.join(File.dirname(__FILE__), 'inventory.yml'))

inventory.each do |item|
  admin_raman.add_item(item['name'].to_sym, item['price'])
end

admin_raman.set_offer(name: :Milk, price: 5, quantity: 2)
admin_raman.set_offer(name: :Bread, price: 6, quantity: 3)

billing = Billing.new(rama_grocery.items)
cashier_joseph = Cashier.new(billing)

cashier_joseph.do_billing
