require 'rails_helper'

RSpec.describe "Items API" do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }
  let!(:item1) { create(:item, merchant: merchant1) }
  let!(:item2) { create(:item, merchant: merchant1) }

  describe 'the items index endpoint' do
    it 'sends a list of all items' do
      create_list(:item, 5, merchant:  merchant1 )

      get api_v1_items_path 

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(7)

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

  describe 'the item show endpoint' do
    it 'sends the details of one item' do
      get api_v1_item_path(item1)

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)[:data]

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

  describe 'the item creation endpoint' do
    it 'allows a user to create a new item' do
      post api_v1_items_path, params: { name: "New Item", description: "New Description", unit_price: 100.00, merchant_id: merchant2.id }

      expect(response).to be_successful
      new_item = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(new_item).to have_key(:id)
      expect(new_item[:id]).to be_an(String)
      expect(new_item[:attributes]).to have_key(:name)
      expect(new_item[:attributes][:name]).to be_a(String)
      expect(new_item[:attributes]).to have_key(:description)
      expect(new_item[:attributes][:description]).to be_a(String)
      expect(new_item[:attributes]).to have_key(:unit_price)
      expect(new_item[:attributes][:unit_price]).to be_a(Float)
      expect(new_item[:attributes]).to have_key(:merchant_id)
      expect(new_item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  describe 'the item deletion endpoint' do
    it 'allows a user to delete an item' do
      delete api_v1_item_path(item1)

      expect(response).to be_successful

      expect(Item.find_by(id: item1.id)).to eq(nil)
    end
  end
end