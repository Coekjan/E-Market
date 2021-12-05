class ApplicationController < ActionController::Base
  helper_method :current_account

  def current_account
    @current_account ||= Account.find(session[:current_account_id]) if session[:current_account_id]
  end
end
