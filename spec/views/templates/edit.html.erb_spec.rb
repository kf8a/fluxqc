require 'spec_helper'

describe "templates/edit" do
  before(:each) do
    @template = assign(:template, stub_model(Template,
      :name => "MyString",
      :study => "MyString",
      :plots => "MyText",
      :samples_per_plot => 1
    ))
  end

  it "renders the edit template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => templates_path(@template), :method => "post" do
      assert_select "input#template_name", :name => "template[name]"
      assert_select "input#template_study", :name => "template[study]"
      assert_select "textarea#template_plots", :name => "template[plots]"
      assert_select "input#template_samples_per_plot", :name => "template[samples_per_plot]"
    end
  end
end
