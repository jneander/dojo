require 'spec_helper'

describe KataController do
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

    it "has the correct title" do
      get 'show', :id => @kata
      response.should have_selector(
        "title", :content => "#{@base_title} | Show Kata")
    end
    
    it "finds the correct kata" do
      get 'show', :id => @kata
      assigns(:kata).should == @kata
    end
  end

end
