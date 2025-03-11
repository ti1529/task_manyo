class LabelsController < ApplicationController

  before_action :set_label, only: [:edit, :update, :destroy]

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.new(label_params)
    if @label.save
      redirect_to labels_path, notice: t(".notice")
    else
      render :new
    end
  end

  def index
    # @labels = Label.includes(:tasks)
    @labels = current_user.labels.includes(:tasks)
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: t(".notice")
    else
      render :edit
    end
  end

  def destroy
    if @label.destroy
      redirect_to labels_path, notice: t(".notice")
    else
      render :index
    end
  end



  private

  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = Label.find(params[:id])
  end

end
