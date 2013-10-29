require 'spec_helper'

describe Page do

  let(:document) { FactoryGirl.create(:document) }
  before { @page = document.pages.build(path: "2013-09-12_00-00-00.jpg") }

  subject { @page }

  it { should respond_to(:path) }
  it { should respond_to(:document_id) }
  it { should respond_to(:document) }
  its(:document) { should eq document }
  it { should be_valid }

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
      File.write(File.join(STORAGE_DIR,'test'),'foo')
      File.exist?(File.join(STORAGE_DIR,'test')).should be_true

      @page.destroy.should be_true
      File.exist?(File.join(STORAGE_DIR,'test')).should be_false
    end

    it 'should return false if the file cannot be deleted' do
      File.should_receive(:join).and_return(Exception)
      @page.destroy.should be_false
    end

  end

  describe "jpg uploads" do
    before do
      Timecop.freeze(Time.local(2013))
    end

    after do
      Timecop.return
    end

    let(:file) { File.expand_path(File.dirname(__FILE__) + '../../fixtures/test.jpg') }

    it "should create page with jpg attributes" do
      FileUtils.stub(:cp) {true}
      page = Page.file_upload_jpeg('test.jpg',file)
      page.path.should eq('2013-01-01_00-00-00.000.jpg')
      page.errors.should be_empty
    end
  end

end
