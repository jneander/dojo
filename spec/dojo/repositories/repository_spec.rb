require 'dojo/repositories/repository'
require 'dojo/repositories/hyperion/kata_hyp_repository'
require 'dojo/repositories/hyperion/feedback_hyp_repository'
require 'dojo/repositories/hyperion/user_hyp_repository'

describe Dojo::Repository do

  let(:repo) { Dojo::Repository }
  before(:each) { repo.nuke }

  it "default repository types are 'memory'" do
    repo.kata.should be_an_instance_of( Dojo::KataRepository )
    repo.feedback.should be_an_instance_of( Dojo::FeedbackRepository )
    repo.user.should be_an_instance_of( Dojo::UserRepository )
  end

  it "default repositories are singletons" do
    repo.kata.should equal repo.kata
    repo.feedback.should equal repo.feedback
    repo.user.should equal repo.user
  end

  it ":use sets repository type to 'Hyperion'" do
    repo.use( :hyperion )
    repo.kata.should be_an_instance_of( Dojo::KataHypRepository )
    repo.feedback.should be_an_instance_of( Dojo::FeedbackHypRepository )
    repo.user.should be_an_instance_of( Dojo::UserHypRepository )
  end

  it ":use preserves 'Hyperion' singletons" do
    repo.use( :hyperion )
    repo.kata.should equal repo.kata
    repo.feedback.should equal repo.feedback
    repo.user.should equal repo.user
  end

  it ":nuke nullifies Repository references" do
    kata_repo_id = repo.kata.__id__
    user_repo_id = repo.user.__id__
    repo.nuke
    repo.kata.__id__.should_not == kata_repo_id
    repo.user.__id__.should_not == user_repo_id
  end

end
