require 'dojo/models/kata'
require 'date'

module Dojo
  class KataRepository

    def new(attributes = {})
      Kata.new(attributes)
    end

    def save(kata)
      clone = kata.dup
      clone.id = clone.id || records.size + 1
      clone.last_updated = DateTime.now
      records[clone.id] = clone
    end

    def find(id)
      records[id.to_i]
    end

    def records
      @records ||= {}
    end

    def sort
      records.values.sort {|a,b| b.last_updated <=> a.last_updated}
    end

    def destroy_all
      @records = {}
    end

  end
end
