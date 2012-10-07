require 'dojo/kata_repository'

module Dojo
  class Repository

    def self.kata
      @kata ||= Dojo::KataRepository.new
    end

  end
end
