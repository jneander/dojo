require 'dojo/validation/feedback_validator'
require 'spec_helper'

describe FeedbackController do
  render_views

  let(:repo) { Dojo::Repository }
  let(:attr) {{ kata_id:  1,
                message:  "Good job!" }}

  it "inherits directly from AuthorizedController" do
    FeedbackController.ancestors[1].should equal AuthorizedController
  end

  before do
    controller.stub!( :authorized_user? ).and_return true
  end

  describe "POST 'create'" do

    before do
      @user = repo.user.save( repo.user.new( id: 123 ))
      session[:user_id] = 123
    end

    context "with valid parameters" do
    
      it "creates a Feedback instance" do
        lambda { post :create, attr }.
          should change( repo.feedback.records, :size ).by( 1 )
        last_record( repo.feedback ).kata_id.should == 1
      end

      it "stores the current User" do
        post :create, attr
        last_record( repo.feedback ).user.should == 123
      end

    end

    context "with invalid parameters" do

      let(:attr) {{ kata_id: 1, message: "" }}
      let(:errors) {{ message: "message error" }}

      before(:each) do
        Dojo::FeedbackValidator.stub!( :errors ).and_return( errors )
      end

      it "does not create a Feedback instance" do
        lambda { post :create, attr }.
          should_not change( repo.feedback.records, :size )
      end

      it "redirects to the kata show page" do
        post :create, attr
        response.should redirect_to( kata_path( 1 ))
      end

      it "sends a flash for form_values through the redirect" do
        post :create, attr
        expected = attr.merge( kata_id: "1" )
        flash[:form_values].should == expected
      end

      it "sends a flash for errors through the redirect" do
        post :create, attr
        flash[:errors].should == errors
      end

    end

    it "redirects to the kata show page" do
      post :create, attr
      response.should redirect_to( kata_path( 1 ))
    end

  end
end
