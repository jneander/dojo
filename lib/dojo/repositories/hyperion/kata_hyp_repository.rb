require 'hyperion'
require 'dojo/models/kata'

module Dojo
  class KataHypRepository

    def new( attributes = {} )
      Kata.new( attributes )
    end

    def save( kata )
      hash = kata_to_hash( kata )
      hash[:updated_at] = DateTime.now
      hash = Hyperion.save( { kind: :katas }, hash )
      hash_to_kata( hash ) if hash
    end

    def find( id )
      hash = Hyperion.find_by_key( id )
      hash_to_kata( hash ) if hash
    end

    def records
      result = Hyperion.find_by_kind( :katas ).
        map { |hash| [ hash[:key], hash_to_kata( hash ) ] }
      Hash[ result ]
    end

    def sort
      Hyperion.find_by_kind( :katas, { sorts: [[:updated_at, :desc]] } ).
        map { |hash| hash_to_kata( hash ) }
    end

    def destroy_all
      Hyperion.delete_by_kind( :katas )
    end

    private

    def kata_to_hash( kata )
      hash = { title: kata.title, link: kata.link, 
               description: kata.description, user_key: kata.user,
               updated_at: kata.last_updated }
      hash.update( key: kata.id.to_s ) if kata.id
      return hash
    end 

    def hash_to_kata( hash )
      hash.update( user: hash[:user_key] )
      kata = Kata.new( hash )
      kata.id = hash[:key]
      kata.last_updated = hash[:updated_at]
      return kata
    end

  end
end
