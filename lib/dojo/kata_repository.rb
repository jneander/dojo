require 'dojo/models/kata'

module Dojo
  class KataRepository

    def new(attributes = {})
      Kata.new(attributes)
    end

    def save(kata)
      clone = kata.dup
      clone.id = clone.id || records.size + 1
      @records[clone.id] = clone
    end

    def find(id)
      records[id.to_i]
    end

    def records
      @records ||= {}
    end

    def destroy_all
      @records = {}
    end

  end
end
