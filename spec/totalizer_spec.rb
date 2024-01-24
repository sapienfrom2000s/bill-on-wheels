require_relative '../lib/totalizer'
require 'spec_helper'

RSpec.describe 'Totalizer' do
  it 'gives the total bill' do
    expect(total({
      :Milk => 3,
      :Bread => 4,
      :Apple => 1,
      :Banana => 1,
    })).to eq({ total: 19.02, savings: 3.45 })
  end
end
