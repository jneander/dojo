require 'dojo/feedback_repository'
require 'date'

describe Dojo::FeedbackRepository do
  
  let(:repo) { Dojo::FeedbackRepository.new }

  it "#new returns a new Feedback instance" do
    fb = repo.new(:author => "Jeremy")
    fb.should_not be_nil
    fb.author.should == "Jeremy"
  end

  it "#save stores the feedback in the repository" do
    fb = repo.save(repo.new(:author => "Mike"))
    repo.records[fb.id].author.should == fb.author
  end

  it "#save assigns an id if none exists" do
    fb_1 = repo.save(repo.new(:author => "Jeremy"))
    fb_2 = repo.save(repo.new(:author => "Mike"))
    fb_1.id.should == 1
    fb_2.id.should == 2
  end

  it "#save preserves existing id" do
    fb = repo.new(:author => "Jeremy")
    fb.id = 500
    fb = repo.save(fb)
    fb.id.should == 500
  end

  it "#save stores the datetime of creation" do
    create_time = DateTime.now
    DateTime.stub!(:now).and_return(create_time)
    fb = repo.save(repo.new(:author => "Jeremy"))
    fb.created_on.should == create_time
  end

  it "#save preserves existing datetime of creation" do
    create_time = DateTime.now
    DateTime.stub!(:now).and_return(create_time)
    fb = repo.save(repo.new(:author => "Jeremy"))
    DateTime.stub!(:now).and_return(create_time - 4)
    fb = repo.save(fb)
    fb.created_on.should == create_time
  end

  it "#find returns the Feedback with requested id" do
    fb = repo.save(repo.new(:author => "Jeremy"))
    repo.find(fb.id).author.should == "Jeremy"
  end

  it "#records returns all Feedback in the repository" do
    repo.save(repo.new(:author => "Mike"))
    repo.save(repo.new(:author => "Jeremy"))
    Hash[repo.records.map {|k,v| [k, v.author]}].should ==
      {1 => "Mike", 2 => "Jeremy"}
  end

  it "#destroy_all clears all records" do
    repo.save(repo.new(:author => "Jeremy"))
    repo.destroy_all
    repo.records.should == {}
  end

end
