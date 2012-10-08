require 'spec_helper'

describe KatasController do
  render_views

  let (:repo) { Dojo::Repository.kata }
  let (:attr) {{ title:       "Example Title",
                 description: "Example Description",
                 link:        "https://vimeo.com/50459431" }}

  describe "GET 'show'" do
    it "returns http success" do
      @kata = repo.save(repo.new(attr))
      get 'show', :id => @kata.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "creates a kata" do
      lambda { post :create, attr }.
        should change(repo.records, :size).by(1)
      repo.records[1].title.should == "Example Title"
    end

    it "redirects to the kata show page" do
      post :create, :kata => attr
      response.should redirect_to(kata_path(assigns(:kata).id))
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
