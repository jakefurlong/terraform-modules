#!/bin/bash

cat > index.html <<-EOF
<h1>Hello, World from $(hostname -f)!</h1>
EOF

nohup busybox httpd -f -p ${server_port} &