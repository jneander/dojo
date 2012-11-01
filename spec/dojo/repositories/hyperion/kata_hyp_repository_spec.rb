require 'spec_helper'
require 'dojo/repositories/hyperion/kata_hyp_repository'

describe Dojo::KataHypRepository do
  Hyperion.datastore = Hyperion.new_datastore( :memory )
  it_behaves_like "a Kata Repository"

end
