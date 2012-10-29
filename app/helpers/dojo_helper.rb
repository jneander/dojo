module DojoHelper

  def current_user
    if session[:user_id]
      @current_user ||= Dojo::Repository.user.find( session[:user_id] )
    end
  end

end
