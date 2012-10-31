require 'spec_helper'

describe AuthController do
  render_views

  let(:repo) { Dojo::Repository.user }
  let(:attr) {{ name: "John Doe", email: "example@8thlight.com",
                uid: "1234567890", provider: :google_oauth2 }}

  let(:create_with_google) { post 'create', provider: :google_oauth2 }

  it "inherits directly from AuthorizedController" do
    AuthController.ancestors[1].should equal AuthorizedController
  end

  before do
    with_oauth_response( attr )
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

      it "saves user attributes" do
        create_with_google

        user = last_record( repo )
        user.name.should      == attr[:name]
        user.email.should     == attr[:email]
        user.uid.should       == attr[:uid]
        user.provider.should  == attr[:provider]
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

    before(:each) do
      with_oauth_response( attr )
      session[:user_id] = "1234567890"
      delete 'destroy'
    end

    it "returns http success" do
      response.should be_success
    end

    it "removes the User id from the session" do
      session[:user_id].should be_nil
    end

    it "renders the signout template" do
      assert_template :signout
    end

  end

end
