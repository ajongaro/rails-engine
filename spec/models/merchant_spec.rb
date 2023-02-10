require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name)}
  end

  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'class methods' do
    let!(:merchant1) { create(:merchant, name: "Anthony's Wares") }
    let!(:merchant2) { create(:merchant, name: "Fancy Pants") }
    let!(:merchant3) { create(:merchant, name: "WoW") }
    
    describe '.find_all_by_name_fragment' do
      it 'returns all merchants that match the name fragment' do
        expect(Merchant.find_all_by_name_fragment("an")).to eq([merchant1, merchant2])
        expect(Merchant.find_all_by_name_fragment("An")).to eq([merchant1, merchant2])
        expect(Merchant.find_all_by_name_fragment("Wo")).to eq([merchant3])
        expect(Merchant.find_all_by_name_fragment("ow")).to eq([merchant3])
      end
    end
  end
end