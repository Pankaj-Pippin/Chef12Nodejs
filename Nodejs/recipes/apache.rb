#Install & enable Apache

package "httpd" do
  action :install
end

service "httpd" do
  action [:enable, :start]
end


#Virtual Hosts Files

node["Nodejs"]["sites"].each do |sitename, data|
  document_root = "/var/www/html/#{sitename}"
    directory document_root do
		mode "0755"
		recursive true
	end

	execute "enable-sites" do
		command "a2ensite #{sitename}"
		action :nothing
	end

	  template "/etc/httpd/sites-available/#{sitename}.conf" do
		source "virtualhosts.erb"
		mode "0755"
		variables(
		  :document_root => document_root,
		  :port => data["port"],
		  :serveradmin => data["serveradmin"],
		  :servername => data["servername"]
		)
	  end
	 
	  #notifies :restart, "service[httpd]"

	directory "/var/www/html/#{sitename}/public_html" do
		action :create
		end

	directory "/var/www/html/#{sitename}/logs" do
		action :create
		end	  
	  
	  
	#notifies :run, "execute[enable-sites]"
end


 
execute "chmod" do
  command "chmod -R 777 /opt"
  action :run
end

execute "httpd" do
  command "/sbin/service httpd restart"
  action :run
end