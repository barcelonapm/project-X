#!/bin/bash

if [ ${ENVIRONMENT} == "devel" ]; then
  exec carton exec morbo -l http://[::]:8080 "$@"
else
  exec carton exec hypnotoad -f "$@"
fi
