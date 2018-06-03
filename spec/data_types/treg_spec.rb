describe Jylis::DataType::TREG do
  let(:treg)       { Jylis::DataType::TREG.new(connection) }
  let(:connection) { OpenStruct.new }
  let(:key)        { "temperature" }
  let(:value)      { 72.1 }
  let(:timestamp)  { 100 }

  describe "interface" do
    specify { treg.should respond_to(:get) }
    specify { treg.should respond_to(:set) }
  end

  specify "get" do
    connection.should_receive(:query).with("TREG", "GET", key) { [value, timestamp] }

    result = treg.get(key)

    result.should be_a Jylis::DataType::TREG::Result
    result.value.should eq value
    result.timestamp.should eq timestamp
  end

  specify "set" do
    connection.should_receive(:query).with("TREG", "SET", key, value, timestamp) {
      "OK"
    }

    treg.set(key, value, timestamp)
  end

  specify "set failed" do
    connection.should_receive(:query).with("TREG", "SET", key, value, timestamp) {
      ""
    }

    expect { treg.set(key, value, timestamp) }.to raise_error StandardError
  end
end
