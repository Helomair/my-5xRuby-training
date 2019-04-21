class TasksController < ApplicationController

    def index
        if params[:status].nil? && params[:search].nil?
            @tasks = Task.where(user_id: session[:user_id]).order(status: :asc, end_time: :asc, priority: :desc).page(params[:page]).per(5)
        elsif params[:search] != nil
            @tasks = Task.where(user_id: session[:user_id]).order(status: :asc, end_time: :asc, priority: :desc).page(params[:page]).per(5)
            if tags_search
                @tasks = @tasks.where(tag_public: 1) if params[:search] == "公事"
                @tasks = @tasks.where(tag_private: 1) if params[:search] == "私事"
                @tasks = @tasks.where(tag_urgent: 1) if params[:search] == "緊急"
            else
                @tasks = @tasks.where(title: params[:search])
            end
        else 
            @tasks = Task.where(status: params[:status],user_id: session[:user_id]).order(status: :asc, end_time: :asc, priority: :desc).page(params[:page]).per(5)
        end
    end

    def new
        @task = Task.new
    end

    def edit
        @task = Task.find_by(id: params[:id])
    end

    #create new task
    def create
        @task = Task.new(task_params)
        @user = User.find_by(id: session[:user_id])
        @user.tasks << @task
        if @user.save
            redirect_to tasks_path, notice: t("new_task_success")
        else
            flash[:notice] = t("title_nil_error") if @user.errors.any?
            render :new
        end
    end

    #update task
    def update
        @task = Task.find_by(id: params[:id])
        if @task.update(task_params)
            redirect_to tasks_path, notice: t("edit_task_success")
        else
            flash[:notice] = t("title_nil_error") if @task.errors.any?
            render :edit
        end
    end

    #delete task
    def destroy
        @task = Task.find_by(id: params[:id])
        @task.destroy if @task
        redirect_to tasks_path, notice: t("delete_task_success")
    end

    private

    def task_params
        if params[:task][:title] != nil
            params.require(:task).permit(:title, :content, :end_time, :status, :priority, :tag_public, :tag_private, :tag_urgent)
        end
    end

    def tags_search
        return true if (params[:search] == "公事") || (params[:search] == "私事") || (params[:search] == "緊急")
    end
end
