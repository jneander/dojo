require 'dojo/validation/feedback_validator'

describe Dojo::FeedbackValidator do

  let(:validator) { Dojo::FeedbackValidator }
  let(:params) {{ user:     123,
                  kata_id:  1,
                  message:  "Valid Message" }}

  it ":valid? rejects empty or nil users" do
    validator.valid?( params.update( user: "" )).should be_false
    validator.valid?( params.update( user: nil )).should be_false
  end

  it ":valid? rejects non-integer users" do
    validator.valid?( params ).should be_true
    validator.valid?( params.update( user: "1" )).should be_true
    validator.valid?( params.update( user: "1.0" )).should be_false
    validator.valid?( params.update( user: "a" )).should be_false
  end

  it ":valid? rejects empty or nil kata_ids" do
    validator.valid?( params.update( kata_id: "" )).should be_false
    validator.valid?( params.update( kata_id: nil )).should be_false
  end

  it ":valid? rejects non-integer kata_ids" do
    validator.valid?( params.update( kata_id: "1" )).should be_true
    validator.valid?( params.update( kata_id: "1.0" )).should be_false
    validator.valid?( params.update( kata_id: "a" )).should be_false
  end

  it ":valid? rejects empty or nil messages" do
    validator.valid?( params.update( message: "" )).should be_false
    validator.valid?( params.update( message: nil )).should be_false
  end

  it ":errors returns an Error for empty/nil users" do
    errors = validator.errors( params.update( user: "" ))
    errors[:user].should == "Integer user must be provided"
  end

  it ":errors returns an Error for 'invalid' kata_ids" do
    [ "", "a", "1.0", 1.0 ].each do |arg|
      errors = validator.errors( params.update( kata_id: arg ))
      errors[:kata_id].should == "Integer id must be provided"
    end
  end

  it ":errors returns an Error for empty/nil messages" do
    errors = validator.errors( params.update( message: "" ))
    errors[:message].should == "Message must be provided"
  end

end
