require_relative '../lib/billing'
require 'spec_helper'

RSpec.describe Billing do
  before(:all) do
    inventory = YAML.load_file(File.join(File.dirname(__FILE__), '../lib/inventory.yml'))
    @billing = described_class.new(inventory)
  end

  it 'gives the total bill' do
    expect(@billing.total({
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
