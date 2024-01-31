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
  end
end
