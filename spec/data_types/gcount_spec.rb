describe Jylis::DataType::GCOUNT do
  let(:gcount)     { Jylis::DataType::GCOUNT.new(connection) }
  let(:connection) { OpenStruct.new }
  let(:key)        { "mileage" }
  let(:value)      { 50 }

  describe "interface" do
    specify { gcount.should respond_to(:get) }
    specify { gcount.should respond_to(:inc) }
  end

  specify "get" do
    connection.should_receive(:query).with("GCOUNT", "GET", key).exactly(:once) {
      value
    }

    gcount.get(key).should eq value
  end

  specify "inc" do
    connection.should_receive(:query).with("GCOUNT", "INC", key, value)
      .exactly(:once) { "OK" }

    gcount.inc(key, value)
  end

  specify "inc failed" do
    connection.should_receive(:query).with("GCOUNT", "INC", key, value)
      .exactly(:once) { "" }

    expect { gcount.inc(key, value) }.to raise_error StandardError
  end
end
