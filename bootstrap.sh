#!/bin/bash

# 1. Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  # Wait until installation is complete
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  echo "Xcode Command Line Tools installed!"
else
  echo "Xcode Command Line Tools already installed."
fi

# 2. Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installed!"
else
  echo "Homebrew already installed."
fi

# 3. Install Ansible
echo "Updating Homebrew..."
brew update
echo "Installing Ansible..."
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

# 5. Verify the test file
if [ -f ~/dotfiles/test.txt ]; then
  echo "Test file successfully pulled from the repository:"
  cat ~/dotfiles/test.txt
else
  echo "Test file not found. Check the repository structure."
  exit 1
fi

# 6. Run the Ansible playbook
echo "Running the Ansible playbook..."
cd ~/dotfiles/ansible
ansible-playbook playbook.yml

echo "Bootstrap complete! 🎉"
