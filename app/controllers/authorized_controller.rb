class AuthorizedController < ApplicationController
  before_filter :authenticate_user!

  private

  def authenticate_user!
    if !authorized_user?
      render 'auth/notify'
    end
  end

  def authorized_user?
    if request.env['omniauth.auth']
      email = request.env['omniauth.auth'][:info][:email]
      return true if email.index( /@8thlight\.com$/ )
    elsif session[:user_id]
      user = Dojo::Repository.user.find( session[:user_id] )
      return true if user
    end

    return false
  end

end
