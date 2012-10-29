require 'dojo/models/kata'
require 'date'

describe Dojo::Kata do

  let(:attr) {{ title:        "Example Title",
                link:         "http://www.vimeo.com/2455304",
                user:         123,
                description:  "Example Description" }}
  let(:kata) { Dojo::Kata.new( attr ) }
  
  it "initializes attributes from a hash" do
    kata.title.should       == "Example Title"
    kata.link.should        == "http://www.vimeo.com/2455304"
    kata.user.should        == 123
    kata.description.should == "Example Description"
  end

  it "has a writable :id attribute" do
    kata.id.should be_nil
    kata.id = 123
    kata.id.should == 123
  end

  it "has a writeable :last_updated attribute" do
    kata.last_updated.should be_nil
    kata.last_updated = DateTime.now
    kata.last_updated.should be_instance_of( DateTime )
  end

  it "::attributes returns a list of alterable attributes" do
    Dojo::Kata.attributes.should == [:id, :title, :link, :user, :description]
  end

end
