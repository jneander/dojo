require 'dojo/models/feedback'

shared_examples "a Feedback Repository" do

  let(:repo) { described_class.new }

  before { @current_time = DateTime.now }
  before(:each) { repo.destroy_all }

  it "#new returns a new Feedback instance" do
    fb = repo.new( user: '123' )
    fb.should be_an_instance_of( Dojo::Feedback )
    fb.user.should == '123'
  end

  it "#save stores a Feedback into the repository" do
    fb = repo.save( repo.new( user: '123' ))
    repo.find( fb.id ).should eql fb
  end

  it "#save assigns a String id if none exists" do
    fb_1 = repo.save( repo.new )
    fb_2 = repo.save( repo.new )
    fb_1.id.should be_an_instance_of( String )
    fb_2.id.should_not == fb_1.id
  end

  it "#save preserves any existing id" do
    fb = repo.new
    fb.id = '500'
    fb = repo.save( fb )
    fb.id.should == '500'
  end

  it "#save ensures any existing id is a String" do
    fb = repo.new
    fb.id = 500
    fb = repo.save( fb )
    fb.id.should == '500'
  end

  it "#save stores all provided attributes" do
    attr = { user: '123', kata_id: '456', message: "Example" }
    fb = repo.save( repo.new( attr ))
    fb = repo.find( fb.id )
    fb.user.should    == attr[ :user ]
    fb.kata_id.should == attr[ :kata_id ]
    fb.message.should == attr[ :message ]
  end

  it "#save stores the datetime of creation" do
    DateTime.stub!( :now ).and_return( @current_time )
    fb = repo.save( repo.new )
    fb.created_on.should == @current_time
  end

  it "#save preserves existing datetime of creation" do
    DateTime.stub!( :now ).and_return( @current_time, @current_time - 4 )
    fb = repo.save( repo.new )
    fb = repo.save( fb )
    fb.created_on.should == @current_time
  end

  it "#find returns the Feedback with requested id" do
    fb = repo.save( repo.new )
    repo.find( fb.id ).should eql fb
  end

  it "#find_by_kata_id returns Feedback with the requested kata_id" do
    fb_1 = repo.save( repo.new( kata_id: '1' ))
    fb_2 = repo.save( repo.new( kata_id: '2' ))
    fb_3 = repo.save( repo.new( kata_id: '2' ))
    repo.find_by_kata_id( '1' ).should == [ fb_1 ]
    repo.find_by_kata_id( '2' ).should == [ fb_2, fb_3 ]
  end

  it "#records returns all Feedback in the repository" do
    fb_1 = repo.save( repo.new( user: '123' ))
    fb_2 = repo.save( repo.new( user: '456' ))
    Hash[ repo.records.map { |k,v| [k, v.user] } ].
      should == { fb_1.id => '123', fb_2.id => '456' }
  end

  it "#destroy_all deletes all Feedback records" do
    fb_1 = repo.save( repo.new )
    fb_2 = repo.save( repo.new )
    repo.destroy_all
    repo.records.should == {}
    repo.find( fb_1.id ).should be_nil
    repo.find( fb_2.id ).should be_nil
  end

end
