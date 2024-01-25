require_relative '../lib/sale'
require_relative '../lib/item'
require 'spec_helper'

RSpec.describe Sale do
  describe 'available' do
    let(:sale) { described_class.new }
    it 'checks if sale is available' do
      sale.available = true
      expect(sale.available).to be true
    end
  end

  describe 'price and quantity' do
    let(:sale) { described_class.new }
    it 'gives gives back special price for a given quantity' do
      sale.available = true
      sale.price = 4
      sale.quantity = 3
      expect(sale.price).to be 4
      expect(sale.quantity).to be 3
    end
  end
end
