require 'dojo/models/feedback'
require 'dojo/repository'
require 'dojo/validation/feedback_validator'

class FeedbackController < ApplicationController

  def create
    kata_id = params[:kata_id]

    if Dojo::FeedbackValidator.valid?( params )
      create_feedback( params )
    else
      fields = Dojo::Feedback.attributes
      flash[:form_values] = symbolize_keys( params ).
        select { |k,v| fields.include? k }
      flash[:errors] = Dojo::FeedbackValidator.errors( params )
    end

    redirect_to kata_path( kata_id )
  end

  private

  def create_feedback( params )
    repo = Dojo::Repository.feedback
    repo.save( repo.new( params ))
  end

end
