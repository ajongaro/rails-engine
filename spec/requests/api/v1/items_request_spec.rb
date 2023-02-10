require 'rails_helper'

RSpec.describe "Items API" do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }
  # let!(:item1) { create(:item, merchant: merchant1) }
  # let!(:item2) { create(:item, merchant: merchant1) }
  # let!(:item3) { create(:item, merchant: merchant1) }
  let!(:item1) { Item.create!(name: "Dumb thing", description: "a bird in a tree", unit_price: 100.02, merchant: merchant1) }
  let!(:item2) { Item.create!(name: "orig Name", description: "another bird", unit_price: 100.02, merchant: merchant1) }
  let!(:item3) { Item.create!(name: "not found", description: "a racoon", unit_price: 100.02, merchant: merchant1) }
  let!(:item4) { Item.create!(name: "Original Name", description: "Dangit", unit_price: 100.02, merchant: merchant1) }
  let!(:item5) { Item.create!(name: "Plate set", description: "Plaster of Paris", unit_price: 100.02, merchant: merchant1) }
  let!(:item6) { Item.create!(name: "Okay then", description: "Silly thing", unit_price: 100.02, merchant: merchant1) }

  describe 'the items index endpoint' do
    it 'sends a list of all items' do
      create_list(:item, 5, merchant:  merchant1 )

      get api_v1_items_path 

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(11)

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
      post api_v1_items_path, params: { name: "A Novel Item", description: "A Decent Description", unit_price: 100.00, merchant_id: merchant2.id }

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

    it 'has sad path user fail to create a new item' do
      post api_v1_items_path, params: { name: "A Novel Item", unit_price: 100.00, merchant_id: merchant2.id }

      expect(response).to_not be_successful 
      expect(response.status).to eq(404)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:error)
      expect(result[:error]).to eq("Validation failed: Description can't be blank")
    end
  end

  describe 'the item deletion endpoint' do
    let!(:customer1) { create(:customer) }
    let!(:invoice1) { Invoice.create!(status: "shipped", customer: customer1, merchant: merchant1) }
    let!(:invoice2) { Invoice.create!(status: "shipped", customer: customer1, merchant: merchant1) }
    let!(:invoice3) { Invoice.create!(status: "shipped", customer: customer1, merchant: merchant1) }

    # two items on invoice1
    let!(:invoice_item1) { InvoiceItem.create!(item: item1, quantity: 10, unit_price: 100.02, invoice: invoice1) }
    let!(:invoice_item2) { InvoiceItem.create!(item: item2, quantity: 10, unit_price: 109.04, invoice: invoice1) }

    # one item on invoice2 
    let!(:invoice_item3) { InvoiceItem.create!(item: item1, quantity: 10, unit_price: 115.07, invoice: invoice2) }

    it 'allows a user to delete an item' do
      expect(Item.find_by(id: item1.id)).to eq(item1)

      delete api_v1_item_path(item1)

      expect(response).to be_successful

      expect(Item.find_by(id: item1.id)).to eq(nil)
    end

    it 'deletes all associated invoices where no other items are present' do
      expect(Invoice.find_by(id: invoice1.id)).to eq(invoice1)
      expect(Invoice.find_by(id: invoice2.id)).to eq(invoice2)
      expect(Invoice.count).to eq(3)

      delete api_v1_item_path(item1)

      expect(Invoice.count).to eq(2)
      expect(Invoice.find(invoice1.id)).to eq(invoice1)
      expect { Invoice.find(invoice2.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'the item update endpoint' do
    it 'allows a user to update an item' do
      item = Item.find(item4.id)
      expect(item.name).to eq("Original Name")     
      expect(item.description).to eq("Dangit")     
      expect(item.unit_price).to eq(100.02)     
      expect(item.merchant_id).to eq(merchant1.id)     

      put api_v1_item_path(item4), params: { name: "New Name", description: "New Desc", unit_price: 99.09, merchant_id: merchant1.id }

      expect(response).to be_successful

      updated_item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(updated_item).to have_key(:id)
      expect(updated_item[:id]).to be_an(String)
      expect(updated_item[:attributes]).to have_key(:name)
      expect(updated_item[:attributes][:name]).to be_a(String)
      expect(updated_item[:attributes]).to have_key(:description)
      expect(updated_item[:attributes][:description]).to be_a(String)
      expect(updated_item[:attributes]).to have_key(:unit_price)
      expect(updated_item[:attributes][:unit_price]).to be_a(Float)
      expect(updated_item[:attributes]).to have_key(:merchant_id)
      expect(updated_item[:attributes][:merchant_id]).to be_a(Integer)

      item_result = Item.find(item4.id)
      expect(item_result.name).to eq("New Name")     
      expect(item_result.description).to eq("New Desc")     
      expect(item_result.unit_price).to eq(99.09)     
      expect(item_result.merchant_id).to eq(merchant1.id)     
    end

    it 'can be updated with missing parameters' do
      item = Item.find(item4.id)
      expect(item.name).to eq("Original Name")     
      expect(item.description).to eq("Dangit")     
      expect(item.unit_price).to eq(100.02)     
      expect(item.merchant_id).to eq(merchant1.id)     

      put api_v1_item_path(item4), params: { name: "New Name", description: "New Desc" }

      expect(response).to be_successful

      updated_item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(updated_item).to have_key(:id)
      expect(updated_item[:id]).to be_an(String)
      expect(updated_item[:attributes]).to have_key(:name)
      expect(updated_item[:attributes][:name]).to be_a(String)
      expect(updated_item[:attributes]).to have_key(:description)
      expect(updated_item[:attributes][:description]).to be_a(String)
      expect(updated_item[:attributes]).to have_key(:unit_price)
      expect(updated_item[:attributes][:unit_price]).to be_a(Float)
      expect(updated_item[:attributes]).to have_key(:merchant_id)
      expect(updated_item[:attributes][:merchant_id]).to be_a(Integer)

      item_result = Item.find(item4.id)
      expect(item_result.name).to eq("New Name") # new   
      expect(item_result.description).to eq("New Desc") # new   
      expect(item_result.unit_price).to eq(100.02) # old 
      expect(item_result.merchant_id).to eq(merchant1.id) # old
    end
  end

  describe 'the items search endpoint' do
    it 'returns all items matching name fragment' do
      get api_v1_items_find_all_path, params: { name: "or" }
      
      expect(response).to be_successful

      result = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(result.first[:attributes][:name]).to eq("orig Name")
      expect(result.count).to eq(2)
    end
    
    it 'returns something when sad path' do
      get api_v1_items_find_all_path, params: { name: "astragalus" }

      expect(response).to be_successful

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to eq([])
    end
  end
end