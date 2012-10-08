module Dojo
  class Feedback
    attr_reader :author, :kata_id, :message
    attr_accessor :id, :created_on

    def initialize(attributes = {})
      @author = attributes[:author]
      @kata_id = attributes[:kata_id]
      @message = attributes[:message]
    end

  end
end
