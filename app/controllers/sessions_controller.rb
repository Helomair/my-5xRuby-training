class SessionsController < ApplicationController
  skip_before_action :authorize

  def login

  end

  def verify
  	user = User.find_by(name: params[:name])
  	if user and user.authenticate(params[:password])
  		session[:user_id] = user.id
  		redirect_to root_url, notice: t("login_succeed")
  	else
  		redirect_to login_url, notice: t("login_failed")
    end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_url, notice: t("logged_out")
  end
end
