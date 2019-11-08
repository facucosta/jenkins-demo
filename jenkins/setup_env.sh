#!/bin/bash
service nginx start
service redis-server start
nodejs ./application/index.js
