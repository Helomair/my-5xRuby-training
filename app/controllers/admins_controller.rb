class AdminsController < ApplicationController
	before_action :check_permission

	def index
		@users = User.includes(:tasks).order(created_at: :desc).page(params[:page]).per(5)
	end

	def show
		@user = User.find_by(id: params[:id])
		@tasks = Task.where(user_id: params[:id]).order(status: :asc, end_time: :asc, priority: :desc).page(params[:page]).per(5)
	end

	def new
		@user = User.new
	end

	def edit
	 	@user = User.find_by(id: params[:id])
	end 

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to admins_path, notice: t("user.create.succeed")
		else
			flash[:notice] = t("name_nil_error") if @user.errors.any?
			render :new
		end
	end

	def update
		@user = User.find_by(id: params[:id])
        if @user.update(user_params)
            redirect_to admins_path, notice: t("user.update.succeed")
        else
            flash[:notice] = t("name_nil_error") if @user.errors.any?
            render :edit
        end
	end

	def destroy
		@user = User.includes(:tasks).find_by(id: params[:id])
		if @user && check_admins
			@user.destroy 
			redirect_to admins_path, notice: t("delete_user_success")
		else
			redirect_to admins_path, notice: t("delete_user_failed")
		end
	end



	private
	def user_params
		unless params[:user][:name].nil?
			params.require(:user).permit(:name, :password, :permission)
		end
	end

	def check_permission
		user = User.find_by(id: session[:user_id])
		unless user.permission == "admin"
			redirect_to root_url, notice: t("permission_denied")
		end
	end

	def check_admins
		user = User.where(permission: "admin")
		puts(user.count)
		return false if user.count <= 1
		return true
	end
end
