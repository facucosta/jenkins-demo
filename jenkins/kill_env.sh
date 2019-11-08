#!/bin/bash
service nginx stop
service redis-server stop
pkill -KILL nodejs
