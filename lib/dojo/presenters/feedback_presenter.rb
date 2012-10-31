require 'dojo/repositories/repository'

module Dojo

  class FeedbackPresenter

    def initialize( feedback )
      @feedback = feedback
      @user = Dojo::Repository.user.find( @feedback.user )
    end

    def message
      @feedback.message
    end

    def user_name
      @user.name
    end

    def created_at
      @feedback.created_on
    end

  end

end
