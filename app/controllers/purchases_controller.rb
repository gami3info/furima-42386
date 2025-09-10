class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :redirect_if_ineligible

  def index
    gon.public_key = Rails.application.credentials.payjp[:public_key]
    @purchase_shipping_address = PurchaseShippingAddress.new
  end

  def create
    @purchase_shipping_address = PurchaseShippingAddress.new(purchase_params)
    if @purchase_shipping_address.valid?
      pay_item
      @purchase_shipping_address.save
      redirect_to root_path
    else
      gon.public_key = Rails.application.credentials.payjp[:public_key]
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def purchase_params
    params.require(:purchase_shipping_address).permit(:postal_code, :prefecture_id, :city, :street_address, :building_name, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

  def pay_item
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
    Payjp::Charge.create(
      amount: @item.price,
      card: purchase_params[:token],
      currency: 'jpy'
    )
  end

  def redirect_if_ineligible
    redirect_to root_path if current_user.id == @item.user_id || @item.purchase.present?
  end
end