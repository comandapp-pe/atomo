class IdeasController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]
  before_action :set_idea, only: %i[ show edit update destroy ]

  # GET /ideas or /ideas.json
  def index
    @ideas = Idea.all
  end

  # GET /ideas/1 or /ideas/1.json
  def show
  end

  # GET /ideas/new
  def new
    @idea = @order.ideas.new
  end

  # GET /ideas/1/edit
  def edit
  end

  # POST /ideas or /ideas.json
  def create
    @idea = @order.ideas.new(idea_params)

    flash[:success] = 'Idea fuerza creada.'

    respond_to do |format|
      if @idea.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(:new_idea, partial: 'ideas/form', locals: { order: @order, idea: @order.ideas.new }),
            turbo_stream.append(:ideas, @idea),
            turbo_stream.replace(:flash, partial: 'application/flash')
          ]
        end
        format.html { redirect_to [:admin, @order], notice: "Idea was successfully created." }
        format.json { render :show, status: :created, location: @idea }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:new_idea, partial: 'ideas/form', locals: { order: @order, idea: @idea }) }
        format.html { render 'admin/orders/show', status: :unprocessable_entity }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideas/1 or /ideas/1.json
  def update
    respond_to do |format|
      if @idea.update(idea_params)
        format.html { redirect_to @idea, notice: "Idea was successfully updated." }
        format.json { render :show, status: :ok, location: @idea }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1 or /ideas/1.json
  def destroy
    @idea.destroy

    flash[:success] = 'Idea fuerza borrada.'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@idea),
          turbo_stream.replace(:flash, partial: 'application/flash')
        ]
      end
      format.html { redirect_to [:admin, @idea.order], notice: "Idea was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_idea
    @idea = Idea.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def idea_params
    params.require(:idea).permit(:content)
  end
end
