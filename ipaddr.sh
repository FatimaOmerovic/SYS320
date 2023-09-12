#!/bin/bash

# I chose to grep my IP because it searches for that particular pattern.
ip addr | grep '192.168.0.161/24'
