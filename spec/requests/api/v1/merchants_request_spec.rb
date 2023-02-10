require 'rails_helper'

RSpec.describe "Merchant API" do
  before :each do
    create_list(:merchant, 3)
  end

  describe 'the merchants index endpoint' do
    it 'sends a list of all merchants' do
      get api_v1_merchants_path

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(3)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:id]).to be_an(String)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe 'the merchant show endpoint' do
    it 'sends a single merchant' do
      merchant1 = Merchant.first

      get api_v1_merchant_path(merchant1)

      expect(response).to be_successful 
      
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:id]).to be_an(String)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  describe 'the merchant search endpoint' do
    let!(:merchant1) { create(:merchant, name: "Anthony's Wares") }
    let!(:merchant2) { create(:merchant, name: "Fancy Pants") }
    let!(:merchant3) { create(:merchant, name: "WoW") }

    it 'returns a single merchant by name frament' do
      get api_v1_merchants_find_path, params: { name: "ants" }
      
      expect(response).to be_successful

      result = JSON.parse(response.body, symbolize_names: true)
      expect(result[:data][:attributes][:name]).to eq("Fancy Pants")
    end
  end
end