class KatasController < ApplicationController

  def show
    @title = "Show Kata"
    @kata = Kata.find(params[:id])
  end

  def new
    @title = "Create Kata"
    @kata = Kata.new
  end

  def create
    @kata = Kata.new(params[:kata])
    @kata.save
    redirect_to @kata
  end

end
