#!/bin/bash

# Function to install zsh based on OS
install_zsh() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif [ "$(uname)" == "Darwin" ]; then
        OS="macOS"
    else
        echo "Unsupported OS"
        exit 1
    fi

    case $OS in
        ubuntu|debian)
            echo "Installing Zsh on Ubuntu/Debian..."
            sudo apt-get update && sudo apt-get install -y zsh
            ;;
        centos|rhel)
            echo "Installing Zsh on CentOS/RHEL..."
            wget http://security.ubuntu.com/ubuntu/pool/main/a/apt/apt_1.4_amd64.deb
            sudo dpkg -i apt_1.4_amd64.deb
            sudo apt-get install yum
            sudo yum install -y zsh
            ;;
        macOS)
            # Check if Homebrew is installed
            if ! command -v brew &> /dev/null; then
                echo "Homebrew not found. Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            echo "Installing Zsh on macOS..."
            brew install zsh
            ;;
        *)
            echo "Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

# Call the function to install Zsh
install_zsh

# Install Antigen
echo "Downloading Antigen..."
curl -L git.io/antigen > ~/antigen.zsh

# Append Antigen setup to .zshrc, if not already present
if ! grep -q "source ~/antigen.zsh" ~/.zshrc; then
    echo "Configuring .zshrc for Antigen..."
    cat <<EOT >> ~/.zshrc

# Load Antigen
source ~/antigen.zsh

# Load Antigen configurations from .antigenrc
antigen init ~/.antigenrc
EOT
else
    echo "Antigen is already configured in .zshrc."
fi

# Create or overwrite the .antigenrc file with your configuration
echo "Setting up Antigen bundles in ~/.antigenrc..."
cat <<EOT > ~/.antigenrc
# Load oh-my-zsh library.
antigen use oh-my-zsh
# Load bundles from the default repo (oh-my-zsh).
antigen bundle git
antigen bundle command-not-found
antigen bundle docker
# Load bundles from external repos.
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
# Select theme.
antigen theme jonathan
# Tell Antigen that you're done.
antigen apply
EOT

# Check if Zsh is the default shell and prompt to change it if not
if [[ $SHELL != *zsh ]]; then
    echo "Switching your default shell to Zsh..."
    chsh -s $(which zsh)
    echo "Default shell switched to Zsh. Please restart your terminal or run 'zsh' to start using Zsh."
fi

echo "Antigen setup complete!"
zsh