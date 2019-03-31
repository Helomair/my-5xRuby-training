class TasksController < ApplicationController


    def index
        @tasks = Task.all.order(:created_at)
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
            redirect_to tasks_path, notice: "新增任務成功"
        else
            render :new
        end
    end

    #update task
    def update
        @task = Task.find_by(id: params[:id])
        if @task.update(task_params)
            redirect_to tasks_path, notice: "更新資料成功"
        else
            render :edit
        end
    end

    #delete task
    def destroy
        @task = Task.find_by(id: params[:id])
        @task.destroy if @task
        redirect_to tasks_path, notice: "任務已刪除！"
    end

    private
    def task_params
        params.require(:task).permit(:title,:content)
    end
end
