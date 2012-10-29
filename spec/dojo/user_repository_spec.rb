require 'dojo/user_repository'

describe Dojo::UserRepository.new do

  let(:repo) { Dojo::UserRepository.new }
  before(:each) { repo.destroy_all }

  it "#new returns a new User" do
    user = repo.new( name: "James Foo")
    user.should_not be_nil
    user.name.should == "James Foo"
  end

  it "#save stores a User in the repository" do
    user = repo.save( repo.new( name: "James Foo" ))
    repo.records[ user.id ].name.should == "James Foo"
  end

  it "#save assigns an id if none exists" do
    user_1 = repo.save( repo.new( name: "James Foo" ))
    user_2 = repo.save( repo.new( name: "Jane Bar" ))
    user_1.id.should == 1
    user_2.id.should == 2
  end

  it "#save preserves any existing id" do
    user = repo.new( name: "James Foo" )
    user.id = 500
    user = repo.save( user )
    user.id.should == 500
  end

  it "#find returns the User with requested id" do
    user = repo.save( repo.new( name: "James Foo" ))
    repo.find( user.id ).name.should == "James Foo"
  end

  it "#find_by_uid returns the User with requested uid" do
    user_1 = repo.save( repo.new({ uid: '123', provider: :google }))
    user_2 = repo.save( repo.new({ uid: '124', provider: :google }))
    user_3 = repo.save( repo.new({ uid: '123', provider: :twitter }))
    repo.find_by_uid( '123', :google ).should == [ user_1 ]
    repo.find_by_uid( '555', :google ).should == []
  end

  it "#records returns all Users in the repository" do
    repo.save( repo.new( name: "James Foo" ))
    repo.save( repo.new( name: "Jane Bar" ))
    Hash[ repo.records.map { |k,v| [k, v.name] } ].should == 
      { 1 => "James Foo", 2 => "Jane Bar" }
  end

  it "#destroy_all clears all records" do
    repo.save( repo.new( name: "James Foo" ))
    repo.destroy_all
    repo.records.should == {}
  end

end
