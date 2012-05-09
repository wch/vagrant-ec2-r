maintainer        "Winston Chang"
maintainer_email  "winston@stdout.org"
license           "Apache 2.0"
description       "Installs R"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.0.1"
recipe            "r", "Installs R"


supports          "ubuntu", "12.04"

depends           "apt"
