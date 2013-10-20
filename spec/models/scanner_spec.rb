require 'spec_helper'

describe Scanner do
  before { @scanner = Scanner.new(name: "Example Scanner", device_url: "net://host/path") }

  subject { @scanner }

  it { should respond_to(:name) }
  it { should respond_to(:device_url) }
  it { should be_valid }

  describe "when name is not present" do
    before { @scanner.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @scanner.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when device_url is not present" do
    before { @scanner.device_url = " " }
    it { should_not be_valid }
  end

  describe "when device_url is already taken" do
    before do
      scanner_with_same_url = @scanner.dup
      scanner_with_same_url.save
    end
    it { should_not be_valid }
  end

  describe "acquiring images" do
    it "stores the image correctly" do
      test_image = Magick::Image.new(256,256)
      test_image.stub(:properties) {{'date:create'=>Time.new('2013','09','12')}}

      Magick::Image.should_receive(:from_blob).once.with("data\n").and_return(stub(:first => test_image))
      @scanner.should_receive(:`).once.with("scanimage -d #{@scanner.device_url}").and_return(`echo data`)

      page = @scanner.acquire
      expect(page).to be_valid
      expect(page.path).to eq('2013-09-12_00-00-00.jpg')
    end
    
    it "returns false for acquire when get_image cannot be acquired" do
      @scanner.should_receive(:`).once.with("scanimage -d #{@scanner.device_url}").and_return(Exception)
      page = @scanner.acquire
      expect(page).to be_false
    end
  end

end
