require File.expand_path("../../../app/uploaders/setup_file_loader.rb",__FILE__)

class Run 
end

class SetupParser
end

describe SetupFileLoader do

  it 'has a perform method with the run_id for resque to call' do
    Run.should_receive(:find).with('1').and_return(true)
    SetupFileLoader.perform('1').should be_true
  end

  it 'calls the setup parser' do
    SetupParser.should_receive(:parse).and_return(true)
    SetupFileLoader.perform('1').should be true
  end

end
