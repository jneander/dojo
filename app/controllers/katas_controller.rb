require 'dojo/repositories/repository'
require 'dojo/presenters/kata_presenter'
require 'dojo/validation/kata_validator'
require 'dojo/services/media_service'
require 'dojo/services/vimeo_service'
require 'uri'

class KatasController < AuthorizedController

  def show
    kata = repo.kata.find( params[:id] )
    @kata = Dojo::KataPresenter.new( kata )
    feedback = repo.feedback.find_by_kata_id( params[:id] )
    @feedback = feedback.map { |fb| Dojo::FeedbackPresenter.new( fb ) }
    uri = URI.parse( @kata.link )
    @editable = ( kata.user == session[:user_id] )
    @video = Dojo::MediaService.embed( uri )
    @partial = embed_partial_for( @video )
    @form_values = flash[:form_values] || {}
    @errors = flash[:errors] || {}
  end

  def new
    @form_values = flash[:form_values] || {}
    @errors = flash[:errors] || {}
    render :new
  end

  def edit
    kata = repo.kata.find( params[:id] )
    kata_values = { id:          kata.id,
                    title:       kata.title,
                    link:        kata.link,
                    description: kata.description }
    @form_values = flash[:form_values] || kata_values
    @errors = flash[:errors] || {}
    render :edit
  end

  def create
    if Dojo::KataValidator.valid?( params )
      params.update( user: session[:user_id] )
      kata = repo.kata.save(repo.kata.new( params ))
      redirect_to kata_path( kata.id )
    else
      fields = Dojo::Kata.attributes
      flash[:form_values] = symbolize_keys( params ).
        select { |k,v| fields.include? k }
      flash[:errors] = Dojo::KataValidator.errors( params )
      redirect_to new_kata_path
    end
  end

  def update
    if Dojo::KataValidator.valid?( params )
      kata = repo.kata.new( params )
      kata.id = params[:id]
      kata = repo.kata.save( kata )
      redirect_to kata_path( kata.id )
    else
      fields = Dojo::Kata.attributes
      flash[:form_values] = symbolize_keys( params ).
        select { |k,v| fields.include? k }
      flash[:errors] = Dojo::KataValidator.errors( params )
      redirect_to edit_kata_path( params[:id] )
    end
  end

  def index
    katas = repo.kata.sort
    @katas = katas.map { |kata| Dojo::KataPresenter.new( kata ) }
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
