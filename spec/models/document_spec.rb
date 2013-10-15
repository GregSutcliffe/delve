require 'spec_helper'

describe Document do

  before do
    @doc = Document.new(name: "document", location: "cabinet1") 
  end

  subject { @doc }

  it { should respond_to(:name) }
  it { should respond_to(:location) }

  it { should be_valid }

  describe "when name is not present" do
    before { @doc.name = " " }
    it { should_not be_valid }
  end

  describe "when location is not present" do
    before { @doc.location = " " }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      user_with_same_name = @doc.dup
      user_with_same_name.save
    end

    it { should_not be_valid }
  end

end
