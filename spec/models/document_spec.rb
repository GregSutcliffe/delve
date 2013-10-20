require 'spec_helper'

describe Document do

  before do
    @doc = Document.new(name: "document", location: "cabinet1") 
  end

  subject { @doc }

  it { should respond_to(:name) }
  it { should respond_to(:location) }
  it { should respond_to(:pages) }

  it { should be_valid }

  describe "when name is not present" do
    before { @doc.name = " " }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      user_with_same_name = @doc.dup
      user_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "pages associations" do

    before { @doc.save }
    let!(:older_page) do
      FactoryGirl.create(:page, document: @doc, created_at: 1.day.ago)
    end
    let!(:newer_page) do
      FactoryGirl.create(:page, document: @doc, created_at: 1.hour.ago)
    end
    let!(:unused_page) do
      FactoryGirl.create(:page, document: nil)
    end

    it "should have the right pages in the right order" do
      expect(@doc.pages.to_a).to eq [newer_page, older_page]
    end

    it "should be able to associate from an ID array" do
      @doc.form_pages=[unused_page.id]
      expect(@doc.pages.to_a).to eq [unused_page]
    end

    it "should destroy associated pages" do
      pages = @doc.pages.to_a
      @doc.destroy
      expect(pages).not_to be_empty
      pages.each do |page|
        expect(Page.where(id: page.id)).to be_empty
      end
    end
  end

end
