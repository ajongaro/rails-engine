class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    # find a single merchant by name fragment using where method below
    render json: MerchantSerializer.new(Merchant.find_all_by_name_fragment(merchant_params[:name]).first)
  end

  private

  def merchant_params
    params.permit(:name)
  end
end