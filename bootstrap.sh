#!/bin/bash

set -e  # Exit immediately on error
set -o pipefail  # Fail if any piped command fails

echo "Bootstrapping your development environment..."

# Function to check if a command exists
function have() {
  command -v "$1" &>/dev/null
}

# 1. Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  echo "Xcode Command Line Tools installed."
else
  echo "Xcode Command Line Tools already installed."
fi

# 2. Install Homebrew if not already installed
if ! have brew; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "Homebrew installed."
else
  echo "Homebrew already installed."
fi

# 3. Install Ansible
echo "Updating Homebrew and installing Ansible..."
brew update
if ! have ansible; then
  brew install ansible
  echo "Ansible installed."
else
  echo "Ansible already installed."
fi

# 4. Clone the dotfiles repository
REPO_DIR=~/dotfiles
if [ ! -d "$REPO_DIR" ]; then
  echo "Cloning the dotfiles repository..."
  git clone https://github.com/no-hao/dotfiles.git "$REPO_DIR"
else
  echo "Repository already exists. Pulling latest changes..."
  cd "$REPO_DIR" && git pull
fi

# 5. Run the Ansible playbook
echo "Running the Ansible playbook..."
cd "$REPO_DIR/ansible"
if ansible-playbook playbook.yml; then
  echo "Ansible playbook executed successfully."
else
  echo "Ansible playbook failed. Check the logs for more details."
  exit 1
fi

echo "Bootstrap complete. If you just cloned this script, make it executable with: chmod +x bootstrap.sh"