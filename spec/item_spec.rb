require 'spec_helper'
require_relative '../lib/item'

RSpec.describe Item do
  let(:item) { Item.new('Test Item', 4.32) }
  it 'gives information about the item' do
    expect(item.info).to include(
       :name => 'Test Item',
       :price => 4.32,
      )
  end
end