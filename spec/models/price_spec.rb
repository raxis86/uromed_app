require 'spec_helper'

describe Price do
  before do
  	@price = Price.new(name: "Консультации", cost: "", parentid: 0)
  end

  subject { @price }

  it { should respond_to(:name) }
  it { should respond_to(:cost) }
  it { should respond_to(:parentid) }

  describe "когда parentid не репрезентативен" do
  	before { @price.parentid = nil }
  	it { should_not be_valid }
  end
end
