#
# Cookbook Name:: backup
# Recipe:: default
#
# Copyright 2012, Scott M. Likens
# Copyright 2012, AJ Christensen
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

backup_install node.name
backup_generate_config node.name
gem_package "fog" do
    version "~> 1.4.0"
  end
backup_generate_model "mongodb" do
  description "MongoDB backup"
  backup_type "database"
  database_type "MongoDB"
  split_into_chunks_of 2048
  store_with({"engine" => "S3", "settings" => { "s3.access_key_id" => node[:s3backup][:key], "s3.secret_access_key" => node[:s3backup][:secret], "s3.region" => node[:s3backup][:region], "s3.bucket" => node[:s3backup][:bucket], "s3.path" => node[:s3backup][:path], "s3.keep" => 10 } } )
  hour '*'
  options({"db.host" => "\"localhost\"", "db.lock" => true})
  mailto "shanestillwell@gmail.com"
  cron_path "/bin:/usr/bin:/usr/local/bin"
  tmp_path "/mnt/backups"
  cron_log "/var/log/backups.log"
  action :backup
end
