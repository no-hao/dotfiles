#!/bin/bash

set -e  # Exit on error

echo "Bootstrapping your development environment..."

# 1. Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  echo "Xcode Command Line Tools installed!"
fi

# 2. Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installed!"
fi

# 3. Install Ansible
echo "Updating Homebrew and installing Ansible..."
brew update
brew install ansible
echo "Ansible installed!"

# 4. Clone the dotfiles repository
if [ ! -d ~/dotfiles ]; then
  echo "Cloning the dotfiles repository..."
  git clone https://github.com/no-hao/dotfiles.git ~/dotfiles
else
  echo "Repository already exists. Pulling latest changes..."
  cd ~/dotfiles && git pull
fi

# 5. Run the Ansible playbook
echo "Running the Ansible playbook..."
cd ~/dotfiles/ansible
ansible-playbook playbook.yml

echo "Bootstrap complete! 🎉"
echo "If you just cloned this script, make it executable with: chmod +x bootstrap.sh"