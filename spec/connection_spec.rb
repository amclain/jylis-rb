describe Jylis::Connection do
  let(:server_name) { "db" }
  let(:server_port) { 6379 }
  let(:server_uri)  { "jylis://#{server_name}:#{server_port}" }
  let(:connection)  { Jylis::Connection.new(server_uri) }

  let(:hiredis_mock) { OpenStruct.new(connected?: true) }

  def expect_hiredis_connection
    Hiredis::Connection.should_receive(:new).exactly(:once) { hiredis_mock }
    hiredis_mock.should_receive(:connect).with(server_name, server_port).exactly(:once)
  end

  specify { Jylis::Connection.should respond_to(:new) }

  describe "interface" do
    before { expect_hiredis_connection }

    specify { connection.should respond_to(:connected?) }
    specify { connection.should respond_to(:reconnect) }
    specify { connection.should respond_to(:disconnect) }
    specify { connection.should respond_to(:query) }
    specify { connection.should respond_to(:treg) }
    specify { connection.should respond_to(:gcount) }
  end

  it "is instantiated with a server URI" do
    expect_hiredis_connection

    connection.should be_a Jylis::Connection
  end

  describe "server URI" do
    describe "requires a schema of jylis://" do
      let(:server_uri) { "redis://db" }

      specify do
        Hiredis::Connection.should_not_receive(:new)

        expect { connection }.to \
          raise_error Jylis::Connection::UnsupportedSchemaError
      end
    end

    describe "requires a host" do
      let(:server_uri) { "jylis://" }

      specify do
        Hiredis::Connection.should_not_receive(:new)

        expect { connection }.to raise_error Jylis::Connection::HostMissingError
      end
    end

    describe "sets the default port to 6379" do
      let(:server_uri)  { "jylis://db" }
      let(:server_port) { 6379 }

      specify do
        expect_hiredis_connection

        connection
      end
    end

    describe "can use a custom port number" do
      let(:server_port) { 5000 }

      specify do
        expect_hiredis_connection

        connection
      end
    end
  end

  describe "connected?" do
    before { expect_hiredis_connection }

    it "returns false if not connected" do
      hiredis_mock[:connected?] = false

      connection.connected?.should eq false
    end

    it "returns true if connected" do
      hiredis_mock[:connected?] = true

      connection.connected?.should eq true
    end
  end

  describe "reconnect" do
    specify "while already connected" do
      expect_hiredis_connection

      connection.connected?.should eq true

      hiredis_mock.should_receive(:disconnect).exactly(:once)
      hiredis_mock.should_receive(:connect).exactly(:once)

      connection.reconnect
    end

    specify "when disconnected" do
      expect_hiredis_connection
      
      hiredis_mock[:connected?] = false

      hiredis_mock.should_not_receive(:disconnect)
      hiredis_mock.should_receive(:connect).exactly(:once)

      connection.reconnect
    end
  end

  specify "disconnect" do
    expect_hiredis_connection

    hiredis_mock.should_receive(:disconnect).exactly(:once)

    connection.disconnect
  end

  describe "query" do
    let(:query_params)   { ["TREG", "GET", "foo"] }
    let(:query_response) { ["12", 1] }

    before {
      expect_hiredis_connection

      hiredis_mock.should_receive(:write).with(query_params).exactly(:once)
      hiredis_mock.should_receive(:read).exactly(:once) { query_response }
    }

    specify "as an argument list" do
      connection.query(*query_params).should eq query_response
    end

    specify "as an array" do
      connection.query(query_params).should eq query_response
    end
  end

  describe "data types" do
    before { expect_hiredis_connection }

    specify "treg" do
      connection.treg.should be_a Jylis::DataType::TREG
    end

    specify "gcount" do
      connection.gcount.should be_a Jylis::DataType::GCOUNT
    end
  end
end
