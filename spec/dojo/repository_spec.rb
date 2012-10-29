require 'dojo/repository'

describe Dojo::Repository do
  
  it "::kata refers to a KataRepository singleton" do
    repo = Dojo::Repository.kata
    repo.should be_a Dojo::KataRepository
    Dojo::Repository.kata.should equal repo
  end

  it "::feedback refers to a FeedbackRepository singleton" do
    repo = Dojo::Repository.feedback
    repo.should be_a Dojo::FeedbackRepository
    Dojo::Repository.feedback.should equal repo
  end

  it "::user refers to a UserRepository singleton" do
    repo = Dojo::Repository.user
    repo.should be_a Dojo::UserRepository
    Dojo::Repository.user.should equal repo
  end

end
