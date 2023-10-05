#!/bin/bash

# Get the currently logged in user's username
CURRENT_USER=$(stat -f%Su /dev/console)

# The path to the Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Prepare the initial message
initialMessage="Today is your last working day. Your account will be disabled and you will not be able to access your files and computer after 5 PM. Please complete any remaining work and send necessary emails in advance. If you wish to submit your device early, please click 'Return Device'."

# Options for the initial message
windowType="utility"
button1="Return Device"
button2="Not Now"
defaultButton="2"
cancelButton="2"
icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
title="Attention Required"

# Time at which to wipe the system (in 24-hour format)
wipeTime="17"

# Start the countdown
for (( i = $(date +%H); i <= wipeTime; i++ )); do

    # Display the initial message and capture the button pressed
    buttonPressed=$("$jamfHelper" -windowType "$windowType" -description "$initialMessage" -button1 "$button1" -button2 "$button2" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -title "$title")

    # If the Return Device button was pressed
    if [ "$buttonPressed" == "0" ]; then

        # Prepare the confirmation message
        confirmationMessage="You are about to surrender the device. All data will be wiped and will not be accessible again. Are you sure you want to continue?"

        # Options for the confirmation message
        button1="Yes"
        button2="No"
        defaultButton="2"
        cancelButton="2"

        # Display the confirmation message and capture the button pressed
        buttonPressed=$("$jamfHelper" -windowType "$windowType" -description "$confirmationMessage" -button1 "$button1" -button2 "$button2" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -title "$title")

        # If the Yes button was pressed
        if [ "$buttonPressed" == "0" ]; then

            # Run Jamf recon
            /usr/local/jamf/bin/jamf recon

            # Upload the system logs to Jamf Pro. 
            # Query all Extension Attributes like Battery Health, System Health etc part of recon

            # Wipe the system
            # Use instructions from https://www.jamf.com/blog/howto-erase-all-content-and-settings-macos-redeployment/#:~:text=First%2C%20to%20send%20the%20EraseDevice,%3E%20Management%20Commands%20%3E%20Wipe%20Computer. to identify system ID and wipe it.

            exit
        fi
    fi

    # Update the initial message with the remaining time
    initialMessage="Your account will be disabled in $((wipeTime - i)) hours. Please complete any remaining work and send necessary emails in advance. If you wish to submit your device early, please click 'Return Device'."

    # Wait for one hour before displaying the message again
    sleep 3600

done

# Option 1: Wipe the macOS Automatically without prompting user
# More information can be found here: https://www.jamf.com/blog/howto-erase-all-content-and-settings-macos-redeployment/ 
# Wipe the system at the end of the day
# /usr/local/jamf/bin/jamf policy -event wipe



# Option 1: Wipe the macOS using Erase Assistant, making sure user sign out of Apple ID. 
# If you want to prompt the User to Erase the Device themselves, you can add the instruction of same in instruction document. 
open /System/Library/CoreServices/Erase\ Assistant.app 
