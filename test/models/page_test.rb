require 'test_helper'

class PageTest < ActiveSupport::TestCase

  test "should not save without a label" do
    page = Page.new
    refute page.save, "Saved page without a label"
  end

  test "should not save without a path" do
    page = Page.new :label => "label"
    refute page.save, "Saved page without a path"
  end

  test "should have a unique path" do
    Page.create :label => "label1", :path => "path1"
    page = Page.new :label => "label2", :path => "path1"
    refute page.save, "Saved page with duplicate path"
  end

  # TODO: Refactor this with settings
  STORAGE_DIR = ::Rails.root.join('public','scans')
  test "should delete associated file when destroyed" do
    File.write(File.join(STORAGE_DIR,'test'),'')
    assert File.exist?(File.join(STORAGE_DIR,'test')), "File not created"
    page = Page.create :label => "label", :path => 'test'
    assert page.destroy
    refute File.exist?(File.join(STORAGE_DIR,'test')), "File not destroyed"
  end

end
