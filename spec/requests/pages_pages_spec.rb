require 'spec_helper'

describe "PagesPages" do

  subject { page }

  describe "upload" do

    before do
      visit upload_path
    end

    it { should have_title('Upload File') }
    it { should have_content('Upload a Page') }
    it "should have upload button" do
      expect(page).to have_selector("input[type=submit][value='Upload']")
    end

    describe "with no upload selected" do
      before { click_button "Upload" }

      it { should have_title('Upload File') }
      it { should have_selector('div.alert.alert-error', text: 'No file selected') }
    end

    describe "with a jpg selected" do
      let(:file) { { :file => fixture_file_upload('/test.jpg', 'image/jpeg') } }

      it "a good file should upload" do
        page = FactoryGirl.create :page, :unassociated
        Page.should_receive(:file_upload_jpeg).once.and_return(page)
        post upload_path, :file_upload => file
        response.should render_template("upload")
        flash[:error].should be_nil
        flash[:success].should eq('File uploaded!')
        response.status.should eq(302)
      end

    end

    describe "with an unsupported format" do
      let(:file) { { :file => fixture_file_upload('/test.png', 'image/png') } }

      it "an error should be raised" do
        post upload_path, :file_upload => file
        response.should render_template("upload")
        flash[:success].should be_nil
        flash[:error].should eq("Error!\nFormat PNG is not implemented yet")
        response.status.should eq(302)
      end

    end

  end

end
