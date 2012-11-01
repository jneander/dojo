require 'hyperion'
require 'dojo/models/user'

module Dojo

  class UserHypRepository

    def new( attributes = {} )
      User.new( attributes )
    end

    def save( user )
      hash = Hyperion.save( { kind: :user }, user_to_hash( user ) )
      hash_to_user( hash ) if hash
    end

    def find( id )
      hash = Hyperion.find_by_key( id )
      hash_to_user( hash ) if hash
    end

    def find_by_uid( uid, provider )
      filters = [[:provider, "=", provider], [:uid, "=", uid]]
      Hyperion.find_by_kind( :user, { filters: filters } ).
        map { |hash| hash_to_user( hash ) }
    end

    def records
      result = Hyperion.find_by_kind( :user ).
        map { |hash| [ hash[:key], hash_to_user( hash ) ] } 
      Hash[ result ]
    end

    def destroy_all
      Hyperion.delete_by_kind( :user )
    end

    private

    def user_to_hash( user )
      hash = { uid: user.uid, provider: user.provider,
               name: user.name, email: user.email }
      hash.update( key: user.id ) if user.id
      return hash
    end

    def hash_to_user( hash )
      user = User.new( hash )
      user.id = hash[:key].to_s
      return user
    end

  end
  
end
