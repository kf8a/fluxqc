require 'spec_helper'

describe "templates/show" do
  before(:each) do
    @template = assign(:template, stub_model(Template,
      :name => "Name",
      :study => "Study",
      :plots => "MyText",
      :samples_per_plot => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag
    # if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Study/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
  end
end
