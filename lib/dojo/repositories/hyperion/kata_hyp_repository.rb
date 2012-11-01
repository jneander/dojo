require 'hyperion'
require 'dojo/models/kata'

module Dojo
  class KataHypRepository

    def new( attributes = {} )
      Kata.new( attributes )
    end

    def save( kata )
      hash = kata_to_hash( kata )
      hash[:last_updated] = DateTime.now
      hash = Hyperion.save( { kind: :kata }, hash )
      hash_to_kata( hash ) if hash
    end

    def find( id )
      hash = Hyperion.find_by_key( id )
      hash_to_kata( hash ) if hash
    end

    def records
      result = Hyperion.find_by_kind( :kata ).
        map { |hash| [ hash[:key], hash_to_kata( hash ) ] }
      Hash[ result ]
    end

    def sort
      Hyperion.find_by_kind( :kata, { sorts: [[:last_updated, :desc]] } ).
        map { |hash| hash_to_kata( hash ) }
    end

    def destroy_all
      Hyperion.delete_by_kind( :kata )
    end

    private

    def kata_to_hash( kata )
      hash = { title: kata.title, link: kata.link, 
               description: kata.description, user: kata.user,
               last_updated: kata.last_updated }
      hash.update( key: kata.id.to_s ) if kata.id
      return hash
    end 

    def hash_to_kata( hash )
      kata = Kata.new( hash )
      kata.id = hash[:key]
      kata.last_updated = hash[:last_updated]
      return kata
    end

  end
end
