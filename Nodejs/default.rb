package "apache2" do
  action :install
end

service "apache2" do
  action [:enable, :start]
end

execute "chmod" do
  command "chmod -R 777 /opt"
  action :run
end