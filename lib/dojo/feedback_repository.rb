require 'dojo/models/feedback'

module Dojo
  class FeedbackRepository

    def new(attributes = {})
      Feedback.new(attributes)
    end

    def save(feedback)
      clone = feedback.dup
      clone.id = clone.id || records.size + 1
      clone.created_on = clone.created_on || DateTime.now
      records[clone.id] = clone
    end

    def find(id)
      records[id.to_i]
    end

    def records
      @records ||= {}
    end

    def destroy_all
      @records = {}
    end

  end
end
