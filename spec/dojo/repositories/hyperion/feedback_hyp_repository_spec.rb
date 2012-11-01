require 'spec_helper'
require 'dojo/repositories/hyperion/feedback_hyp_repository'

describe Dojo::FeedbackHypRepository do
  Hyperion.datastore = Hyperion.new_datastore( :memory )
  it_behaves_like "a Feedback Repository"

end
