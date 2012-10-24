require 'dojo/services/vimeo_service'

module Dojo
  class MediaService

    def self.embed(uri)
      begin
        case uri.host
        when /vimeo/
          Dojo::Media::VimeoService.embed(uri)
        end
      rescue ArgumentError
        return nil
      end
    end

  end
end
