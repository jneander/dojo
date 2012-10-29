module Dojo
  class Feedback
    attr_reader :kata_id, :message
    attr_accessor :id, :user, :created_on

    def initialize(attributes = {})
      @user = attributes[:user].to_i
      @kata_id = attributes[:kata_id].to_i
      @message = attributes[:message]
    end

    def self.attributes
      [:id, :kata_id, :user, :message]
    end

  end
end
