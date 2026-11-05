FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar SSH, sudo y Python
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario ansible con contraseña ansible
RUN useradd -m -s /bin/bash ansible && \
    echo 'ansible:ansible' | chpasswd && \
    usermod -aG sudo ansible

# Permitir sudo sin contraseña
RUN echo 'ansible ALL=(ALL) NOPASSWD:ALL' \
    > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Configurar SSH
RUN mkdir -p /run/sshd && \
    ssh-keygen -A && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]