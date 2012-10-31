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

    def ==( user )
      equal =       @name == user.name
      equal &&=    @email == user.email
      equal &&=      @uid == user.uid
      equal &&= @provider == user.provider
    end

    def eql?( user )
      equal =  self == user
      equal &&= @id == user.id
    end

  end
  
end
