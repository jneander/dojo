require 'dojo/models/kata'

shared_examples "a Kata Repository" do

  let(:repo) { described_class.new }

  before { @current_time = DateTime.now }
  before(:each) { repo.destroy_all }

  it "#new returns a new Kata instance" do
    kata = repo.new( title: "Example" )
    kata.should be_an_instance_of( Dojo::Kata )
    kata.title.should == "Example"
  end

  it "#save stores a Kata in the repository" do
    kata = repo.save( repo.new )
    repo.find( kata.id ).should eql kata
  end

  it "#save assigns a String id if none exists" do
    kata_1 = repo.save( repo.new )
    kata_2 = repo.save( repo.new )
    kata_1.id.should be_an_instance_of( String )
    kata_2.id.should_not == kata_1.id
  end

  it "#save preserves any existing id" do
    kata = repo.new
    kata.id = '500'
    kata = repo.save( kata )
    kata.id.should == '500'
  end

  it "#save ensures any existing id is a String" do
    kata = repo.new
    kata.id = 500
    kata = repo.save( kata )
    kata.id.should == '500'
  end

  it "#save stores all provided attributes" do
    attr = { title: "Example Title", description: "Example Description",
             link: "https://vimeo.com/50459431", user: '123' }
    kata = repo.save( repo.new( attr ))
    kata = repo.find( kata.id )
    kata.title.should       == attr[ :title ]
    kata.description.should == attr[ :description ]
    kata.link.should        == attr[ :link ]
    kata.user.should        == attr[ :user ]
  end

  it "#save stores the datetime of the last update" do
    DateTime.stub!( :now ).and_return( @current_time )
    kata = repo.save( repo.new )
    kata.last_updated.should == @current_time
  end

  it "#find returns the Kata with requested id" do
    kata = repo.save( repo.new )
    repo.find( kata.id ).should eql kata
  end

  it "#records returns all Katas in the repository" do
    kata_1 = repo.save( repo.new( title: "Example 1"))
    kata_2 = repo.save( repo.new( title: "Example 2"))
    Hash[ repo.records.map { |k,v| [k, v.title] } ].
      should == { kata_1.id => "Example 1", kata_2.id => "Example 2" }
  end

  it "#destroy_all deletes all Kata records" do
    kata_1 = repo.save( repo.new )
    kata_2 = repo.save( repo.new )
    repo.destroy_all
    repo.records.should == {}
    repo.find( kata_1.id ).should be_nil
    repo.find( kata_2.id ).should be_nil
  end

  it "#sort sorts by last_updated in descending order" do
    DateTime.stub!( :now ).
      and_return( @current_time - 3, @current_time - 5, @current_time )
    kata_1 = repo.save( repo.new )
    kata_2 = repo.save( repo.new )
    kata_3 = repo.save( repo.new )
    repo.sort.should == [ kata_3, kata_1, kata_2 ]
  end

end
