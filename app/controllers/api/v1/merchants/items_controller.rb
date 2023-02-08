class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])

    if merchant
      render json: ItemSerializer.new(merchant.items)
    else
      render json: { error: "Merchant not found" }, status: :not_found
    end
  end
end