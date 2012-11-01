require 'dojo/models/user'

shared_examples "a User Repository" do

  let(:repo) { described_class.new }
  before(:each) { repo.destroy_all }

  it "#new returns a new User instance" do
    user = repo.new( name: "James Foo" )
    user.should be_an_instance_of( Dojo::User )
    user.name.should == "James Foo"
  end

  it "#save stores a User into the repository" do
    user = repo.save( repo.new( name: "James Foo" ))
    repo.find( user.id ).should eql user
  end

  it "#save assigns an id if none exists" do
    user_1 = repo.save( repo.new( name: "James Foo" ))
    user_2 = repo.save( repo.new( name: "Jane Bar" ))
    user_1.id.should_not be_nil
    user_2.id.should_not == user_1.id
  end

  it "#save preserves any existing id" do
    user = repo.new( name: "James Foo" )
    user.id = '500'
    user = repo.save( user )
    user.id.should == '500'
  end

  it "#save ensures any existing id is a String" do
    user = repo.new( name: "James Foo" )
    user.id = 500
    user = repo.save( user )
    user.id.should == '500'
  end

  it "#save stores all provided attributes" do
    attr = { name: "John Doe", email: "example@8thlight.com",
             uid: '1234567890', provider: :google_oauth2 }
    user = repo.save( repo.new( attr ))
    user = repo.find( user.id )
    user.name.should      == attr[ :name ]
    user.email.should     == attr[ :email ]
    user.uid.should       == attr[ :uid ]
    user.provider.should  == attr[ :provider ]
  end

  it "#find returns the User with requested id" do
    user = repo.save( repo.new( name: "James Foo" ))
    repo.find( user.id ).should eql user
  end

  it "#find_by_uid returns the User with requested uid" do
    user_1 = repo.save( repo.new({ uid: '123', provider: :google }))
    user_2 = repo.save( repo.new({ uid: '124', provider: :google }))
    user_3 = repo.save( repo.new({ uid: '123', provider: :twitter }))
    repo.find_by_uid( '123', :google ).should == [ user_1 ]
    repo.find_by_uid( '555', :google ).should == []
  end

  it "#records returns all Users in the repository" do
    user_1 = repo.save( repo.new( name: "James Foo" ))
    user_2 = repo.save( repo.new( name: "Jane Bar" ))
    Hash[ repo.records.map { |k,v| [k, v.name] } ].should == 
      { user_1.id => "James Foo", user_2.id => "Jane Bar" }
  end

  it "#destroy_all deletes all User records" do
    user_1 = repo.save( repo.new )
    user_2 = repo.save( repo.new )
    repo.destroy_all
    repo.records.should == {}
    repo.find( user_1.id ).should be_nil
    repo.find( user_2.id ).should be_nil
  end

end
