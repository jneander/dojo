require 'dojo/services/media_service'
require 'dojo/services/vimeo_service'

describe Dojo::MediaService do

  let(:service) { Dojo::MediaService }

  context "using Vimeo" do

    let(:result) { Dojo::Media::VimeoVideo.new }

    it ":embed returns the result of VimeoService.embed" do
      uri = URI.parse( "https://www.vimeo.com/7100569" )
      Dojo::Media::VimeoService.should_receive( :embed ).with( uri ).
        and_return( result )
      output = service.embed( uri )
      output.should equal result
    end

    it ":embed returns nil when the media is not found" do
      Dojo::Media::VimeoService.should_receive( :embed ).
        and_raise( ArgumentError )
      output = service.embed( URI.parse( 'http://vimeo.com/111111' ))
      output.should be_nil
    end

  end

  context "using Unknown" do

    it ":embed returns nil for unknown URI hosts" do
      result = service.embed(URI.parse('http://google.com/'))
      result.should be_nil
    end

  end

end
