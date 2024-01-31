require_relative '../lib/billing'
require 'spec_helper'

RSpec.describe Billing do
  before(:all) do
    milk = Item.new(:Milk, 3.97)
    milk.sale.set_offer(price: 5, quantity: 2)

    bread = Item.new(:Bread, 2.17)
    bread.sale.set_offer(price: 6, quantity: 3)

    banana = Item.new(:Banana, 0.99)
    apple = Item.new(:Apple, 0.89)

    inventory = [milk, bread, banana, apple]
    @billing = described_class.new(inventory)
  end

  describe '#total' do
    it 'gives the total bill' do
      expect(@billing.total({
        :Milk => 3,
        :Bread => 4,
        :Apple => 1,
        :Banana => 1,
      })).to include(
        :final => 19.02,
        :regular => 22.47,
      )
    end
  end
end
