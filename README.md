# ROS2 Docker Development Environment

This setup provides a containerized ROS2 Humble development environment with X11 and USB serial device support.

## Usage

### Option 1: Using VS Code Dev Containers

1. Install VS Code with the "Remote - Containers" extension
2. Open this folder in VS Code
3. When prompted, click "Reopen in Container" or use the command palette (F1) and select "Remote-Containers: Reopen in Container"

### Option 2: Using Docker Compose Directly

```bash
# Build and run the container
docker compose up -d

# Enter the container
docker compose exec ros2 bash
```

## X11 Display Setup

For GUI applications to work, run this on your host machine:
```bash
xhost +local:docker
```

## Serial Port Access

The container is configured to access `/dev/ttyACM0`. If your ESP32 connects on a different port, modify `docker-compose.yml` accordingly.

## Managing Docker Containers

To stop the container when you're done:
```bash
docker compose down
```

If you've modified the Dockerfile and need to rebuild:
```bash
docker compose build --no-cache
```

## Troubleshooting

1. If you encounter permission errors with Docker commands, you may need to add your user to the docker group. See [Docker's official documentation](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) on managing Docker as a non-root user.
2. If you can't access the ESP32 serial port, check the device name with `ls /dev/tty*` on your host and update the `devices` section in `docker-compose.yml`
3. For X11 display issues, ensure you've run the `xhost` command above