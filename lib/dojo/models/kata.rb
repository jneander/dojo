module Dojo
  class Kata
    attr_accessor :id, :last_updated
    attr_reader :title, :link, :description

    def initialize(attributes = {})
      @title = attributes[:title]
      @link = attributes[:link]
      @description = attributes[:description]
    end
  end
end
