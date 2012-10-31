require 'dojo/repositories/hyperion/kata_hyp_repository'
require 'dojo/repositories/hyperion/feedback_hyp_repository'
require 'dojo/repositories/hyperion/user_hyp_repository'
require 'dojo/repositories/memory/kata_repository'
require 'dojo/repositories/memory/feedback_repository'
require 'dojo/repositories/memory/user_repository'

module Dojo
  class Repository

    def self.use( usage )
      @repos = {} if !@repos
      @repos[ usage ] = {} if !@repos[ usage ]
      @kata =     get_singleton( usage, :kata )
      @feedback = get_singleton( usage, :feedback )
      @user =     get_singleton( usage, :user )
    end

    def self.kata
      use( :memory ) unless @kata
      return @kata
    end

    def self.feedback
      use( :memory ) unless @feedback
      return @feedback
    end

    def self.user
      use( :memory ) unless @user
      return @user
    end

    def self.nuke
      @repos = nil
      @kata = nil
      @feedback = nil
      @user = nil
    end

    private

    def self.types
      { memory:   { kata:     Dojo::KataRepository,
                    feedback: Dojo::FeedbackRepository,
                    user:     Dojo::UserRepository },
        hyperion: { kata:     Dojo::KataHypRepository,
                    feedback: Dojo::FeedbackHypRepository,
                    user:     Dojo::UserHypRepository }}
    end

    def self.get_singleton( usage, type )
      @repos[ usage ][ type ] ||= types[ usage ][ type ].new
    end

  end
end
