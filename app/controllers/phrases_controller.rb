class PhrasesController < ApplicationController
  before_action :set_phrase, only: %i[ show edit update destroy ]

  # GET /phrases or /phrases.json
  def index
    @phrases = Phrase.all
  end

  # GET /phrases/1 or /phrases/1.json
  def show
  end

  # GET /phrases/new
  def new
    @phrase = Phrase.new
  end

  # GET /phrases/1/edit
  def edit
  end

  # POST /phrases or /phrases.json
  def create
    @phrase = Phrase.new(phrase_params)

    respond_to do |format|
      if @phrase.save
        format.html { redirect_to @phrase, notice: "Phrase was successfully created." }
        format.json { render :show, status: :created, location: @phrase }
      else
        format.html { render :new, status: :unprocessable_entity }
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
      format.html { redirect_to [:admin, @phrase.order], notice: "Phrase was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_phrase
    @phrase = Phrase.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def phrase_params
    params.fetch(:phrase, {})
  end
end
