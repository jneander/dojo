require 'dojo/repository'

class KatasController < ApplicationController

  def show
    @kata = Dojo::Repository.kata.find(params[:id])
    @feedback = Dojo::Repository.feedback.find_by_kata_id(params[:id])
  end

  def new
    render :new
  end

  def create
    @kata = Dojo::Repository.kata.new(params)
    @kata = Dojo::Repository.kata.save(@kata)
    redirect_to kata_path(@kata.id)
  end

  def index
    @katas = Dojo::Repository.kata.sort
    render :index
  end

end
