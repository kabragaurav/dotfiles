#!/bin/bash

echo "### Running uninstall script by GAURAV KABRA ###"

# Function to uninstall zsh based on OS
uninstall_zsh() {
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
            echo "Uninstalling Zsh on Ubuntu/Debian..."
            sudo apt-get remove --purge -y zsh
            sudo apt-get autoremove -y
            ;;
        centos|rhel)
            echo "Uninstalling Zsh on CentOS/RHEL..."
            sudo yum remove -y zsh
            ;;
        macOS)
            echo "Uninstalling Zsh on macOS..."
            brew uninstall zsh
            ;;
        *)
            echo "Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

# Function to remove Antigen setup
remove_antigen() {
    echo "Removing Antigen..."
    rm -f ~/antigen.zsh
    if grep -q "source ~/antigen.zsh" ~/.zshrc; then
        echo "Removing Antigen configuration from .zshrc..."
        # Remove Antigen lines from .zshrc
        sed -i.bak '/# Load Antigen/,+5d' ~/.zshrc
    else
        echo "No Antigen configuration found in .zshrc."
    fi
    echo "Removing .antigenrc..."
    rm -f ~/.antigenrc
}

# Call the functions
uninstall_zsh
remove_antigen

# Prompt the user to change their default shell back to Bash if it was switched
if [[ $SHELL == *zsh ]]; then
    echo "Switching your default shell back to Bash..."
    chsh -s $(which bash)
    echo "Default shell switched to Bash. Please restart your terminal or run 'bash' to start using Bash."
fi

echo "Uninstallation complete!"
echo "### Completed uninstall script by GAURAV KABRA ###"
