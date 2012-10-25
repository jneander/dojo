module Dojo
  module Media

    class YouTubeService

      def self.embed( uri )
        api_call = gdata( uri )

        begin
          response = Net::HTTP.get_response( api_call )
          if response.instance_of?( Net::HTTPBadRequest )
            raise Dojo::Validation::MediaNotFoundError
          end
        rescue
          raise Dojo::Validation::MediaNotFoundError
        end
        
        video = YouTubeVideo.new
        video.id = api_call.to_s.split( "/" ).last

        return video
      end

      def self.gdata( uri )
        expression = /watch\?.*v=([0-9a-zA-Z_-]*)&?/
        video_id = expression.match( uri.to_s ).captures.first
        api_call = "http://gdata.youtube.com/feeds/api/videos/#{video_id}"
        URI.parse( api_call )
      end

    end

    class YouTubeVideo
      attr_accessor :height, :width, :id
    end

  end
end

