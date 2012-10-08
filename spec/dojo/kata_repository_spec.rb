require 'dojo/kata_repository'

describe Dojo::KataRepository do

  let(:repo) { Dojo::KataRepository.new }
  before(:each) { repo.destroy_all }

  it "#new returns a new kata" do
    kata = repo.new(:title => "Example")
    kata.should_not be_nil
    kata.title.should == "Example"
  end

  it "#save stores a kata in the repository" do
    kata = repo.save(repo.new(:title => "Example"))
    repo.records[kata.id].title.should == kata.title
  end

  it "#save assigns an id if none exists" do
    kata_1 = repo.save(repo.new(:title => "Example"))
    kata_2 = repo.save(repo.new(:title => "Example"))
    kata_1.id.should == 1
    kata_2.id.should == 2
  end

  it "#save preserves existing id" do
    kata = repo.new(:title => "Example")
    kata.id = 500
    kata = repo.save(kata)
    kata.id.should == 500
  end

  it "#save stores the time of last update" do
    create_time = DateTime.now
    DateTime.stub!(:now).and_return(create_time)
    kata = repo.save(repo.new(:title => "Example"))
    kata.last_updated.should == create_time
  end

  it "#find returns the kata with requested id" do
    kata = repo.save(repo.new(:title => "Example"))
    repo.find(kata.id).title.should == "Example"
  end

  it "#records returns all katas in the repository" do
    repo.save(repo.new(:title => "Example"))
    repo.save(repo.new(:title => "Example 2"))
    Hash[repo.records.map {|k,v| [k, v.title]}].should == 
      {1 => "Example", 2 => "Example 2"}
  end

  it "#destroy_all clears all records" do
    repo.save(repo.new(:title => "Example"))
    repo.destroy_all
    repo.records.should == {}
  end

  it "#sort sorts by last_updated" do
    date_stub = DateTime.now
    DateTime.stub!(:now).and_return(date_stub - 3)
    kata_1 = repo.save(repo.new)
    DateTime.stub!(:now).and_return(date_stub - 5)
    kata_2 = repo.save(repo.new)
    DateTime.stub!(:now).and_return(date_stub)
    kata_3 = repo.save(repo.new)
    repo.sort.should == [kata_3, kata_1, kata_2]
  end

end
