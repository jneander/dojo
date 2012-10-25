require 'dojo/repository'
require 'dojo/validation/kata_validator'
require 'dojo/services/media_service'
require 'dojo/services/vimeo_service'
require 'uri'

class KatasController < ApplicationController

  def show
    @kata = repo.kata.find( params[:id] )
    @feedback = repo.feedback.find_by_kata_id( params[:id] )
    uri = URI.parse( @kata.link )
    @video = Dojo::MediaService.embed( uri )
    @partial = embed_partial_for( @video )
  end

  def new
    @form_values = flash[:form_values] || {}
    @errors = flash[:errors] || {}
    render :new
  end

  def create
    if Dojo::KataValidator.valid?( params )
      @kata = repo.kata.save(repo.kata.new( params ))
      redirect_to kata_path( @kata.id )
    else
      fields = Dojo::Kata.attributes
      flash[:form_values] = symbolize_keys( params ).
        select { |k,v| fields.include? k }
      flash[:errors] = Dojo::KataValidator.errors( params )
      redirect_to new_kata_path
    end
  end

  def index
    @katas = repo.kata.sort
    render :index
  end

  private

  def repo
    Dojo::Repository
  end

  def embed_partial_for( video )
    case video
    when Dojo::Media::VimeoVideo
      'vimeo'
    when Dojo::Media::YouTubeVideo
      'youtube'
    else
      'broken_embed'
    end
  end

end
