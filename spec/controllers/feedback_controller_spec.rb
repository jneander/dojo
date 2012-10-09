require 'spec_helper'

describe FeedbackController do
  render_views

  let(:repo) { Dojo::Repository.feedback }
  let(:attr) {{ author:   "Jeremy",
                kata_id:  1,
                message:  "Good job!" }}

  describe "POST 'create'" do
    
    it "creates a Feedback instance" do
      lambda { post :create, attr }.
        should change(repo.records, :size).by(1)
      last_record(repo).author.should == "Jeremy"
    end

    it "assigns the Feedback instance" do
      post :create, attr
      assigns(:feedback).should == last_record(repo)
    end

    it "redirects to the kata show page" do
      post :create, attr
      response.should redirect_to(kata_path(assigns(:feedback).kata_id))
    end

  end
end
