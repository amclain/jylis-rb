describe "integration tests" do
  def start_server
    system("docker-compose", "-f", "docker/docker-compose.yml", "up", "-d")
  end

  def stop_server
    system("docker-compose", "-f", "docker/docker-compose.yml", "down")
  end

  def reset_server
    stop_server
    start_server
  end

  before do
    reset_server
    Jylis.connect("jylis://localhost")
  end

  after       { Jylis.disconnect if Jylis.connected? }
  after(:all) { stop_server }

  describe "TREG" do
    specify do
      Jylis.treg.set("temperature", 72.1, 1528238308)

      result = Jylis.treg.get("temperature")

      result.value.should     eq "72.1"
      result.timestamp.should eq 1528238308
    end

    specify "with iso8601 timestamp" do
      Jylis.treg.set("temperature", 72.1, "2018-06-05T22:38:28Z")

      result = Jylis.treg.get("temperature")

      result.value.should             eq "72.1"
      result.timestamp_iso8601.should eq "2018-06-05T22:38:28Z"
    end
  end

  describe "TLOG" do
    specify do
      Jylis.tlog.ins("temperature", 68, 1528238310)
      Jylis.tlog.ins("temperature", 70, 1528238320)
      Jylis.tlog.ins("temperature", 73, 1528238330)

      results = Jylis.tlog.get("temperature")

      results.count.should        eq 3
      results[0].value.should     eq "73"
      results[0].timestamp.should eq 1528238330
      results[1].value.should     eq "70"
      results[1].timestamp.should eq 1528238320
      results[2].value.should     eq "68"
      results[2].timestamp.should eq 1528238310

      Jylis.tlog.size("temperature").should eq 3

      Jylis.tlog.trimat("temperature", 1528238320)

      Jylis.tlog.cutoff("temperature").should eq 1528238320

      results = Jylis.tlog.get("temperature")

      results.count.should        eq 2
      results[0].value.should     eq "73"
      results[0].timestamp.should eq 1528238330
      results[1].value.should     eq "70"
      results[1].timestamp.should eq 1528238320

      Jylis.tlog.trim("temperature", 1)

      results = Jylis.tlog.get("temperature")

      results.count.should        eq 1
      results[0].value.should     eq "73"
      results[0].timestamp.should eq 1528238330

      Jylis.tlog.clr("temperature")

      Jylis.tlog.get("temperature").empty?.should eq true
    end

    specify "with iso8601 timestamp" do
      Jylis.tlog.ins("temperature", 68, "2018-06-05T22:38:30Z")
      Jylis.tlog.ins("temperature", 70, "2018-06-05T22:38:40Z")
      Jylis.tlog.ins("temperature", 73, "2018-06-05T22:38:50Z")

      results = Jylis.tlog.get("temperature")

      results.count.should                eq 3
      results[0].value.should             eq "73"
      results[0].timestamp_iso8601.should eq "2018-06-05T22:38:50Z"
      results[1].value.should             eq "70"
      results[1].timestamp_iso8601.should eq "2018-06-05T22:38:40Z"
      results[2].value.should             eq "68"
      results[2].timestamp_iso8601.should eq "2018-06-05T22:38:30Z"

      Jylis.tlog.trimat("temperature", "2018-06-05T22:38:40Z")

      results = Jylis.tlog.get("temperature")

      results.count.should                eq 2
      results[0].value.should             eq "73"
      results[0].timestamp_iso8601.should eq "2018-06-05T22:38:50Z"
      results[1].value.should             eq "70"
      results[1].timestamp_iso8601.should eq "2018-06-05T22:38:40Z"
    end
  end

  specify "GCOUNT" do
    Jylis.gcount.inc("mileage", 5)
    Jylis.gcount.inc("mileage", 10)

    Jylis.gcount.get("mileage").should eq 15
  end

  specify "PNCOUNT" do
    Jylis.pncount.inc("subscribers", 9)
    Jylis.pncount.dec("subscribers", 4)

    Jylis.pncount.get("subscribers").should eq 5
  end

  specify "MVREG" do
    Jylis.mvreg.set("temperature", 68)

    Jylis.mvreg.get("temperature").should eq ["68"]
  end

  describe "UJSON" do
    specify "hash values" do
      Jylis.ujson.set("users", "alice", {admin: false})
      Jylis.ujson.set("users", "brett", {admin: false})
      Jylis.ujson.set("users", "carol", {admin: true})

      Jylis.ujson.get("users").should eq({
        "alice" => {"admin" => false},
        "brett" => {"admin" => false},
        "carol" => {"admin" => true},
      })

      Jylis.ujson.ins("users", "brett", "banned", true)

      Jylis.ujson.get("users").should eq({
        "alice" => {"admin" => false},
        "brett" => {"admin" => false, "banned" => true},
        "carol" => {"admin" => true},
      })

      Jylis.ujson.clr("users", "alice")

      Jylis.ujson.get("users").should eq({
        "brett" => {"admin" => false, "banned" => true},
        "carol" => {"admin" => true},
      })
    end

    specify "array values" do
      Jylis.ujson.ins("admins", "carol")

      Jylis.ujson.get("admins").should eq "carol"

      Jylis.ujson.ins("admins", "alice")

      # List is sorted because order is nondeterministic.
      Jylis.ujson.get("admins").sort.should eq ["alice", "carol"]

      Jylis.ujson.rm("admins", "carol")

      Jylis.ujson.get("admins").should eq "alice"
    end
  end
end
