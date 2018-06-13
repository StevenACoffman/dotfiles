#!/bin/bash

function redis() {
  redis-cli -h excel-redis-${sagoku_environment}.n4v7cw.ng.0001.use1.cache.amazonaws.com -p 6379
}
