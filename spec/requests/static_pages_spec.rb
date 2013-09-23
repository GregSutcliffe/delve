require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Delve" }
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Welcome to Delve') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('How to get help') }
    it { should have_title(full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About Me') }
    it { should have_title(full_title('About Me')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end

end
