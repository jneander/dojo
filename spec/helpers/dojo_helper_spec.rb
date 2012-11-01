require 'spec_helper'

describe DojoHelper do

  before do
    @repo = Dojo::Repository.user
    @repo.destroy_all
    @user = @repo.save( @repo.new( name: "John Doe" ))
  end

  it ":current_user returns the current user if signed in" do
    session[:user_id] = @user.id
    current_user.should == @user
  end

  it ":current_user returns nil if not signed in" do
    session[:user_id] = nil
    current_user.should == nil
  end

end
