require 'spec_helper'
require 'dojo/repositories/hyperion/user_hyp_repository'

describe Dojo::UserHypRepository do
  Hyperion.datastore = Hyperion.new_datastore( :memory )
  it_behaves_like "a User Repository"

end
