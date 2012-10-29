require 'spec_helper'

describe AuthController do

  let(:repo) { Dojo::Repository.user }
  let(:attr) {{ name:     "John Doe",
                email:    "foo@bar.com",
                uid:      "1234567890",
                provider: :google_oauth2 }}
  let(:auth_hash) {{ uid:         attr[:uid],
                     provider:    attr[:provider],
                     info:        { name:   attr[:name],
                                    email:  attr[:email] } }}

  let(:create_with_google) { post 'create', provider: :google_oauth2 }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = 
      OmniAuth::AuthHash.new( auth_hash )
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  before(:each) do
    repo.destroy_all
  end

  describe "POST 'create'" do

    context "when user exists" do

      before do
        @user = repo.save( repo.new( attr ))
      end

      it "does not create a new User" do
        lambda { create_with_google }.
          should_not change( repo.records, :size )
      end

      it "stores the User id in the session" do
        create_with_google
        session[:user_id].should == @user.id
      end

      it "redirects to the Kata index" do
        create_with_google
        response.should redirect_to( katas_path )
      end

    end

    context "when uid is not being used" do

      it "creates a user" do
        lambda { create_with_google }.
          should change( repo.records, :size ).by( 1 )
      end

      it "assigns user attributes" do
        create_with_google

        user = last_record( repo )
        user.name.should      == auth_hash[:info][:name]
        user.email.should     == auth_hash[:info][:email]
        user.uid.should       == auth_hash[:uid]
        user.provider.should  == auth_hash[:provider]
      end

      it "stores the User id in the session" do
        create_with_google
        session[:user_id].should == last_record( repo ).id
      end

      it "redirects to the Kata index" do
        create_with_google
        response.should redirect_to( katas_path )
      end

    end

  end

  describe "DELETE 'destroy'" do

    it "removes the User id from the session" do
      session[:user_id] = "1234567890"
      delete 'destroy'
      session[:user_id].should be_nil
    end

    it "redirects to the Kata index" do
      delete 'destroy'
      response.should redirect_to( katas_path )
    end

  end

end
