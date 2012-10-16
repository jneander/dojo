require 'dojo/validation/validation'
require 'uri'

module Dojo
  class KataValidator < Dojo::Validation::Validator

    def self.valid?(params)
      [ valid_title?( params[:title] ),
        present?( params[:link] ),
        present?( params[:description] ),
        proper_uri?( params[:link] ),
        known_host?( params[:link] )
      ].all?
    end

    def self.errors(params)
      result = {}
      if not valid_title?(params[:title])
        result.update( title: "Title must not be blank" )
      end
      if not valid_link?( params[:link] )
        result.update( link: "Link must be valid" )
      end
      if not valid_description?( params[:description] )
        result.update( description: "Description must not be blank" )
      end
      return result
    end

    private

    def self.valid_title?(title)
      present? title
    end

    def self.valid_link?(link)
      [ present?( link ), proper_uri?( link ), known_host?( link ) ].all?
    end

    def self.valid_description?(description)
      present? description
    end

    def self.known_host?(link)
      supported_host?(link, [ 'vimeo.com', 'youtube.com' ])
    end

  end
end
