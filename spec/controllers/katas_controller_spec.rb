require 'spec_helper'

describe KatasController do
  render_views

  before(:each) do
    @base_title = "Dojo"
  end

  describe "GET 'show'" do
    before(:each) do
      @kata = Factory(:kata)
    end

    it "returns http success" do
      get 'show', :id => @kata
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
    before(:each) do
      @attr = { title:       "Example Kata",
                description: "Example Description",
                link:        "https://vimeo.com/50459431" }
    end

    it "creates a kata" do
      lambda { post :create, :kata => @attr }.
        should change(Kata, :count).by(1)
    end

    it "redirects to the kata show page" do
      post :create, :kata => @attr
      response.should redirect_to(kata_path(assigns(:kata)))
    end
  end

end
