require 'dojo/repositories/repository'
require 'dojo/presenters/kata_presenter'
require 'dojo/presenters/feedback_presenter'

describe Dojo::KataPresenter do

  before do
    repo = Dojo::Repository
    repo.feedback.destroy_all
    @user = repo.user.save( repo.user.new( name: "John Doe" ))
    kata = example_kata.update( user: @user.id )
    @kata = repo.kata.save( repo.kata.new( kata))
    @presenter = Dojo::KataPresenter.new( @kata )
  end

  it "#id returns the Kata id" do
    @presenter.id.should be_a( Integer )
    @presenter.id.should == @kata.id
  end

  it "#title returns the Kata title" do
    @presenter.title.should be_a( String )
    @presenter.title.should == example_kata[:title]
  end

  it "#link returns the Kata link" do
    @presenter.link.should be_a( String )
    @presenter.link.should == example_kata[:link]
  end

  it "#description returns the Kata description" do
    @presenter.description.should be_a( String )
    @presenter.description.should == example_kata[:description]
  end

  it "#user_name returns the Kata User creator's name" do
    @presenter.user_name.should be_a( String )
    @presenter.user_name.should == "John Doe"
  end

  it "#updated_at returns the most recent Kata update timestamp" do
    @presenter.updated_at.should be_a( Date )
    @presenter.updated_at.should == @kata.last_updated
  end

  it "#feedback returns an array of FeedbackPresenters for this Kata" do
    fb_1 = save_example_feedback( @kata.id, "First Feedback" )
    fb_2 = save_example_feedback( @kata.id, "Second Feedback" )
    @presenter.feedback.should be_a( Array )
    @presenter.feedback.size.should == 2
    @presenter.feedback.first.should be_a( Dojo::FeedbackPresenter )
    @presenter.feedback.map { |fb| fb.message }.
      should == [ "First Feedback", "Second Feedback" ]
  end

end

def example_kata
  { title:        "Example Title",
    link:         "http://www.vimeo.com/50459431",
    description:  "Example Description",
    user:         123 }
end

def save_example_feedback( kata_id, message )
  repo = Dojo::Repository.feedback
  repo.save( repo.new({ kata_id: kata_id, message: message }))
end
