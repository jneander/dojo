require 'dojo/feedback_repository'
require 'date'

describe Dojo::FeedbackRepository do
  
  let(:repo) { Dojo::FeedbackRepository.new }

  it "#new returns a new Feedback instance" do
    fb = repo.new( :user => 123 )
    fb.should_not be_nil
    fb.user.should == 123
  end

  it "#save stores the feedback in the repository" do
    fb = repo.save( repo.new( :user => 123 ))
    repo.records[fb.id].user.should == fb.user
  end

  it "#save assigns an id if none exists" do
    fb_1 = repo.save( repo.new( :user => 123 ))
    fb_2 = repo.save( repo.new( :user => 456 ))
    fb_1.id.should == 1
    fb_2.id.should == 2
  end

  it "#save preserves existing id" do
    fb = repo.new( :user => 123 )
    fb.id = 500
    fb = repo.save( fb )
    fb.id.should == 500
  end

  it "#save stores the datetime of creation" do
    create_time = DateTime.now
    DateTime.stub!( :now ).and_return( create_time )
    fb = repo.save( repo.new( :user => 123 ))
    fb.created_on.should == create_time
  end

  it "#save preserves existing datetime of creation" do
    create_time = DateTime.now
    DateTime.stub!( :now ).and_return( create_time )
    fb = repo.save( repo.new( :user => 123 ))
    DateTime.stub!( :now ).and_return( create_time - 4 )
    fb = repo.save( fb )
    fb.created_on.should == create_time
  end

  it "#find returns the Feedback with requested id" do
    fb = repo.save( repo.new( :user => 123 ))
    repo.find( fb.id ).user.should == 123
  end

  it "#find_by_kata_id returns Feedback with the requested kata_id" do
    fb_k1 = repo.save( repo.new( :kata_id => 1 ))
    fb_k2 = repo.save( repo.new( :kata_id => 2 ))
    repo.find_by_kata_id( 1 ).should == [fb_k1]
    repo.find_by_kata_id( 2 ).should == [fb_k2]
  end

  it "#records returns all Feedback in the repository" do
    repo.save( repo.new( :user => 123 ))
    repo.save( repo.new( :user => 456 ))
    Hash[repo.records.map { |k,v| [k, v.user] }].should ==
      { 1 => 123, 2 => 456 }
  end

  it "#destroy_all clears all records" do
    repo.save( repo.new( :user => 123 ))
    repo.destroy_all
    repo.records.should == {}
  end

end
