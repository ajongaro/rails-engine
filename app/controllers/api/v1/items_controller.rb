class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(item_params[:id]))
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def destroy
    item = Item.find(params[:id])
    item.invoice_delete
    item.destroy
  end

  def update
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: ItemSerializer.new(item)
  end

  def find_all
    items = Item.find_all_by_name_fragment(item_params[:name])
    if items
      render json: ItemSerializer.new(items)
    else
      render json: ErrorSerializer.le_json, status: 404
    end

  end
  private

  def item_params
    # params.require(:merchant_id) might help return an error if not accurate
    params.permit(:id, :name, :description, :unit_price, :merchant_id)
  end
end