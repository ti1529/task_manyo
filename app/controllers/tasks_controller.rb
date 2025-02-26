class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    # 検索機能
    if params[:search].present?
      if params[:search][:title].present? && params[:search][:status].present?
        @tasks = Task.where(status: params[:search][:status]).where("title LIKE ?", "%#{params[:search][:title]}%").page(params[:page])
      elsif params[:search][:title].present?
        @tasks = Task.where("title LIKE ?", "%#{params[:search][:title]}%").page(params[:page])

      elsif params[:search][:status].present? 
        @tasks = Task.where(status: params[:search][:status]).page(params[:page])
      end
      
    else
      # params[:sort〜]に値がない場合は従来どおり、値があればソートを変更する
      if params[:sort_deadline_on]
        # 終了期限を昇順にソートする
        @tasks = Task.all.order(deadline_on: "ASC").page(params[:page])
      elsif params[:sort_priority]
        # 優先度を降順にソートする
        @tasks = Task.all.order(priority: "DESC").page(params[:page])
      else
        # 作成日時を降順にソートする
        @tasks = Task.all.order(created_at: "DESC").page(params[:page])
      end

    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: t(".notice") }
        format.json { render :show, status: :created, location: @task } # 不要？？
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: t(".notice") }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t(".notice") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
    end
end
