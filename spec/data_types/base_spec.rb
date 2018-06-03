describe Jylis::DataType::Base do
  let(:base_instance) { Class.new(Jylis::DataType::Base) }

  it "can't be instantiated directly (must be inherited)" do
    connection = OpenStruct.new

    expect { Jylis::DataType::Base.new(connection) }.to raise_error StandardError
  end

  it "can't have a nil connection" do
    expect { base_instance.new(nil) }.to raise_error ArgumentError
  end

  it "exposes a connection to use for queries" do
    connection = OpenStruct.new

    base_instance.new(connection)
      .connection.should eq connection
  end
end
