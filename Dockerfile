# Throwaway Ubuntu container to try this dotfiles' shell environment.
# Only Git, Zsh and curl are needed up front; ./install pulls in the rest.

FROM ubuntu:25.04

RUN apt-get update && apt-get install -y git zsh curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Clone the dotfiles repository over HTTPS
RUN git clone https://github.com/hzspyy/dotfiles.git /root/dotfiles

# Link configs (and bootstrap dotbot via uv). Tolerate the sudo-only package
# step failing inside the minimal container.
RUN cd /root/dotfiles && ./install || true

WORKDIR /root/dotfiles
CMD ["/bin/zsh"]
