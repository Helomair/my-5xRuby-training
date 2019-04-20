class ApplicationController < ActionController::Base
	before_action :set_locale
	before_action :authorize

	def set_locale
	  # 可以將 ["en", "zh-TW"] 設定為 VALID_LANG 放到 config/environment.rb 中
	  if params[:locale] && I18n.available_locales.include?( params[:locale].to_sym )
	    session[:locale] = params[:locale]
	  end

	  I18n.locale = session[:locale] || I18n.default_locale
	end

	private
	def authorize
		unless User.find_by(id: session[:user_id])
			redirect_to login_path, notice: "Please log in"
		end
	end
end
