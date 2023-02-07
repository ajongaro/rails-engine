require 'rails_helper'

RSpec.describe "Items API" do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }
   
  before :each do
    create_list(:item, 5, merchant:  merchant1 )
  end

  describe 'the items index endpoint' do
    it 'sends a list of all items' do
      get '/api/v1/items/'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(5)

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end
end