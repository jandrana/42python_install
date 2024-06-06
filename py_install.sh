#!/bin/bash

# This script is for installing Python unsing pyenv which is necessary for 
# typical tools used by 42 students like the francinette tester 
# For environments where Python is not installed and you do not have root access

# Define color codes
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
BOLD=$(tput bold)

echo -e "Starting installation...\n"
# Check if pyenv is already installed
if [ ! -d "$HOME/.pyenv" ]; then
	# Install pyenv
	echo -e "Installing pyenv in $HOME/.pyenv"
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
else
	echo -e "pyenv is already installed in $HOME/.pyenv. No changes were made."
fi

# Add environment variables to the shell configuration
case $SHELL in
	/bin/bash)
		ALIAS_FILE="$HOME/.bashrc"
		;;
	/bin/zsh)
		ALIAS_FILE="$HOME/.zshrc"
		;;
	*)
		echo -e "${RED}Unknown shell. Please add the following lines manually to your shell configuration file:${NORMAL}"
		echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
		echo 'export PYENV_ROOT="$HOME/.pyenv"'
		echo 'eval "$(pyenv init --path)"'
		echo -e "${RED}Then restart your shell.${NORMAL}"
		echo -e "\n If you need further assistance, please refer to the\n \e]8;;https://github.com/pyenv/pyenv?tab=readme-ov-file#set-up-your-shell-environment-for-pyenv\apyenv installation guide:\e]8;;\a"
		exit 1
		;;
esac

# Check if the environment variables already exist
if grep -q "PYENV_ROOT" $ALIAS_FILE; then
	echo -e "The environment variables for pyenv already exist. No changes were made."
else
	echo -e '\n# pyenv environment variables' >> $ALIAS_FILE
	echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $ALIAS_FILE
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $ALIAS_FILE
	echo 'eval "$(pyenv init --path)"' >> $ALIAS_FILE
	source $ALIAS_FILE # Source the shell configuration to apply the changes
	echo -e "${GREEN}Environment variables added to $ALIAS_FILE and sourced.${NORMAL}"
fi

echo -e "\nEnter the desired Python version or press Enter to install default version ${BOLD}(3.10)${NORMAL}"
read -p "" py_version
if [ -z "$py_version" ]; then
	py_version="3.10"
fi

# Install Python 3.10 using pyenv
echo -e "\nInstalling Python $py_version... This may take a while"

# Check if a version of Python $py_version is already installed
if [ -z "$(pyenv versions --bare | grep -E $py_version)" ]; then
	pyenv install $py_version
	echo -e "${GREEN}Python $py_version installed.${NORMAL}"
else
	echo -e "Python $py_version is already installed. No changes were made."
fi

# Verify the installation of $py_version with pyenv versions and python --version
echo -e "\nVerifying installation..."
if [ "$(pyenv versions | grep -c $py_version)" -eq 0 ]; then
	echo -e "${RED}Python $py_version installation failed. Please check the output for any errors.${NORMAL}"
	exit 1
else
	echo -e "${GREEN}Python version found: $(python --version)${NORMAL}"
fi

# Set Python $py_version as the global version
echo -e "\nSetting Python $py_version as the global version"
pyenv global $py_version

# Check if the global version is set to Python $py_version
if [ "$(pyenv global)" != "$py_version" ]; then
	echo -e "${RED}Setting Python $py_version as the global version failed. Please check the output for any errors.${NORMAL}"
	exit 1
else
	echo -e "${GREEN}Python $py_version set as the global version.${NORMAL}"
fi

echo -e "\n${GREEN}Installation complete. Please restart any open shell sessions for the changes to take effect.${NORMAL}"
