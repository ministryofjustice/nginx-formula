require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

platform = os[:family]

describe "nginx dependencies" do
  %w(apache2-utils netcat-traditional).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe "nginx setup" do
  state = {
    "ubuntu"  => {
      "pkg"   => "nginx-full",
      "version" => "1.4.6-1ubuntu3",
      "svc"   => "nginx",
      "user"  => "nginx",
      "group" => "nginx"
    }
  }

  describe package(state[platform]["pkg"]) do
    it { should be_installed.with_version(state[platform]["version"] }
  end

  describe service(state[platform]["svc"]) do
    it { should be_enabled }
    it { should be_running }
  end

  describe user(state[platform]["user"]) do
    groups = %W(webservice www-data #{state[platform]["group"]})
    it { should exist }
    it { should have_home_directory "/var/cache/nginx" }
    it { should have_login_shell "/sbin/nologin" }
    groups.each do |g|
      it { should belong_to_group g }
    end
  end
 
end
