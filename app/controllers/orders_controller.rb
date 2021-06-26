# typed: false
class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    length = order_params[:length]

    format = order_params[:format]

    code = order_params[:code]

    

    def price(length)
      if length == '15'
        20
      elsif length == '30'
        30
      elsif length == '60'
        40
      end
    end

    signable = {
      currency: 'USD',
      price: "USD:#{price(length)}",
      prod: code,
      qty: '1',
      'return-type': 'redirect',
      'return-url': 'https://serene-woodland-34280.herokuapp.com',
    }.sort.to_h # the signable's keys must be ordered alphabetically

    puts signable

    concat = signable.to_a.map { |key, value| "#{value.length}#{value}" }.join

    secret_word = 'P4nS44ff!@NX5bPV8Wkk9xe8Rk3$vgTZxgU4sYUcCEzKS-wYyfAtvcBEAN!yQVA&'

    args = {
      'empty-cart': '1',
      merchant: '251019015085',
      'product-additional-fields': "format:#{format},length:#{length}",
      tpl: 'default',
    }.merge(signable)

    signature = OpenSSL::HMAC.hexdigest("sha256", secret_word, concat)

    params = args.clone.merge({ 'return-url': CGI.escape(args[:'return-url']) }).to_a.map { |key, value| "#{key}=#{value}" }.join('&') + "&signature=#{signature}"

    url = "https://secure.2checkout.com/checkout/buy?#{params}"

    respond_to do |format|
      format.html { redirect_to url }
    end

    # @order = Order.new(order_params)
    #
    # respond_to do |format|
    #   if @order.save
    #     format.html { redirect_to @order, notice: "Order was successfully created." }
    #     format.json { render :show, status: :created, location: @order }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:length, :format, :code)
    end
end
