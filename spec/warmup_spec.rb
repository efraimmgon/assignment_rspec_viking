require "warmup"

describe Warmup do
  let(:w) { Warmup.new }

  describe "#gets_shout" do
    before { allow(w).to receive(:gets).and_return("hello") }

    it "outputs and returns the input upcased" do
      result = w.gets_shout
      expect(result).to eq("HELLO")
    end

    it "calls puts" do
      expect(w).to receive(:puts)
      w.gets_shout
    end
  end

  describe "#triple_size" do
    it "should triple the size" do
      expect(w.triple_size([1,2,3])).to eq(9)
    end
  end

  describe "#calls_some_methods" do
    let(:string) { "hello" }

    it "upcases the input" do
      allow(string).to receive(:upcase!).and_return(string.upcase!)
      allow(string).to receive(:reverse!).and_return(string.reverse)
      expect(string).to receive(:upcase!)
      expect(string).to eq("HELLO")
      w.calls_some_methods(string)
    end

    it "reverses the input" do
      allow(string).to receive(:upcase!).and_return(string.upcase!)
      allow(string).to receive(:reverse!).and_return(string.reverse!)
      expect(string).to receive(:reverse!)
      expect(string).to eq("HELLO".reverse)
      w.calls_some_methods(string)
    end

    it "returns a completely different object than the one passed in" do
      expect(w.calls_some_methods(string)).not_to eq("hello".upcase.reverse)
    end
  end

end
