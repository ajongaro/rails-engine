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
    if item_params[:name] && (item_params[:min_price] || item_params[:max_price])
      render json: ErrorSerializer.le_json, status: 400
    elsif item_params[:name]
      items = Item.find_all_by_name_fragment(item_params[:name])
      if items
        render json: ItemSerializer.new(items)
      else
        render json: ErrorSerializer.le_json, status: 400
      end
    elsif item_params[:min_price] && !item_params[:max_price]
      items = Item.find_all_items_by_min(item_params[:min_price])
      if items && item_params[:min_price].to_i >= 0
        render json: ItemSerializer.new(items)
      else
        render json: { errors: "Bad query " }, status: 400
      end
    elsif item_params[:max_price] && !item_params[:min_price]
      items = Item.find_all_items_by_min(item_params[:min_price])
      if items && item_params[:max_price].to_i >= 0
        render json: ItemSerializer.new(items)
      else
        render json: { errors: "Bad query" }, status: 400
      end
    else
      render json: ErrorSerializer.le_json, status: 400
    end
  end
  private

  def item_params
    # params.require(:merchant_id) might help return an error if not accurate
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :min_price, :max_price)
  end
end