require 'dojo/services/vimeo_service'
require 'dojo/validation/exceptions'
require 'URI'
require 'net/http'

describe Dojo::Media::VimeoService do

  let(:service) { Dojo::Media::VimeoService }
  let(:uri) { URI.parse( 'https://vimeo.com/50459431' ) }
  let(:body) { '<?xml version="1.0" encoding="UTF-8"?>\n
      <oembed>
        <title>Bowling Game Kata in Clojure</title>
        <height>720</height>
        <width>1152</width>
        <video_id>50459341</video_id>
      </oembed>\n' }
  
  before(:each) do
    ok_response = mock( Net::HTTPOK )
    ok_response.stub!( :body ).and_return( body )
    Net::HTTP.stub!( :get_response ).and_return( ok_response )
  end

  it ":oembed returns the Vimeo API call URI" do
    oembed = "http://vimeo.com/api/oembed.xml?url=https%3a//vimeo.com/50459431"
    actual = Dojo::Media::VimeoService.oembed( uri )
    actual.should be_instance_of( URI::HTTP )
    actual.to_s.should == oembed
  end

  it ":embed accepts a URI argument" do
    service.embed( uri )
  end

  it ":embed returns an instance of VimeoVideo" do
    service.embed( uri ).should be_instance_of( Dojo::Media::VimeoVideo )
  end

  it ":embed returns a VimeoVideo formed from the given URI" do
    video = service.embed( uri )
    video.title.should == "Bowling Game Kata in Clojure"
    video.width.should == 1152
    video.height.should == 720
    video.id.should == 50459341
  end

  it ":embed raises a MediaNotFoundError if the video does not exist" do
    uri = URI.parse( 'https://vimeo.com/50459431' )
    Net::HTTP.stub!( :get_response ).and_raise( ArgumentError )
    lambda { service.embed( uri ) }.
      should raise_error( Dojo::Validation::MediaNotFoundError )
  end

  it ":embed has default behavior when network is unavailable"

end

describe Dojo::Media::VimeoVideo do

  it "has accessor attributes" do
    video = Dojo::Media::VimeoVideo.new
    [:title, :height, :width, :id].each do |attr|
      video.should respond_to( attr )
      video.should respond_to( ( attr.to_s + "=" ).to_sym )
    end
  end

end
