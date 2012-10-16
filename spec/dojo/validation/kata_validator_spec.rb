require 'dojo/validation/kata_validator'

describe Dojo::KataValidator do

  let(:validator) { Dojo::KataValidator }
  let(:params) { { title:        "Valid Title",
                   link:         "https://vimeo.com/50459431",
                   description:  "Valid Description" } }

  it "#valid? rejects empty titles" do
    validator.valid?(params.update( title: "" )).should be_false
  end

  it "#valid? rejects nil titles" do
    validator.valid?(params.update( title: nil )).should be_false
  end

  it "#valid? accepts non-zero-length strings for titles" do
    validator.valid?(params).should be_true
  end

  it "#valid? rejects empty links" do
    validator.valid?(params.update( link: "" )).should be_false
  end

  it "#valid? rejects nil links" do
    validator.valid?(params.update( link: nil )).should be_false
  end

  it "#valid? rejects bad uris in links" do
    validator.valid?(params.update( link: "htt://www.vimeo.com/50459431" )).
      should be_false
  end

  it "#valid? accepts specific domains" do
    validator.valid?(params.update( link: "http://www.google.com" )).
      should be_false
    [ "http://www.vimeo.com", "http://www.youtube.com" ].each do |host|
      validator.valid?(params.update( link: host )).should be_true
    end
  end

  it "#valid? rejects empty descriptions" do
    validator.valid?(params.update( description: "" )).should be_false
  end

  it "#valid? rejects nil descriptions" do
    validator.valid?(params.update( description: nil )).should be_false
  end

  it "#valid? accepts non-zero-length strings for descriptions" do
    validator.valid?(params).should be_true
  end

  it "#errors returns an Error for blank title" do
    errors = validator.errors(params.update( title: "" ))
    errors[:title].should == "Title must not be blank"
  end

  it "#errors returns an Error for empty links" do
    errors = validator.errors(params.update( link: "" ))
    errors[:link].should == "Link must be valid"
  end

  it "#errors returns an Error for empty description" do
    errors = validator.errors(params.update( description: "" ))
    errors[:description].should == "Description must not be blank"
  end

  it "#errors returns one error per field" do
    errors = validator.errors( {} )
    errors.each {|k,e| e.should be_instance_of String}
    errors.count.should == 3
    errors.keys.sort.should == [:description, :link, :title]
  end

end
