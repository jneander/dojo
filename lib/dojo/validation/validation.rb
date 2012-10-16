require 'uri'

module Dojo
  module Validation
    class Validator

      def self.present?(value)
        value != "" && value != nil
      end

      def self.proper_uri?(address)
        supported_protocol(address)
      end

      def self.supported_host?(link, hosts)
        begin
          uri = URI::parse(link)
          hosts.any? {|host| uri.host =~ /#{host}/}
        rescue URI::InvalidURIError
          return false
        end
      end

      def self.supported_protocol(link)
        begin
          uri = URI::parse(link)
          ['http','https'].include?(uri.scheme)
        rescue URI::InvalidURIError
          return false
        end
      end

    end

    class Error
      attr_reader :value, :message

      def initialize(value, message)
        @value = value
        @message = message
      end

    end
  end
end
