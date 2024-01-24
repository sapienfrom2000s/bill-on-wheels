require_relative '../lib/sale'
require 'spec_helper'

RSpec.describe Sale do
  it 'gives back special price for a given quantity' do
    expect(Sale::BREAD).to include(
      :quantity => 3,
      :price => 6,
    )
  end
end
