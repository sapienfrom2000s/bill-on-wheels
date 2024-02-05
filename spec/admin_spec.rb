require 'spec_helper'
require_relative '../lib/item'
require_relative '../lib/store'
require_relative '../lib/admin'

RSpec.describe Admin do
  let(:store) { Store.new('Rama Grocery') }
  subject { described_class.new('Joseph', store) }

  it 'can add item to store' do
    expect { subject.add_item('Rice', 9.2) }.to change { store.items.length }.by(1)
  end

  it 'can delete item from store' do
    subject.add_item('Rice', 9.2)
    expect { subject.delete_item('Rice') }.to change { store.items.length }.by(-1)
  end

  it 'can set offer on item' do
    item = subject.add_item('Rice', 9.2)
    subject.set_offer(name: 'Rice', price: 5, quantity: 2)
    expect(item.sale.available).to be true
  end

  it 'can set unset offer on item' do
    item = subject.add_item('Rice', 9.2)
    subject.set_offer(name: 'Rice', price: 5, quantity: 2)
    expect { subject.unset_offer('Rice') }.to change { item.sale.available }.from(true).to(false)
  end
end
