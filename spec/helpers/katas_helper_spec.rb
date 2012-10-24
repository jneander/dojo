require 'spec_helper'

describe KatasHelper do

  it ":scale_to_width maintains aspect ratio" do
    scale_to_width({ width: 1152, height: 720 }, 720).should ==
      { width: 720, height: 450 }
    scale_to_width({ width: 1920, height: 1080 }, 540).should ==
      { width: 540, height: 303 }
  end

end
