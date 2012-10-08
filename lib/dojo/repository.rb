require 'dojo/kata_repository'
require 'dojo/feedback_repository'

module Dojo
  class Repository

    def self.kata
      @kata ||= Dojo::KataRepository.new
    end

    def self.feedback
      @feedback ||= Dojo::FeedbackRepository.new
    end

  end
end
