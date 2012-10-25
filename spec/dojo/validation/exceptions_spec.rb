require 'dojo/validation/exceptions'

describe Dojo::Validation::MediaNotFoundError do

  let(:error) { Dojo::Validation::MediaNotFoundError }

  it "is a subclass of IOError" do
    error.ancestors[1].should equal IOError
  end

end
