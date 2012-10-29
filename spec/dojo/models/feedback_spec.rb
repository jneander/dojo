require 'dojo/models/feedback'
require 'date'

describe Dojo::Feedback do

  let(:attr) {{ user:       123,
                kata_id:    456,
                message:    "Good job!" }}
  let(:feedback) { Dojo::Feedback.new( attr ) }

  it "initializes attributes from a hash" do
    feedback.user.should    == 123
    feedback.kata_id.should == 456
    feedback.message.should == "Good job!"
  end

  it "has a writeable :id attribute" do
    feedback.id.should be_nil
    feedback.id = 500
    feedback.id.should == 500
  end

  it "has a writeable :created_on attribute" do
    feedback.created_on.should be_nil
    feedback.created_on = DateTime.now
    feedback.created_on.should be_instance_of( DateTime )
  end

  it "::attributes returns a list of alterable attributes" do
    Dojo::Feedback.attributes.should == [:id, :kata_id, :user, :message]
  end

end
