require 'spec_helper'

describe CampaignPlot do
  it {should belong_to :plot}
  it {should belong_to :campaign}
end
