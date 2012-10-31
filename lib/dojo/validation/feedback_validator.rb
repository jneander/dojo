require 'dojo/validation/validation'

module Dojo
  class FeedbackValidator < Dojo::Validation::Validator

    def self.valid?( params )
      errors( params ) == {}
    end

    def self.errors( params )
      result = {}
      if not present?( params[:user] )
        result.update( user: "User id must be provided" )
      end
      if not present?( params[:kata_id] )
        result.update( kata_id: "Kata id must be provided" )
      end
      if not present?( params[:message] )
        result.update( message: "Message must be provided" )
      end
      return result
    end

    private

    def self.integer?( value )
      not value.to_s.match( /^\d+$/ ).nil? rescue false
    end

  end
end
