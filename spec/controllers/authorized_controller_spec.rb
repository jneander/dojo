require 'spec_helper'

describe AuthorizedController do

  controller( AuthorizedController ) do
    def index
      render text: "index success"
    end
  end

  let(:repo) { Dojo::Repository.user }
  let(:attr) {{ name: "John Doe", email: "example@8thlight.com",
                uid: "1234567890", provider: :google_oauth2 }}

  it "notifies non-users of limited access" do
    request.env['omniauth.auth'] = nil
    session[:user_id] = nil
    get :index
    assert_template 'auth/notify'
  end

  it "rejects unauthorized users" do
    with_oauth_response( attr.merge( email: "example@invalid.com" ))
    get :index
    assert_template 'auth/notify'
  end

  it "proceeds with authorized users" do
    with_oauth_response( attr )
    get :index
    response.body.should contain( "index success" )
  end

  it "proceeds with returning users" do
    user = repo.save( repo.new( {} ))
    session[:user_id] = user.id
    get :index
    response.body.should contain( "index success" )
  end

end
