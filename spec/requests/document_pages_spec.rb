require 'spec_helper'

describe "DocumentPages" do

  subject { page }

  describe "new document" do
    before { visit new_document_path }
    let(:submit) { "Create Document" }

    describe "with invalid information" do
      it "should not create a document" do
        expect { click_button submit }.not_to change(Document, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Test Document"
        fill_in "Location",     with: "In My Hand"
      end

      it "should create a document" do
        expect { click_button submit }.to change(Document, :count).by(1)
      end

      describe "after saving the document" do
        before { click_button submit }
        let(:document) { Document.find_by(name: 'Test Document') }

        it { should have_title(document.name) }
        it { should have_selector('div.alert.alert-success', text: 'Document created') }
      end
    end
  end

  describe "profile page" do
    let(:doc) { FactoryGirl.create(:document) }
    before { visit document_path(doc) }

    it { should have_content(doc.name) }
    it { should have_title(doc.name) }
  end

end
