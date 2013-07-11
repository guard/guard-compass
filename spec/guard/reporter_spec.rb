require 'spec_helper'

describe Guard::Reporter do
  it { respond_to :failure }

  it { respond_to :success }

  it { respond_to :announce }

  it { respond_to :unstable }
end
