# typed: false

class CheckoutLinksController < ApplicationController
  protect_from_forgery with: :null_session

  # POST /checkout_link or /checkout_link.json
  def create
    @checkout_link = CheckoutLink.new(checkout_link_params)

    respond_to do |format|
      if @checkout_link.save
        format.html { redirect_to @checkout_link.url, allow_other_host: true }
      else
        format.html { head :unprocessable_entity }
      end
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def checkout_link_params
      params.require(:checkout_link).permit( :product_id, :format, :length)
    end
end
