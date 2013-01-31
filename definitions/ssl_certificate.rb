#
# Cookbook Name:: ssl_certificates
# Definition:: ssl_certificate
#
# Copyright 2011-2012, Binary Marbles Trond Arve Nordheim
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define :ssl_certificate do
  name = params[:name] =~ /\*\.(.+)/ ? "#{$1}_wildcard" : params[:name]
  Chef::Log.info "Looking for SSL certificate #{name.inspect}"
  cert = search(:certificates, "name:#{name}").first
  Chef::Log.info "Found #{cert.inspect}"

  if cert["crt"]
    cert[:crt] = cert["crt"]
  end
  if cert[:crt]
    Chef::Log.info "Inserting crt from template"
    template "#{node[:ssl_certificates][:path]}/#{name}.crt" do
      source 'cert.erb'
      owner 'root'
      group 'ssl-cert'
      mode '0640'
      cookbook 'ssl_certificates'
      variables :cert => cert[:crt]
    end
  end

  if cert["key"]
    cert[:key] = cert["key"]
  end
  if cert[:key]
    Chef::Log.info "Inserting key from template"
    template "#{node[:ssl_certificates][:path]}/#{name}.key" do
      source 'cert.erb'
      owner 'root'
      group 'ssl-cert'
      mode '0640'
      cookbook 'ssl_certificates'
      variables :cert => cert[:key]
    end
  end

  if cert[:pem]
    template "#{node[:ssl_certificates][:path]}/#{name}.pem" do
      source 'cert.erb'
      owner 'root'
      group 'ssl-cert'
      mode '0640'
      cookbook 'ssl_certificates'
      variables :cert => cert[:pem]
    end
  end
end
