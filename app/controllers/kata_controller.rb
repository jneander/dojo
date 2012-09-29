class KataController < ApplicationController
  def show
    @title = "Show Kata"
    @kata = Kata.find(params[:id])
  end
end
