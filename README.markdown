# Vagrant-EC2-R

This repository shows how to use the same `chef-solo`-based provisioning scheme for Vagrant virtual machines and Amazon's EC2. This is useful because you'll be able to test the deployment procedures as you develop within a clean Vagrant machine. Running continuous deployment locally also saves tons of partial instance-hours, which can run into the hundreds of cents (I'm not made of money, people).

These scripts have been tested only on Mac OS X 10.7.

# Development (local)


Before you run this the first time, you will have to add the Ubuntu 12.04 base image. This will download it and store it in Vagrant's local storage (`~/.vagrant.d/boxes/`), with the name `precise64`:

    # Only need to run this once
    vagrant box add precise64 http://files.vagrantup.com/precise64.box

Then use Vagrant as you normally would:

    cd a_vagrant_machine/
    vagrant up
    vagrant ssh


# Production (EC2)

Start up a new EC2 instance (`ami-87712ac2` is a US west coast Ubuntu 12.04 64-bit server)

    ec2-run-instances ami-87712ac2                 \
      --instance-type t1.micro                     \
      --key yournamehere                           \
      --user-data-file bootstrap.sh

find its IP with

    ec2-describe-instances

and provision it using the same recipes as the demo Vagrant machine machine by running

    ./setup.sh <ip address> a_vagrant_machine/

DONE!

Don't forget to turn off your instances when you're finished:

    ec2-terminate-instances <i-instance_id>



# Converting existing Vagrantfiles

Just add three lines in the provisioning section of your `Vagrantfile` so it looks like this:

    config.vm.provision :chef_solo do |chef|

      <your provisioning here>

      require 'json'
      open('dna.json', 'w') do |f|
        chef.json[:run_list] = chef.run_list
        f.write chef.json.to_json
      end
        open('.cookbooks_path.json', 'w') do |f|
        f.puts JSON.generate([chef.cookbooks_path]
                               .flatten
                               .map{|x| File.expand_path(x)})
      end
    end


# Set up local machine

On your local machine, you will need the following:

* Install [Vagrant](http://vagrantup.com). (On Linux, `gem install vagrant`)
* Install [VirtualBox 4](http://www.virtualbox.org/wiki/Downloads)
* The `precise64` Vagrant base box; `vagrant box add precise64 http://files.vagrantup.com/precise64.box`.
* Do steps 1-11 from [this page](http://petterolsson.blogspot.com/2012/02/installing-amazon-ec2-api-tools-on-mac.html).
  * On Linux, instead of doing step 8, installing the EC2 command-line tools manually, they can be installed with `apt-get`. See the section on Linux below for more information.
  * Instead of step 12, put the following in your `~/.profile`. Make sure that the `JAVA_HOME` is appropriate for your system; if you have a Mac, delete the line for Linux:

```
# Setup Amazon EC2 Command-Line Tools
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=`echo $EC2_HOME/pk-*.pem`
export EC2_CERT=`echo $EC2_HOME/cert-*.pem`
export EC2_SSH_PRIVATE_KEY=`echo $EC2_HOME/*-keypair`
export JAVA_HOME=`/usr/libexec/java_home`   # On Mac
export JAVA_HOME=/usr/lib/jvm/default-java  # On Ubuntu linux
```

* Make sure you have the JSON Ruby gem installed:

```
gem install --user-install json
```

* Create a key pair in the appropriate region. In this case the region is `us-west-1`, and we'll use the name `test-ec2-keypair`:

```
ec2-add-keypair --region us-west-1 test-ec2-keypair > ~/.ec2/test-ec2-keypair
chmod 600 ~/.ec2/test-ec2-keypair
```

## Installing EC2 command line tools in Ubuntu Linux

The EC2 command line tools can be installed by enabling the "multiverse" repositories. In `/etc/apt/sources.list`, uncomment the lines that end with `multiverse`. For example:

    deb http://us.archive.ubuntu.com/ubuntu/ precise multiverse
    deb http://us.archive.ubuntu.com/ubuntu/ precise-updates multiverse

Then run:

    sudo apt-get update
    sudo apt-get install ec2-api-tools


# Thanks

This project is based on [vagrant-ec2](https://github.com/lynaghk/vagrant-ec2/) from Keming labs.