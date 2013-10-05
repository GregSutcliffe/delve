require 'spec_helper'

describe "Scanner pages" do

  subject { page }

  describe "new scanner" do
    before { visit new_scanner_path }

    it { should have_content('New Scanner') }
    it { should have_title(full_title('New Scanner')) }
  end


  #describe "GET /scanner_pages" do
  #  it "works! (now write some real specs)" do
  #    # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #    get scanner_pages_index_path
  #    response.status.should be(200)
  #  end
  #end
end
