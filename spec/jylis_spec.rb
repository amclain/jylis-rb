describe Jylis do
  let(:server_name) { "db" }
  let(:server_port) { 6379 }
  let(:server_uri)  { "jylis://#{server_name}:#{server_port}" }
  let(:connection)  { Jylis::Connection.new(server_uri) }

  let(:hiredis_mock) { OpenStruct.new(connected?: true) }

  def expect_hiredis_connection
    Hiredis::Connection.should_receive(:new).exactly(:once) { hiredis_mock }
    hiredis_mock.should_receive(:connect).with(server_name, server_port).exactly(:once)
  end

  before { Jylis.current = nil }

  specify "can't be instantiated" do
    Jylis.should_not respond_to(:new)
  end

  describe "current connection" do
    before { expect_hiredis_connection }

    specify "can be set and get" do
      Jylis.current = connection
      Jylis.current.should eq connection
    end
  end

  describe "connect" do
    specify "when not connected" do
      expect_hiredis_connection

      Jylis.current.should eq nil

      Jylis.connect(server_uri)
        .should be_a Jylis::Connection

      Jylis.current.should be_a Jylis::Connection
    end

    specify "when already connected" do
      Hiredis::Connection.should_receive(:new).exactly(:twice) { hiredis_mock }
      hiredis_mock.should_receive(:connect).with(server_name, server_port).exactly(:twice)
      Jylis.current.should eq nil

      Jylis.current = connection

      hiredis_mock.should_receive(:disconnect).exactly(:once)

      Jylis.connect(server_uri)
        .should be_a Jylis::Connection

      Jylis.current.should be_a Jylis::Connection
      Jylis.current.should_not eq connection
    end
  end

  describe "forwarded methods" do
    let(:connection) { OpenStruct.new }

    before { Jylis.current = connection }

    specify "connected?" do
      connection.should_receive(:connected?).exactly(:once) { true }

      Jylis.connected?.should eq true
    end

    specify "reconnect" do
      connection.should_receive(:reconnect).exactly(:once)

      Jylis.reconnect
    end

    specify "disconnect" do
      connection.should_receive(:disconnect).exactly(:once)

      Jylis.disconnect
    end

    specify "query" do
      params = ["TREG", "GET", "key"]
      result = [72.1, 100]

      connection.should_receive(:query).with(*params).exactly(:once) {
        result
      }

      Jylis.query(*params).should eq result
    end

    describe "data types" do
      shared_examples :data_type do |name|
        specify name do
          mock = OpenStruct.new

          connection.should_receive(name).exactly(:once) { mock }

          Jylis.send(name).should eq mock
        end
      end

      include_examples :data_type, :treg
      include_examples :data_type, :tlog
      include_examples :data_type, :gcount
      include_examples :data_type, :pncount
      include_examples :data_type, :mvreg
      include_examples :data_type, :ujson
    end
  end
end
