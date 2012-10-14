module KatasHelper
    
    def timestamp(timestamp)
      timestamp.strftime('%B %-d, %Y at %l:%M%P')
    end

    def feedback_header(count)
      if (count < 5)
        "This kata needs your feedback. Share your thoughts!"
      else
        "Learn what makes a great kata. Share with feedback!"
      end
    end

end
