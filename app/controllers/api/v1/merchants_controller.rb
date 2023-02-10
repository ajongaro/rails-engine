class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    merchant = Merchant.find_all_by_name_fragment(merchant_params[:name]).first
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: ErrorSerializer.le_json, status: 404
    end
  end

  private

  def merchant_params
    params.permit(:name)
  end
end