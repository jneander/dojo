require 'dojo/kata_repository'
require 'dojo/feedback_repository'
require 'dojo/user_repository'

module Dojo
  class Repository

    def self.kata
      @kata ||= Dojo::KataRepository.new
    end

    def self.feedback
      @feedback ||= Dojo::FeedbackRepository.new
    end

    def self.user
      @user ||= Dojo::UserRepository.new
    end

  end
end
