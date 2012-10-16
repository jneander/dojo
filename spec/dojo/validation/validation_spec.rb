require 'dojo/validation/validation'

describe Dojo::Validation::Validator do

  let(:validator) { Dojo::Validation::Validator }

  it "#proper_uri? returns false for empty string" do
    validator::present?( "" ).should be_false
  end

  it "#proper_uri? returns false for nil" do
    validator.present?( nil ).should be_false
  end

  it "#proper_uri? returns false for bad protocol" do
    validator.proper_uri?( "htt://www.vimeo.com" ).should be_false
  end

  it "#proper_uri? returns true for accepted protocol" do
    validator.proper_uri?( "http://www.vimeo.com" ).should be_true
    validator.proper_uri?( "https://www.vimeo.com" ).should be_true
  end

  it "#supported_host? return false for non-whitelisted hosts" do
    validator.supported_host?( "http://www.nope.com", [ "yes.com" ] ).
      should be_false
  end

  it "#supported_host? return true for whitelisted hosts" do
    validator.supported_host?( "http://www.yes.com", [ "yes.com" ] ).
      should be_true
  end

end

describe Dojo::Validation::Error do

  it "initializes with a value and message" do
    error = Dojo::Validation::Error.new( "foo", "bar" )
    error.value.should == "foo"
    error.message.should == "bar"
  end

end
