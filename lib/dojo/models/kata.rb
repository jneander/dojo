module Dojo
  class Kata
    attr_accessor :id, :last_updated
    attr_reader :title, :link, :description

    def initialize(attrs = {})
      @title = attrs[:title]
      @link = attrs[:link]
      @description = attrs[:description]
    end

    def self.attributes
      [:id, :title, :link, :description]
    end

  end
end
