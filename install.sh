echo "Checking OS Type"

if [ "$(uname)" == "Darwin" ]; then
		echo "Darwin here"
		echo "Installing Homebrew"
		# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo "Git version $(git --version)"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		echo "Linux here"
		echo "Installing APT"
fi
