describe Jylis::DataType::MVREG do
  let(:mvreg)      { Jylis::DataType::MVREG.new(connection) }
  let(:connection) { OpenStruct.new }
  let(:key)        { "temperature" }
  let(:value)      { 72.1 }

  describe "interface" do
    specify { mvreg.should respond_to(:get) }
    specify { mvreg.should respond_to(:set) }
  end

  specify "get" do
    connection.should_receive(:query).with("MVREG", "GET", key) { value.to_s }

    mvreg.get(key).should eq value.to_s
  end

  specify "set" do
    connection.should_receive(:query).with("MVREG", "SET", key, value) {
      "OK"
    }

    mvreg.set(key, value)
  end

  specify "set failed" do
    connection.should_receive(:query).with("MVREG", "SET", key, value) {
      ""
    }

    expect { mvreg.set(key, value) }.to raise_error StandardError
  end
end
