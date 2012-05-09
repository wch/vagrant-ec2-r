#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
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

if platform?("ubuntu") && node['platform_version'].to_f == 12.04
  apt_repository "precise-marutter-ppa" do
    uri "http://ppa.launchpad.net/marutter/rrutter/ubuntu"
    distribution "precise"
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "B04C661B"
    action :add
  end
end

package "r-base-core" do
  action :install
end