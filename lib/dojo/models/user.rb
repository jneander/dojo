module Dojo
  
  class User
    attr_accessor :id
    attr_reader :name, :email, :uid, :provider

    def initialize( attr )
      @name     = attr[:name]
      @email    = attr[:email]
      @uid      = attr[:uid]
      @provider = attr[:provider]
    end

  end
  
end
