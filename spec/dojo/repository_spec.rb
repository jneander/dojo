require 'dojo/repository'

describe Dojo::Repository do
  
  it "#kata refers to a KataRepository singleton" do
    repo = Dojo::Repository.kata
    repo.should be_a Dojo::KataRepository
    Dojo::Repository.kata.should equal repo
  end

end
