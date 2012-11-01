require 'dojo/models/user'

module Dojo

  class UserRepository

    def new( attributes = {} )
      User.new( attributes )
    end

    def save( user )
      clone = user.dup
      clone.id = ( clone.id || records.size + 1 ).to_s
      records[ clone.id ] = clone
    end

    def find( id )
      records[ id ]
    end

    def find_by_uid( uid, provider )
      records.select { |id, user|
        ( user.uid == uid ) && ( user.provider == provider ) }.values
    end

    def records
      @records ||= {}
    end

    def destroy_all
      @records = {}
    end

  end

end
