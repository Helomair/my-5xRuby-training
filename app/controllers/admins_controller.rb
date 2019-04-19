class AdminsController < ApplicationController
	def index
		user = User.find_by(id: session[:user_id])
		if user.permission == "admin"
			@users = User.select("id, name, permission, created_at").order(created_at: :desc).page(params[:page]).per(5)
		else
			redirect_to root_url, notice: t("permission_denied")
		end
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
		
	end



	private
	def user_params
		unless params[:user][:name].nil?
			params.require(:user).permit(:name, :password, :permission)
		end
	end
end
