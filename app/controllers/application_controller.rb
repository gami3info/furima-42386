class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      # 開発環境では 'admin'/'2222' を使用し、それ以外の環境(本番環境など)では環境変数を使用する
      (Rails.env.development? && username == 'admin' && password == '2222') || (username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD'])
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:nickname, :last_name, :first_name, :last_name_kana, :first_name_kana, :birthday])
  end
end
