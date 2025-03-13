FROM ros:humble

# Setup users and permissions
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user if it doesn't exist
RUN if ! id -u $USERNAME > /dev/null 2>&1; then \
        groupadd --gid $USER_GID $USERNAME \
        && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    fi

# Install required packages
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    python-is-python3 \
    git \
    udev \
    usbutils \
    dialog \
    apt-utils \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Miniforge
RUN wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh \
    && chmod +x /tmp/miniforge.sh \
    && /tmp/miniforge.sh -b -p /opt/miniforge \
    && rm /tmp/miniforge.sh

# Setup Miniforge
ENV PATH="${PATH}:/opt/miniforge/bin"
RUN /opt/miniforge/bin/conda init bash
RUN echo 'auto_activate_base: false' >> /opt/miniforge/condarc

# Set up serial port permissions
RUN usermod -a -G dialout ros

# Set up environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Add udev rules for serial devices
RUN echo 'KERNEL=="ttyUSB*", MODE="0666"' > /etc/udev/rules.d/50-usb-serial.rules
RUN echo 'KERNEL=="ttyACM*", MODE="0666"' > /etc/udev/rules.d/50-arduino.rules

WORKDIR /workspace

# Create ros2_ws directory structure
RUN mkdir -p /workspace/ros2_ws/src && \
    chown -R ros:ros /workspace/ros2_ws

# Create a bashrc with ROS2 setup
RUN echo "source /opt/ros/humble/setup.bash" >> /etc/bash.bashrc

# Set up entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]