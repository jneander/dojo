require 'hyperion'
require 'dojo/models/feedback'

module Dojo
  class FeedbackHypRepository

    def new( attributes = {} )
      Feedback.new( attributes )
    end

    def save( feedback )
      hash = feedback_to_hash( feedback )
      hash[:created_on] ||= DateTime.now 
      hash = Hyperion.save( { kind: :feedback }, hash )
      hash_to_feedback( hash ) if hash
    end

    def find( id )
      hash = Hyperion.find_by_key( id )
      hash_to_feedback( hash ) if hash
    end

    def find_by_kata_id( id )
      filters = [[:kata_id, "=", id]]
      Hyperion.find_by_kind( :feedback, filters: filters ).
        map { |hash| hash_to_feedback( hash ) }
    end

    def records
      result = Hyperion.find_by_kind( :feedback ).
        map { |hash| [ hash[:key], hash_to_feedback( hash ) ] }
      Hash[ result ]
    end

    def destroy_all
      Hyperion.delete_by_kind( :feedback )
    end

    private

    def feedback_to_hash( feedback )
      hash = { kata_id: feedback.kata_id, message: feedback.message,
               user: feedback.user, created_on: feedback.created_on }
      hash.update( key: feedback.id ) if feedback.id
      return hash
    end

    def hash_to_feedback( hash )
      feedback = Feedback.new( hash )
      feedback.id = hash[:key]
      feedback.created_on = hash[:created_on]
      return feedback
    end

  end
end
