require 'dojo/services/youtube_service'
require 'dojo/validation/exceptions'
require 'net/http'
require 'uri'

describe Dojo::Media::YouTubeService do

  let(:service) { Dojo::Media::YouTubeService }
  let(:uri) { URI.parse( 'http://www.youtube.com/watch?v=0xtPlviSkxs' ) }

  before(:each) { Net::HTTP.stub!( :get_response ).and_return( "" ) }

  it ":gdata returns the YouTube API call URI" do
    gdata = "http://gdata.youtube.com/feeds/api/videos/0xtPlviSkxs"
    actual = service.gdata( uri )
    actual.should be_instance_of( URI::HTTP )
    actual.to_s.should == gdata
  end

  it ":gdata can parse a variety of url configurations" do
    expected = "http://gdata.youtube.com/feeds/api/videos/0xt-Plvi_Sk"
    [ "http://youtube.com/watch?v=0xt-Plvi_Sk",
      "http://www.youtube.com/watch?feature=player_embedded&v=0xt-Plvi_Sk",
      "http://www.youtube.com/watch?v=0xt-Plvi_Sk&feature=example"
    ].each do |uri|
      service.gdata( uri ).to_s.should == expected
    end
  end

  it ":embed returns an instance of YouTubeVideo" do
    service.embed( uri ).should be_instance_of( Dojo::Media::YouTubeVideo )
  end

  it ":embed returns a YouTubeVideo formed from the given URI" do
    video = service.embed( uri )
    video.id.should == "0xtPlviSkxs"
  end

  it ":embed raises a MediaNotFoundError if the video does not exist" do
    uri = "http://www.youtube.com/watch?v=111"
    Net::HTTP.stub!( :get_response ).and_raise( StandardError )
    lambda { service.embed( uri ) }.
      should raise_error( Dojo::Validation::MediaNotFoundError )

    response = Net::HTTPBadRequest.new( nil, nil, nil )
    Net::HTTP.stub!( :get_response ).and_return( response )
    lambda { service.embed( uri) }.
      should raise_error( Dojo::Validation::MediaNotFoundError )
  end

end

describe Dojo::Media::YouTubeVideo do

  it "has accessor attributes" do
    video = Dojo::Media::YouTubeVideo.new
    video.should respond_to( :id )
    video.should respond_to( :id= )
  end

end
