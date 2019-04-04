class TasksController < ApplicationController


    def index
        if (params[:status].nil? ) && (params[:search].nil? )
            @tasks = Task.all.order(:end_time)
        elsif params[:search] != nil
            @tasks = Task.where(title: params[:search]).order(:end_time)
        else 
            @tasks = Task.where(status: params[:status]).order(:end_time)
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
        if @task.save
            redirect_to tasks_path, notice: t("new_task_success")
        else
            flash[:notice] = t("title_nil_error") if @task.errors.any?
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
            params.require(:task).permit(:title,:content,:end_time,:status)
        end
    end
end
