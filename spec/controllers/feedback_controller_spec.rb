require 'dojo/validation/feedback_validator'
require 'spec_helper'

describe FeedbackController do
  render_views

  let(:repo) { Dojo::Repository.feedback }
  let(:attr) {{ author:   "Jeremy",
                kata_id:  1,
                message:  "Good job!" }}

  describe "POST 'create'" do
    
    it "with valid parameters creates a Feedback instance" do
      lambda { post :create, attr }.
        should change(repo.records, :size).by(1)
      last_record(repo).author.should == "Jeremy"
    end

    context "with invalid parameters" do

      let(:attr) {{ author: "", kata_id: 1, message: "" }}
      let(:errors) {{ author: "author error" }}

      before(:each) do
        Dojo::FeedbackValidator.stub!( :errors ).and_return( errors )
      end

      it "does not create a Feedback instance" do
        lambda { post :create, attr }.
          should_not change( repo.records, :size )
      end

      it "redirects to the kata show page" do
        post :create, attr
        response.should redirect_to( kata_path( 1 ))
      end

      it "sends a flash for form_values through the redirect" do
        post :create, attr
        expected = Hash[attr.map { |k,v| [k, v.to_s] }]
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
