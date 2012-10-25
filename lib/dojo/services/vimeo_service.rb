require 'net/http'
require 'xmlsimple'

module Dojo
  module Media

    class VimeoService

      def self.embed( uri )
        api_call = oembed( uri )

        begin
          data = XmlSimple.xml_in( Net::HTTP.get_response( api_call ).body )
        rescue ArgumentError
          raise Dojo::Validation::MediaNotFoundError
        end

        video = VimeoVideo.new
        video.title = data["title"].first
        video.height = data["height"].first.to_i
        video.width = data["width"].first.to_i
        video.id = data["video_id"].first.to_i

        return video
      end

      def self.oembed( uri )
        media_path = "https%3a//vimeo.com#{uri.path}"
        URI.parse( "http://vimeo.com/api/oembed.xml?url=#{media_path}" )
      end

    end

    class VimeoVideo
      attr_accessor :title, :height, :width, :id
    end

  end
end
