require 'spec_helper'

describe Kata do
  
  it "initializes with link, description, and title" do
    @kata = Kata.new(title: "Kata Title", 
                     link: "http://www.vimeo.com/2455304", 
                     description: "Description")
    @kata.title.should == "Kata Title"
    @kata.link.should == "http://www.vimeo.com/2455304"
    @kata.description.should == "Description"
  end

end
