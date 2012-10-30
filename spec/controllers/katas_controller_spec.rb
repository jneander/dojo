require 'dojo/services/vimeo_service'
require 'dojo/services/youtube_service'
require 'spec_helper'

describe KatasController do
  render_views

  let(:repo) { Dojo::Repository }
  let(:base_attr) {{ title:       "Example Title",
                     description: "Example Description" }}

  describe "GET 'show'" do

    let(:attr) { base_attr.update({ link: "http://google.com" }) }

    before(:each) do
      @user = repo.user.save( repo.user.new({}))
      session[:user_id] = @user.id
      @kata = repo.kata.save(repo.kata.new( attr.update( user: @user.id ) ))
    end

    it "returns http success" do
      get 'show', :id => @kata.id
      response.should be_success
    end

    it "renders the correct template" do
      get 'show', :id => @kata.id
      assert_template :show
    end

    it "assigns a KataPresenter for this Kata" do
      get 'show', :id => @kata.id
      assigns( :kata ).should be_a( Dojo::KataPresenter )
      assigns( :kata ).title.should == @kata.title
    end

    context "with Feedback" do

      before do
        repo.feedback.save( repo.feedback.new(
          { user: @user.id, kata_id: @kata.id, message: "One" }))
        repo.feedback.save( repo.feedback.new(
          { user: @user.id, kata_id: @kata.id, message: "Two" }))
      end

      it "assigns an array of FeedbackPresenters for this Kata" do
        get 'show', :id => @kata.id
        feedback = assigns( :feedback )
        feedback.should be_a( Array )
        feedback.first.should be_a( Dojo::FeedbackPresenter )
        feedback.map { |fb| fb.message }.should == [ "One", "Two" ]
      end

      it "assigns no errors or form_values for new form" do
        get 'show', :id => @kata.id
        assigns( :form_values ).should == {}
        assigns( :errors ).should == {}
      end

      it "assigns values if errors exist" do
        get 'show', { :id => @kata.id }, nil, { :form_values => attr }
        assigns( :form_values ).should == stringify_keys( attr )
      end

      it "assigns errors when present" do
        errors = { message: "message error" }
        get 'show', { :id => @kata.id }, nil, { :errors => errors }
        assigns( :errors ).should == stringify_keys( errors )
      end

    end

    context "using VimeoService" do

      let(:uri) { "https://vimeo.com/50459431" }
      let(:service) { Dojo::Media::VimeoService }
      let(:attr) { base_attr.update( link: uri ) }

      before(:each) do 
        @video = example_vimeo_video
        @kata = repo.kata.save(repo.kata.new( attr ))
      end

      it "assigns a VimeoService embed" do
        service.should_receive( :embed ).and_return( @video )
        get 'show', :id => @kata.id
        assigns( :video ).should == @video
      end

      it "renders the vimeo partial if video exists" do
        service.stub!( :embed ).and_return( @video )
        get 'show', :id => @kata.id
        response.should render_template( partial: '_vimeo' )
      end

      it "renders the broken_embed partial if video was removed" do
        service.stub!( :embed ).and_return( nil )
        get 'show', :id => @kata.id
        response.should render_template( partial: '_broken_embed' )
      end

    end

    context "using YouTubeService" do

      let(:uri) { "http://www.youtube.com/watch?v=0xtPlviSkxs" }
      let(:service) { Dojo::Media::YouTubeService }
      let(:attr) { base_attr.update( link: uri ) }

      before(:each) do
        @video = example_youtube_video
        @kata = repo.kata.save(repo.kata.new( attr ))
      end

      it "assigns a YouTubeService embed" do
        service.should_receive( :embed ).and_return( @video )
        get 'show', :id => @kata.id
        assigns( :video ).should == @video
      end

      it "renders the youtube partial if video exists" do
        service.stub!( :embed ).and_return( @video )
        get 'show', :id => @kata.id
        response.should render_template( partial: '_youtube' )
      end

      it "renders the broken_embed partial if video was removed" do
        service.stub!( :embed ).and_return( nil )
        get 'show', :id => @kata.id
        response.should render_template( partial: '_broken_embed' )
      end

    end

  end

  describe "GET 'new'" do

    let(:attr) {{ title: "", link: "", description: "" }}
    let(:errors) {{ title: "title error" }}

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

  describe "GET 'edit'" do

    before(:all) do
      attr = base_attr.update({ link: "http://google.com" })
      @kata = repo.kata.save(repo.kata.new( attr ))
    end

    context "without errors" do

      before(:each) { get 'edit', :id => @kata.id }

      it "returns http success" do
        response.should be_success
      end

      it "renders the correct template" do
        assert_template :edit
      end

      it "assigns form_values with @kata attributes" do
        form_values = { id:          @kata.id,
                        title:       @kata.title,
                        link:        @kata.link,
                        description: @kata.description }
        assigns( :form_values ).should == stringify_keys( form_values )
      end

      it "renders the form partial" do
        response.should render_template( partial: '_form' )
      end

      it "assigns errors with an empty hash" do
        assigns( :errors ).should be_a( Hash )
      end

    end

    context "with errors" do

      let(:attr) {{ title: "", link: "", description: "" }}
      let(:errors) {{ title: "title error" }}

      it "assigns form_values from parameters" do
        get 'edit', { :id => @kata.id }, nil, { :form_values => attr }
        assigns( :form_values ).should == stringify_keys( attr )
      end

      it "assigns errors" do
        get 'edit', { :id => @kata.id }, nil, { :errors => errors }
        assigns( :errors ).should == stringify_keys( errors )
      end

    end

  end

  describe "POST 'create'" do

    context "with valid parameters" do

      let(:uri) { "https://vimeo.com/50459431" }
      let(:attr) { base_attr.update( link: uri ) }

      it "creates a Kata instance" do
        lambda { post :create, attr }.
          should change( repo.kata.records, :size ).by( 1 )
        last_record( repo.kata ).title.should == "Example Title"
      end

      it "assigns the current User" do
        repo.user.save( repo.user.new( id: 123 ))
        session[:user_id] = 123
        post :create, attr
        last_record( repo.kata ).user.should == 123
      end

      it "redirects to the kata show page upon success" do
        post :create, attr
        response.should redirect_to(kata_path( last_record( repo.kata ).id ))
      end

    end

    context "with invalid parameters" do

      let(:attr) {{ title: "", link: "", description: "" }}
      let(:errors) {{ title: "title error" }}

      before(:each) do
        Dojo::KataValidator.stub!( :errors ).and_return( errors )
      end

      it "does not create a Kata instance" do
        lambda { post :create, attr }.
          should_not change( repo.kata.records, :size )
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

  describe "PUT 'update'" do

    let(:uri) { "http://youtube.com/watch?v=0xtPlviSkxs" }
    let(:attr) { base_attr.update( link: uri ) }

    context "with valid parameters" do

      before(:each) do
        @kata = repo.kata.save(repo.kata.new( attr ))
        @new_attr = attr.update({ id: @kata.id, title: "New Title" }) 
      end

      it "updates the Kata instance" do
        lambda { put :update, @new_attr }.
          should_not change( repo.kata.records, :size )
        last_record( repo.kata ).title.should == "New Title"
      end

      it "redirects to the kata show page upon success" do
        post :update, @new_attr
        response.should redirect_to(kata_path( last_record( repo.kata ).id ))
      end

    end

    context "with invalid parameters" do

      let(:errors) {{ title: "title error" }}

      before(:each) do
        @kata = repo.kata.save(repo.kata.new( attr ))
        @new_attr = attr.update({ id: @kata.id, title: "", 
                                  link: "", description: "" }) 
        Dojo::KataValidator.stub!( :errors ).and_return( errors )
      end

      it "does not update the Kata instance" do
        lambda { post :update, @new_attr }.
          should_not change( repo.kata.records, :size )
        last_record( repo.kata ).should == @kata
      end

      it "redirects to the new kata page for unknown host" do
        post :update, @new_attr
        response.should redirect_to( edit_kata_path( @kata.id ) )
      end

      it "sends a flash for form_values through the redirect" do
        post :update, @new_attr
        expected = Hash[@new_attr.map { |k,v| [k, v.to_s] }]
        flash[:form_values].should == expected
      end

      it "sends a flash for errors through the redirect" do
        post :update, @new_attr
        flash[:errors].should == errors
      end

    end

  end

  describe "GET 'index'" do

    before do
      repo.kata.destroy_all
      @user = repo.user.save( repo.user.new( {} ))
      session[:user_id] = @user.id
      repo.kata.save( repo.kata.new({ user: @user.id, title: "One" }))
      repo.kata.save( repo.kata.new({ user: @user.id, title: "Two" }))
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "renders the correct template" do
      get 'index'
      assert_template :index
    end

    it "assigns KataPresenters for the Katas" do
      get 'index'
      katas = assigns( :katas )
      katas.size.should == 2
      katas.first.should be_a( Dojo::KataPresenter )
      katas.map { |kata| kata.title }.should == [ "Two", "One" ]
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
