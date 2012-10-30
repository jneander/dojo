require 'dojo/presenters/feedback_presenter'
require 'dojo/repository'

module Dojo

  class KataPresenter

    def initialize( kata )
      @kata = kata
      @user = Dojo::Repository.user.find( @kata.user )
    end

    def id
      @kata.id
    end

    def title
      @kata.title
    end

    def link
      @kata.link
    end

    def description
      @kata.description
    end

    def user_name
      @user.name
    end

    def updated_at
      @kata.last_updated
    end

    def feedback
      feedback = Dojo::Repository.feedback.find_by_kata_id( @kata.id )
      feedback.map { |fb| Dojo::FeedbackPresenter.new( fb ) }
    end

  end

end
