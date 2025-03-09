class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :correct_task, only: [:show, :edit]

  # GET /tasks or /tasks.json
  def index
    # 検索機能
    if params[:search].present?
      if params[:search][:label] == ""
        params[:search][:label] = nil
      end
      
      if params[:search][:title].present? && params[:search][:status].present? && params[:search][:label]
        label = Label.find(params[:search][:label])
        @tasks = label.tasks.search_by_status(params[:search][:status]).search_by_title(params[:search][:title])
        # @tasks = Task.search_by_status(params[:search][:status]).search_by_title(params[:search][:title])
      elsif params[:search][:title].present?
        @tasks = Task.search_by_title(params[:search][:title])
      elsif params[:search][:status].present? 
        @tasks = Task.search_by_status(params[:search][:status])
      elsif params[:search][:label].present?
        label = Label.find(params[:search][:label])
        @tasks = label.tasks

      end

    else
      # @tasks = Task.all
      @tasks = current_user.tasks
    end

    # params[:sort〜]に値があれば、ソートを変更する
    if params[:sort_deadline_on]
      @tasks = @tasks.order_by_deadline_asc
    elsif params[:sort_priority]
      @tasks = @tasks.order_by_priority_desc
    end

    # 作成日時を降順にソートする
    @tasks = @tasks.order_by_created_desc.page(params[:page])
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
    @task = current_user.tasks.new(task_params) # 作成したユーザのuser_idも登録するように変更

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: t(".notice") }
        format.json { render :show, status: :created, location: @task }
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
      # params[:task][:labal_ids]がnilなら,[]を代入
      params[:task][:label_ids] ||= []
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, { label_ids: [] })
    end

    def correct_task
      # unless current_user.id == Task.find_by(id: params[:id]).user_id
      unless current_users_task?(Task.find_by(id: params[:id]))
        flash[:notice] = "アクセス権限がありません"
        redirect_to tasks_path
      end
    end




end
