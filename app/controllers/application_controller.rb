class ApplicationController < ActionController::Base
  helper_method :current_account, :roles, :all_roles, :current_admin?, :current_seller?, :current_customer?

  def current_account
    @current_account ||= Account.find(session[:current_account_id]) if session[:current_account_id]
  end

  def roles
    %w[Seller Customer]
  end

  def all_roles
    %w[Seller Customer Admin]
  end

  def current_admin?
    current("Admin")
  end

  def current_seller?
    current("Seller")
  end

  def current_customer?
    current("Customer")
  end

  private
    def current(role)
      current_account && current_account.role == role
    end
end
