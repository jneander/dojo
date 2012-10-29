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

    def self.attributes
      [:id, :title, :link, :user, :description]
    end

  end
end
