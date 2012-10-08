module KatasHelper
  class Formatter
    
    def self.timestamp(timestamp)
      timestamp.strftime('%B %-d, %Y at %l:%M%P')
    end

  end
end
