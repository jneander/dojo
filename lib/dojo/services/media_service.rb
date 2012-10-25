require 'dojo/services/vimeo_service'
require 'dojo/services/youtube_service'
require 'dojo/validation/exceptions'

module Dojo
  class MediaService

    def self.embed( uri )
      begin
        case uri.host
        when /vimeo/
          Dojo::Media::VimeoService.embed( uri )
        when /youtube/
          Dojo::Media::YouTubeService.embed( uri )
        end
      rescue Dojo::Validation::MediaNotFoundError
        return nil
      end
    end

  end
end
