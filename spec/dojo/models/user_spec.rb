require 'dojo/models/user'

describe Dojo::User do

  let(:attr) {{ name:         "John Doe",
                email:        "john.doe@example.com",
                uid:          "1234567890",
                provider:     "google_oauth2" }}
  let(:user) { Dojo::User.new( attr ) }

  it "initializes attributes from a hash" do
    user.name.should      == attr[:name]
    user.email.should     == attr[:email]
    user.uid.should       == attr[:uid]
    user.provider.should  == attr[:provider]
  end

  it "has a writable :id attribute" do
    user.id.should be_nil
    user.id = 123
    user.id.should == 123
  end

  it "#== returns true if two instances have equivalent attributes" do
    second = user.clone
    ( user == second ).should be_true
  end

  it "#eql? returns true only if two instances have equivalent attributes" do
    second = user.clone
    ( user.eql? second ).should be_true
    second.id = 123
    ( user.eql? second ).should be_false
  end

end
