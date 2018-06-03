describe Jylis::DataType::PNCOUNT do
  let(:pncount)    { Jylis::DataType::PNCOUNT.new(connection) }
  let(:connection) { OpenStruct.new }
  let(:key)        { "mileage" }
  let(:value)      { 50 }

  describe "interface" do
    specify { pncount.should respond_to(:get) }
    specify { pncount.should respond_to(:inc) }
  end

  specify "get" do
    connection.should_receive(:query).with("PNCOUNT", "GET", key).exactly(:once) {
      value
    }

    pncount.get(key).should eq value
  end

  specify "inc" do
    connection.should_receive(:query).with("PNCOUNT", "INC", key, value)
      .exactly(:once) { "OK" }

    pncount.inc(key, value)
  end

  specify "inc failed" do
    connection.should_receive(:query).with("PNCOUNT", "INC", key, value)
      .exactly(:once) { "" }

    expect { pncount.inc(key, value) }.to raise_error StandardError
  end

  specify "dec" do
    connection.should_receive(:query).with("PNCOUNT", "DEC", key, value)
      .exactly(:once) { "OK" }

    pncount.dec(key, value)
  end

  specify "dec failed" do
    connection.should_receive(:query).with("PNCOUNT", "DEC", key, value)
      .exactly(:once) { "" }

    expect { pncount.dec(key, value) }.to raise_error StandardError
  end
end
