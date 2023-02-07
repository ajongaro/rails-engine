require 'rails_helper'

RSpec.describe "Merchant API" do
  before :each do
    create_list(:merchant, 3)
  end

  describe 'the merchants index' do
    it 'sends a list of all merchants' do
      get '/api/v1/merchants'

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
      get "/api/v1/merchants/#{merchant1.id}"

      expect(response).to be_successful 
      
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:id]).to be_an(String)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
end