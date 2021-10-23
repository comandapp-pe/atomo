class PhrasesController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]
  before_action :set_phrase, only: %i[ show edit update destroy ]

  # GET /phrases or /phrases.json
  def index
  end

  # GET /phrases/1 or /phrases/1.json
  def show
  end

  # GET /phrases/new
  def new
    @phrase = @order.phrases.new
  end

  # GET /phrases/1/edit
  def edit
  end

  # POST /phrases or /phrases.json
  def create
    @phrase = @order.phrases.new(phrase_params)

    respond_to do |format|
      if @phrase.save
        format.turbo_stream do
          flash.now[:notice] = 'Frase comercial creada.'

          render turbo_stream: [
            turbo_stream.replace(:flash, partial: 'application/flash'),
            turbo_stream.replace(:new_phrase, partial: 'phrases/form', locals: { order: @order, phrase: @order.phrases.new })
          ]
        end
        format.html { redirect_to [:admin, @order], notice: "Phrase was successfully created." }
        format.json { render :show, status: :created, location: @phrase }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:new_phrase, partial: 'phrases/form', locals: { order: @order, phrase: @phrase } ) }
        format.html { render 'admin/orders/show', status: :unprocessable_entity }
        format.json { render json: @phrase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phrases/1 or /phrases/1.json
  def update
    respond_to do |format|
      if @phrase.update(phrase_params)
        format.html { redirect_to @phrase, notice: "Phrase was successfully updated." }
        format.json { render :show, status: :ok, location: @phrase }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @phrase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phrases/1 or /phrases/1.json
  def destroy
    @phrase.destroy

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = 'Frase comercial borrada.'

        render turbo_stream: [
          turbo_stream.replace(:flash, partial: 'application/flash')
        ]
      end
      format.html { redirect_to [:admin, @phrase.order], notice: "Phrase was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_phrase
    @phrase = Phrase.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def phrase_params
    params.require(:phrase).permit(:content)
  end
end
