require 'spec_helper'

describe KatasController do
  render_views

  let (:repo) { Dojo::Repository.kata }
  let (:attr) {{ title:       "Example Title",
                 description: "Example Description",
                 link:        "https://vimeo.com/50459431" }}

  describe "GET 'show'" do

    let(:kata) { repo.save(repo.new(attr)) }

    it "returns http success" do
      get 'show', :id => kata.id
      response.should be_success
    end

    it "renders the correct template" do
      get 'show', :id => kata.id
      assert_template :show
    end

    it "assigns the Kata instance" do
      get 'show', :id => kata.id
      assigns(:kata).should equal kata
    end

    it "assigns the Kata's Feedback instances" do
      fbrepo = Dojo::Repository.feedback
      feedback = [fbrepo.save(fbrepo.new)]
      Dojo::Repository.feedback.stub!(:find_by_kata_id).
        and_return(feedback)
      get 'show', :id => kata.id
      assigns(:feedback).should == feedback
    end

  end

  describe "GET 'new'" do

    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "renders the correct template" do
      get 'new'
      assert_template :new
    end

  end

  describe "POST 'create'" do

    it "creates a Kata instance" do
      lambda { post :create, attr }.
        should change(repo.records, :size).by(1)
      repo.records[1].title.should == "Example Title"
    end

    it "assigns the Kata instance" do
      post :create, attr
      assigns(:kata).should == last_record(repo)
    end

    it "redirects to the kata show page" do
      post :create, attr
      response.should redirect_to(kata_path(assigns(:kata).id))
    end

  end

  describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "renders the correct template" do
      get 'index'
      assert_template :index
    end

    it "assigns the katas from the repository" do
      get 'index'
      assigns(:katas).should == repo.records.values.reverse
    end

  end

end
