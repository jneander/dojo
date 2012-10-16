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

    def form_field_value(id, values)
      values[id] if (values && values[id])
    end

    def form_error_highlights(id, errors, options={})
      options[:class] = 'error_highlight' if (errors && errors[id])
      options
    end

    def form_error_message(id, errors)
      if has_errors(id, errors)
        content_tag(:span, errors[id], :class => "error_message")
      end
    end

    def has_errors(id, errors)
      errors && errors[id]
    end

    def f_error_message(message)
      if message
        content_tag(:span, message, :class => "error_message")
      end
    end

end
