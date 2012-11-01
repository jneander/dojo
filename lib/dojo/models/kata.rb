module Dojo
  class Kata
    attr_accessor :id, :user, :last_updated
    attr_reader :title, :link, :description

    def initialize( attrs = {} )
      @title        = attrs[:title]
      @link         = attrs[:link]
      @user         = attrs[:user]
      @description  = attrs[:description]
    end

    def update( attrs = {} )
      @title       = attrs[:title] if attrs[:title]
      @link        = attrs[:link] if attrs[:link]
      @description = attrs[:description] if attrs[:description]
      return self
    end

    def self.attributes
      [:id, :title, :link, :user, :description]
    end

    def ==( kata )
      equal =          @title == kata.title
      equal &&=         @link == kata.link
      equal &&=         @user == kata.user
      equal &&=  @description == kata.description
      equal &&= @last_updated == kata.last_updated
    end

    def eql?( kata )
      equal =  self == kata
      equal &&= @id == kata.id
    end

  end
end
