require "weapons/bow.rb"

describe Bow do
  let(:bow) { Bow.new }

  it "starts with 10 arrows by default" do
    expect(bow.instance_variable_get(:@arrows)).to eq(10)
  end

  it "starts with the specified number of arrows when created" do
    expect(Bow.new(20).instance_variable_get(:@arrows)).to eq(20)
  end

  it "reduces arrows by 1 when used" do
    bow.use
    expect(bow.instance_variable_get(:@arrows)).to eq(9)
  end

  it "throws an error if used with no arrows left" do
    empty_bow = Bow.new(0)
    expect{ empty_bow.use }.to raise_error("Out of arrows")
  end
end
