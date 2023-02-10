require 'rails_helper'

RSpec.describe "Item's Merchant API" do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }
  
  before :each do
    create_list(:item, 5, merchant:  merchant1 )
  end

  describe 'the items merchant show endpoint' do
    it 'returns the merchant for a specified item' do
      item = Item.first

      get api_v1_item_merchant_index_path(item)

      expect(response).to be_successful 

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:id]).to be_an(String)
      expect(merchant[:attributes][:name]).to be_a(String)
    end

    it 'items merchant show returns sad path error when not found' do
      item = Item.first

      get api_v1_item_merchant_index_path(14)

      expect(response).to_not be_successful 

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to have_key(:error)
      expect(error[:error]).to be_a(String)
      expect(error[:error]).to eq("Couldn't find Item with 'id'=14")
    end
  end
end