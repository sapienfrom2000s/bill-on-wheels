require_relative '../lib/totalizer'
require 'spec_helper'

RSpec.describe Totalizer do
  before(:all) do
    milk = Item.new(:Milk, 3.97, true)
    bread = Item.new(:Bread, 2.17, true)
    banana = Item.new(:Banana, 0.99)
    apple = Item.new(:Apple, 0.89)

    inventory = [milk, bread, banana, apple]
    @totalizer = described_class.new(inventory)
  end

  it 'gives the total bill' do
    expect(@totalizer.total({
      :Milk => 3,
      :Bread => 4,
      :Apple => 1,
      :Banana => 1,
    })).to include(
      :final => 19.02,
      :savings => 3.45
    )
  end
end
