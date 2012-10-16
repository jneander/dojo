class ApplicationController < ActionController::Base
  protect_from_forgery

  def symbolize_keys(hash)
    Hash[hash.map {|k,v| [k.to_sym, v]}]
  end

end
