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
end
