module Dojo
  class Feedback
    attr_reader :kata_id, :message
    attr_accessor :id, :user, :created_on

    def initialize(attributes = {})
      @user = attributes[:user]
      @kata_id = attributes[:kata_id]
      @message = attributes[:message]
    end

    def self.attributes
      [:id, :kata_id, :user, :message]
    end

    def ==( feedback )
      equal =      @kata_id == feedback.kata_id
      equal &&=    @message == feedback.message
      equal &&=       @user == feedback.user
      equal &&= @created_on == feedback.created_on
    end

    def eql?( feedback )
      equal =  self == feedback
      equal &&= @id == feedback.id
    end

  end
end
