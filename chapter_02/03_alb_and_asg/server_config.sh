#!/bin/bash
echo "Hello World from $(hostname -f)!" > index.html
nohup busybox httpd -f -p 8080