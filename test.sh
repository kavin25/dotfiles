isInstalled() {
    COMMAND=$1
    if ! [ -x "$(command -v $COMMAND)" ]
    then
	echo "false"
	return 1;
    else
	echo "true"
	return 0;
    fi
}
move() {
    FILENAME=$1
    
    echo "found $FILENAME"
    # mv $FILENAME "$FILENAME.bck" && echo "moved $FILENAME to $FILENAME.bck"
    # echo;
}

if ! isInstalled git; then
    echo "Installing Git...\n"
    # sudo apt-get -y install git
fi


move hello
isInstalled http
