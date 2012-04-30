require 'spec_helper'

describe "templates/new" do
  before(:each) do
    assign(:template, stub_model(Template,
      :name => "MyString",
      :study => "MyString",
      :plots => "MyText",
      :samples_per_plot => 1
    ).as_new_record)
  end

  it "renders new template form" do
    render

    # Run the generator again with the --webrat flag
    # if you want to use webrat matchers
    assert_select "form", :action => templates_path, :method => "post" do
      assert_select "input#template_name", :name => "template[name]"
      assert_select "input#template_study", :name => "template[study]"
      assert_select "textarea#template_plots", :name => "template[plots]"
      assert_select "input#template_samples_per_plot", :name => "template[samples_per_plot]"
    end
  end
end
