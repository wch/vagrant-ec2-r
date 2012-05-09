#
# Cookbook Name:: r
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
  apt_repository "precise-CRAN-iastate" do
    uri "http://streaming.stat.iastate.edu/CRAN/bin/linux/ubuntu"
    distribution "precise/"
    # components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "E084DAB9"
    action :add
  end
end

package "r-base-core" do
  version "2.15.0-1precise0"
  action :install
end
