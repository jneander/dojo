require 'dojo/models/feedback'

module Dojo
  class FeedbackRepository

    def new( attributes = {} )
      Feedback.new( attributes )
    end

    def save( feedback )
      clone = feedback.dup
      clone.id = ( clone.id || records.size + 1 ).to_s
      clone.created_on = clone.created_on || DateTime.now
      records[ clone.id ] = clone
    end

    def find( id )
      records[ id ]
    end

    def find_by_kata_id( id )
      records.values.select { |fb| fb.kata_id == id }
    end

    def records
      @records ||= {}
    end

    def destroy_all
      @records = {}
    end

  end
end
