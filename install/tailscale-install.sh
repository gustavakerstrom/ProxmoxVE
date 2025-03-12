#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Author: gustavakerstrom
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://tailscale.com/

# Import Functions und Setup
source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

# Installing Dependencies with the 3 core dependencies (curl;sudo;mc)
msg_info "Installing Dependencies"
$STD apt-get install -y \
  curl \
  sudo \
  mc \
  iptables
msg_ok "Installed Dependencies"


# Setup App
msg_info "Setup ${APPLICATION}"
$STD curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
$STD curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
$STD apt-get update
$STD apt-get install tailscale
msg_ok "Setup ${APPLICATION}"


motd_ssh
customize

# Cleanup
msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"