require_relative '../lib/billing'
require 'spec_helper'

RSpec.describe Billing do
  subject do
    milk = Item.new(:Milk, 3.97)
    milk.sale.set_offer(price: 5, quantity: 2)

    bread = Item.new(:Bread, 2.17)
    bread.sale.set_offer(price: 6, quantity: 3)

    banana = Item.new(:Banana, 0.99)
    apple = Item.new(:Apple, 0.89)

    inventory = [milk, bread, banana, apple]
    described_class.new(inventory)
  end

  describe '#total' do
    it 'gives the total bill' do
      expect(subject.total({
        :Milk => 3,
        :Bread => 4,
        :Apple => 1,
        :Banana => 1,
      })).to include(
        :final => 19.02,
        :regular => 22.47,
      )
    end

    it 'yields name of item, quantity and bill for item' do
      block = proc { |b, c, d| }
      expect do |block|
        subject.total({
          :Milk => 3,
        }, &block)
      end .to yield_with_args({ regular: 11.91, special: 8.97 }, :Milk, 3)
    end
  end
end
