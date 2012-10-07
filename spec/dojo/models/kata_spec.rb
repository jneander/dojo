require 'dojo/models/kata'

describe Dojo::Kata do

  let(:attr) {{ title:         "Example Title",
                link:          "http://www.vimeo.com/2455304",
                description:   "Example Description" }}
  
  it "initializes attributes from a hash" do
    @kata = Dojo::Kata.new(attr)
    @kata.title.should == "Example Title"
    @kata.link.should == "http://www.vimeo.com/2455304"
    @kata.description.should == "Example Description"
  end

  it "has a writable :id attribute" do
    @kata = Dojo::Kata.new(attr)
    @kata.id.should be_nil
    @kata.id = 123
    @kata.id.should == 123
  end
end
