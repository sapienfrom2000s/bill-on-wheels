require_relative '../lib/sale'
require_relative '../lib/item'
require 'spec_helper'

RSpec.describe Sale do
  describe '#set_offer' do
    let(:sale) { described_class.new }
    it 'sets special price for a given quantity' do
      sale.set_offer(price: 4, quantity: 3)
      expect(sale.price).to be 4
      expect(sale.quantity).to be 3
    end

    it 'raises error if quantity is set improperly' do
      expect do
        sale.set_offer(price: 4, quantity: 3.3)
      end .to raise_error("Quantity has to be a natural number")
    end

    it 'raises error if price is set improperly' do
      expect do
        sale.set_offer(price: -4, quantity: 3)
      end .to raise_error("Price has to be greater than 0")
    end
  end
end
