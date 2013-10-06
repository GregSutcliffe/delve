require 'spec_helper'

describe 'Static pages' do

  subject { page }

  shared_examples_for 'all static pages' do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Welcome to Delve' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    it 'should direct scan-now to new scanner when no scanners exist' do
      Scanner.all.each { |s| s.destroy }
      click_link 'Scan something now!'
      expect(page).to have_title(full_title('New Scanner'))
    end
    it 'should direct scan-now to aquire on first scanner' do
      Scanner.create(name: "Example Scanner", device_url: "net://host/path")
      click_link 'Scan something now!'
      expect(page).to have_content('Example Scanner')
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'How to get help' }
    let(:page_title) { 'Help' }

    it_should_behave_like 'all static pages'
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About Me' }
    let(:page_title) { 'About Me' }

    it_should_behave_like 'all static pages'
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like 'all static pages'
  end

  describe 'Layout links'
  it 'should have the right static links' do
    visit root_path
    click_link 'About'
    expect(page).to have_title(full_title('About Me'))
    click_link 'Help'
    expect(page).to have_title(full_title('Help'))
    click_link 'Contact'
    expect(page).to have_title(full_title('Contact'))
    click_link 'Scanners'
    expect(page).to have_title(full_title('Scanners'))
    click_link 'Pages'
    expect(page).to have_title(full_title('Pages'))
    click_link 'Delve'
    expect(page).to have_title(full_title(''))
  end

end
