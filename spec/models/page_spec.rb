require 'spec_helper'

describe Page do
  before { @page = Page.new(label: "2013-09-12_00-00-00", path: "2013-09-12_00-00-00.jpg") }

  subject { @page }

  it { should respond_to(:label) }
  it { should respond_to(:path) }
  it { should be_valid }

  describe "when label is not present" do
    before { @page.label = " " }
    it { should_not be_valid }
  end

  describe "when path is not present" do
    before { @page.path = " " }
    it { should_not be_valid }
  end

  describe "when path is already taken" do
    before do
      page_with_same_path = @page.dup
      page_with_same_path.save
    end
    it { should_not be_valid }
  end

  # TODO: Refactor this with settings
  describe "when destroyed" do
    before { @page.path = 'test' }
    it 'should delete the associated file' do
      STORAGE_DIR = ::Rails.root.join('public','scans')

      File.write(File.join(STORAGE_DIR,'test'),'')
      File.exist?(File.join(STORAGE_DIR,'test')).should be_true

      @page.destroy.should be_true
      File.exist?(File.join(STORAGE_DIR,'test')).should be_false
    end
  end

end
