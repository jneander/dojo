require 'dojo/repository'

class KatasController < ApplicationController

  def show
    @kata = Dojo::Repository.kata.find(params[:id])
  end

  def new
    render :new
  end

  def create
    @kata = Dojo::Repository.kata.new(params)
    @kata = Dojo::Repository.kata.save(@kata)
    redirect_to :action => 'show', :id => @kata.id
  end

  def index
    @katas = Dojo::Repository.kata.records.values
    render :index
  end

end
