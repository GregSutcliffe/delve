require 'test_helper'
require 'RMagick'

class ScannerTest < ActiveSupport::TestCase

  test "should not save without a name" do
    scanner = Scanner.new
    assert !scanner.save, "Saved scanner without a name"
  end

  test "should have a unique name" do
    Scanner.create :name => "name", :device_url => "net://test1"
    scanner = Scanner.new :name => "name", :device_url => "net://test2"
    assert !scanner.save, "Saved scanner with duplicate name"
  end

  test "should not save scanner without a device_url" do
    scanner = Scanner.new :name => "name"
    assert !scanner.save, "Saved scanner without a device_url"
  end

  test "should have a unique device_url" do
    Scanner.create :name => "name1", :device_url => "net://test"
    scanner = Scanner.new :name => "name2", :device_url => "net://test"
    assert !scanner.save, "Saved scanner with duplicate device_url"
  end

  test "should store acquired images from a scanner" do
    scanner = Scanner.create :name => "name1", :device_url => "net://test"
    scanner.expects(:`).with("scanimage -d #{scanner.device_url}").returns(`echo data`).once
    test_image=Magick::Image.new(256,256)
    test_image.stubs(:properties).returns({'date:create'=>Time.new('2013','09','12')})
    Magick::Image.expects(:from_blob).with("data\n").returns(stub(:first => test_image)).once
    page = scanner.acquire
    assert page.valid?, "Invalid page from scanner#acquire"
    assert_equal page.label, '2013-09-12_00-00-00', "Incorrect label on acquired page"
    assert_equal page.path, '2013-09-12_00-00-00.jpg', "Incorrect path on acquired page"
  end

end
