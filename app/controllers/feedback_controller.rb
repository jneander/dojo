require 'dojo/repository'

class FeedbackController < ApplicationController

  def create
    @feedback = Dojo::Repository.feedback.new(params)
    @feedback = Dojo::Repository.feedback.save(@feedback)
    redirect_to kata_path(@feedback.kata_id)
  end

end
