#!/bin/bash
set -e

# Source ROS environment
source /opt/ros/$ROS_DISTRO/setup.bash

# Execute the command passed to the container
exec "$@"