#!/bin/bash

#This shoudl reset password
#sudo dscl . -passwd /Users/test opassword
#sudo security set-keychain-password -o npassword -p opassword /users/test/Library/Keychains/login.keychain

/usr/bin/dscl . -passwd /Users/"$USER_ID" "$OLD_PASSWORD" "$NEW_PASSWORD"
security set-keychain-password -o "$OLD_PASSWORD" -p "$NEW_PASSWORD" /users/test/Library/Keychains/login.keychain

status=$?


if [ $status == 0 ]; then

echo "Password was changed successfully."

elif [ $status != 0 ]; then

echo "An error was encountered while attempting to change the password. /usr/bin/dscl exited $status."

fi

exit $status
