require 'spec_helper'

describe "Scanner pages" do

  subject { page }

  describe "index" do
    before do
      2.times { FactoryGirl.create(:scanner) }
      visit scanners_path
    end

    it { should have_title('Scanners') }
    it { should have_content('All Scanners') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:scanner) } }
      after(:all)  { Scanner.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each scanner" do
        Scanner.paginate(page: 1).each do |scanner|
          expect(page).to have_selector('td', text: scanner.name)
        end
      end
    end

    describe "delete links" do

      it { should have_link('Delete', href: scanner_path(Scanner.first)) }
      it "should be able to delete a scanner" do
        expect do
          click_link('Delete', match: :first)
        end.to change(Scanner, :count).by(-1)
      end
    end

  end

  describe "new scanner" do
    before { visit new_scanner_path }
    let(:submit) { "Create Scanner" }

    it { should have_content('New Scanner') }
    it { should have_title(full_title('New Scanner')) }

    describe "with invalid information" do
      it "should not create a scanner" do
        expect { click_button submit }.not_to change(Scanner, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Test Scanner"
        fill_in "Device URL",   with: "net://test/location"
      end

      it "should create a scanner" do
        expect { click_button submit }.to change(Scanner, :count).by(1)
      end

      describe "after saving the scanner" do
        before { click_button submit }
        let(:scanner) { Scanner.find_by(name: 'Test Scanner') }

        it { should have_title(scanner.name) }
        it { should have_selector('div.alert.alert-success', text: 'Scanner created') }
      end
    end
  end

  describe "scanner page" do
    let(:scanner) { FactoryGirl.create(:scanner) }

    before { visit scanner_path(scanner) }

    it { should have_content(scanner.name) }
    it { should have_title(scanner.name) }

    it { should have_link('Acquire', href: acquire_scanner_path(scanner)) }

  end

end
