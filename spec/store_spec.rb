require 'spec_helper'
require_relative '../lib/store.rb'
require_relative '../lib/item.rb'

RSpec.describe Store do
  let(:rama_shoes) { described_class.new('Rama Shoe Store') }

  it 'has a name' do
    expect(rama_shoes.name).to eq('Rama Shoe Store')
  end

  describe 'Items' do
    before(:all) do
      @nike = Item.new(:'Nike GR8', 99)
    end

    it 'can be added' do
      rama_shoes.add_item(@nike)
      expect(rama_shoes.items.first).to be_an_instance_of(Item)
    end

    it 'can be deleted' do
      rama_shoes.add_item(@nike)
      expect { rama_shoes.delete_item(@nike) }.to change { rama_shoes.items.length }.by(-1)
    end
  end
end
