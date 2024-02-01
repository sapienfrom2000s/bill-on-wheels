require_relative 'billing'

class Cashier
  def initialize(billing)
    @billing = billing
  end

  def do_billing
    products = input_products
    products.map!(&:capitalize).map!(&:to_sym)
    cart = products.group_by { |item| item }
                   .transform_values! { |item| item.count }
    @billing.invoice_pretty_print(cart)
  end

  private

  def input_products
    puts 'Enter the products seperated by space'
    products = gets.chomp.split(' ')
  end
end
