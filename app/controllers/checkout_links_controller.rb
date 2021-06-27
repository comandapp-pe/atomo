# typed: false

class CheckoutLinksController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    @checkout_link = CheckoutLink.new(checkout_link_params)

    respond_to do |format|
      if @checkout_link.save
        format.html { redirect_to @checkout_link.url }
      end
    end
  end

  private

  def checkout_link_params
    params.require(:checkout_link).permit( :product_id, :format, :length)
  end
end
