require 'dojo/models/kata'
require 'date'

describe Dojo::Kata do

  let(:attr) {{ title: "Example Title", description: "Example Description",
                link: "http://www.vimeo.com/2455304", user: 123 }}
  before(:each) { @kata = Dojo::Kata.new( attr ) }
  
  it "initializes attributes from a hash" do
    @kata.title.should       == "Example Title"
    @kata.link.should        == "http://www.vimeo.com/2455304"
    @kata.user.should        == 123
    @kata.description.should == "Example Description"
  end

  it "#update changes attributes from a hash" do
    updates = { title: "New Title", description: "New Text",
                link: "http://www.youtube.com/watch?v=0xtPlviSkxs" }
    @kata.update( updates ).should eql @kata
    @kata.title.should        == updates[:title]
    @kata.link.should         == updates[:link]
    @kata.description.should  == updates[:description]
  end

  it "has a writable :id attribute" do
    @kata.id.should be_nil
    @kata.id = 123
    @kata.id.should == 123
  end

  it "has a writeable :last_updated attribute" do
    @kata.last_updated.should be_nil
    @kata.last_updated = DateTime.now
    @kata.last_updated.should be_instance_of( DateTime )
  end

  it "::attributes returns a list of alterable attributes" do
    Dojo::Kata.attributes.
      should == [:id, :title, :link, :user, :description]
  end

  it "#== returns true if two instances have equivalent attributes" do
    second = @kata.clone
    ( @kata == second ).should be_true
  end

  it "#eql? returns true only if two instances have equivalent attributes" do
    second = @kata.clone
    ( @kata.eql? second ).should be_true
    second.id = 123
    ( @kata.eql? second ).should be_false
  end

end
