require 'spec_helper'

describe "DocumentPages" do

  subject { page }

  describe "index" do
    before do
      FactoryGirl.create(:document, name: "Bill", location: "Here")
      FactoryGirl.create(:document, name: "Ben",  location: "There")
      visit documents_path
    end

    it { should have_title('Documents') }
    it { should have_content('All Documents') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:document) } }
      after(:all)  { Document.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each document" do
        Document.paginate(page: 1).each do |doc|
          expect(page).to have_selector('td', text: doc.name)
        end
      end
    end

    describe "tags" do
      before do
        doc=Document.first
        doc.tag_list="tag1"
        doc.save!
        visit tag_path('tag1')
      end

      it "should list tag_cloud" do
        expect(page).to have_link('tag1', href: tag_path('tag1'))
      end
      it "should list each tagged document" do
        Document.all.each do |doc|
          if doc.tag_list.include?('tag1')
            expect(page).to have_selector('td', text: doc.name)
          else
            expect(page).not_to have_selector('td', text: doc.name)
          end
        end
      end
    end

    describe "delete links" do

      it { should have_link('Delete', href: document_path(Document.first)) }
      it "should be able to delete a document" do
        expect do
          click_link('Delete', match: :first)
        end.to change(Document, :count).by(-1)
      end
    end

  end

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

  describe "document page" do
    let(:doc) { FactoryGirl.create(:document) }
    let!(:p1) { FactoryGirl.create(:page, document: doc, path: "Foo") }
    let!(:p2) { FactoryGirl.create(:page, document: doc, path: "Bar") }

    before { visit document_path(doc) }

    it { should have_content(doc.name) }
    it { should have_title(doc.name) }

    describe "pages" do
      it { should have_link('View fullsize', href: "/scans/#{p1.path}") }
      it { should have_link('View fullsize', href: "/scans/#{p2.path}") }
      it { should have_content(doc.pages.count) }
    end
  end

  describe "edit" do
    let(:doc) { FactoryGirl.create(:document) }
    before { visit edit_document_path(doc) }

    describe "page" do
      it { should have_content("Update your document") }
      it { should have_title("Edit document") }
    end

    describe "with invalid information" do
      before do
        FactoryGirl.create(:document,:name => "test1")
        fill_in "Name", with: "test1"
        click_button "Save changes"
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)     { "Document I changed" }
      let(:new_location) { "Bedroom" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Location",         with: new_location
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      specify { expect(doc.reload.name).to     eq new_name }
      specify { expect(doc.reload.location).to eq new_location }
    end

  end

end
