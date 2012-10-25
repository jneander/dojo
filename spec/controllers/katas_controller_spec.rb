require 'dojo/services/vimeo_service'
require 'dojo/services/youtube_service'
require 'spec_helper'

describe KatasController do
  render_views

  let(:repo) { Dojo::Repository.kata }
  let(:base_attr) {{ title:       "Example Title",
                     description: "Example Description" }}

  describe "GET 'show'" do

    let(:attr) { base_attr.update({ link: "http://google.com" }) }
    let(:kata) { repo.save(repo.new( attr )) }

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
      assigns( :kata ).should equal kata
    end

    it "assigns the Kata's Feedback instances" do
      fbrepo = Dojo::Repository.feedback
      feedback = [fbrepo.save( fbrepo.new )]
      Dojo::Repository.feedback.stub!( :find_by_kata_id ).
        and_return( feedback )
      get 'show', :id => kata.id
      assigns( :feedback ).should == feedback
    end

    context "using VimeoService" do

      let(:uri) { "https://vimeo.com/50459431" }
      let(:service) { Dojo::Media::VimeoService }
      let(:attr) { base_attr.update( link: uri ) }
      let(:kata) { repo.save(repo.new( attr )) }

      before(:each) do 
        @video = example_vimeo_video
      end

      it "assigns a VimeoService embed" do
        service.should_receive( :embed ).and_return( @video )
        get 'show', :id => kata.id
        assigns( :video ).should == @video
      end

      it "renders the vimeo partial if video exists" do
        service.stub!( :embed ).and_return( @video )
        get 'show', :id => kata.id
        response.should render_template( partial: '_vimeo' )
      end

      it "renders the broken_embed partial if video was removed" do
        service.stub!( :embed ).and_return( nil )
        get 'show', :id => kata.id
        response.should render_template( partial: '_broken_embed' )
      end

    end

    context "using YouTubeService" do

      let(:uri) { "http://www.youtube.com/watch?v=0xtPlviSkxs" }
      let(:service) { Dojo::Media::YouTubeService }
      let(:attr) { base_attr.update( link: uri ) }
      let(:kata) { repo.save(repo.new( attr )) }

      before(:each) do
        @video = example_youtube_video
      end

      it "assigns a YouTubeService embed" do
        service.should_receive( :embed ).and_return( @video )
        get 'show', :id => kata.id
        assigns( :video ).should == @video
      end

      it "renders the youtube partial if video exists" do
        service.stub!( :embed ).and_return( @video )
        get 'show', :id => kata.id
        response.should render_template( partial: '_youtube' )
      end

      it "renders the broken_embed partial if video was removed" do
        service.stub!( :embed ).and_return( nil )
        get 'show', :id => kata.id
        response.should render_template( partial: '_broken_embed' )
      end

    end

  end

  describe "GET 'new'" do

    let(:attr) {{ title: "", link: "", description: "" }}
    let(:errors) {{ title: "test value" }}

    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "renders the correct template" do
      get 'new'
      assert_template :new
    end

    it "assigns no errors or form_values for new form" do
      get 'new'
      assigns( :form_values ).should == {}
      assigns( :errors ).should == {}
    end

    it "assigns values if errors exist" do
      get 'new', nil, nil, { :form_values => attr }
      assigns( :form_values ).should == stringify_keys( attr )
    end

    it "assigns errors when present" do
      get 'new', nil, nil, { :errors => errors }
      assigns( :errors ).should == stringify_keys( errors )
    end

  end

  describe "POST 'create'" do

    context "with valid parameters" do

      let(:uri) { "https://vimeo.com/50459431" }
      let(:attr) { base_attr.update( link: uri ) }

      it "creates a Kata instance" do
        lambda { post :create, attr }.
          should change( repo.records, :size ).by( 1 )
        repo.records[1].title.should == "Example Title"
      end

      it "assigns the Kata instance" do
        post :create, attr
        assigns( :kata ).should == last_record( repo )
      end

      it "redirects to the kata show page upon success" do
        post :create, attr
        response.should redirect_to(kata_path( assigns( :kata ).id ))
      end

    end

    context "with invalid parameters" do

      let(:attr) {{ title: "", link: "", description: "" }}
      let(:errors) {{ title: "test value" }}

      before(:each) do
        Dojo::KataValidator.stub!( :errors ).and_return( errors )
      end

      it "does not create a Kata instance" do
        lambda { post :create, attr }.
          should_not change( repo.records, :size )
      end

      it "redirects to the new kata page for unknown host" do
        post :create, attr
        response.should redirect_to( new_kata_path )
      end

      it "sends a flash for form_values through the redirect" do
        post :create, attr
        flash[:form_values].should == attr
      end

      it "sends a flash for errors through the redirect" do
        post :create, attr
        flash[:errors].should == errors
      end

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
      assigns( :katas ).should == repo.records.values.reverse
    end

  end

end

def stringify_keys( hash )
  Hash[hash.map { |k,v| [k.to_s, v] }]
end

def example_vimeo_video
  video = Dojo::Media::VimeoVideo.new
  video.title = "Example Title"
  video.width = 1152
  video.height = 720
  return video
end

def example_youtube_video
  video = Dojo::Media::YouTubeVideo.new
end
