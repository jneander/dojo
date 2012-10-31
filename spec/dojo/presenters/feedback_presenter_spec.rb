require 'dojo/repositories/repository'
require 'dojo/presenters/feedback_presenter'

describe Dojo::FeedbackPresenter do

  before do
    repo = Dojo::Repository
    @user = repo.user.save( repo.user.new( name: "John Doe" ))
    feedback = { message: "Example Message", user: @user.id }
    @feedback = repo.feedback.save( repo.feedback.new( feedback ))
    @presenter = Dojo::FeedbackPresenter.new( @feedback )
  end

  it "#message returns the Feedback message" do
    @presenter.message.should be_a( String )
    @presenter.message.should == "Example Message"
  end

  it "#user_name returns the Feedback User creator's name" do
    @presenter.user_name.should be_a( String )
    @presenter.user_name.should == "John Doe"
  end

  it "#created_at returns the Feedback creation timestamp" do
    @presenter.created_at.should be_a( Date )
    @presenter.created_at.should == @feedback.created_on
  end

end
