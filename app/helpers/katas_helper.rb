module KatasHelper
    
    def timestamp(timestamp)
      timestamp.strftime('%B %-d, %Y at %l:%M%P')
    end

    def feedback_header(count)
      if (count < 5)
        "This kata needs feedback. Share your input!"
      else
        "Learn what makes a great kata. Share in feedback!"
      end
    end

end
