require 'dojo/repository'

class AuthController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']
    user = repo.find_by_uid( auth_hash[:uid], auth_hash[:provider] ).first
    user ||= create_user( auth_hash )
    session[:user_id] = user.id
    redirect_to katas_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to katas_path
  end

  private

  def repo
    Dojo::Repository.user
  end

  def create_user( authhash )
    data = { name:      authhash[:info][:name],
             email:     authhash[:info][:email],
             uid:       authhash[:uid],
             provider:  authhash[:provider] }
    repo.save( repo.new( data ))
  end

end
