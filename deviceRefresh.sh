#!/bin/bash

# The path to the Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Prepare the initial message
initialMessage="Your device refresh is coming up. It's important to back up all your important files and understand how to set up your new Mac from this one. Please click 'See Instructions' to view a detailed guide. If you have already completed your backup and are ready for a device refresh, please click 'Refresh Device'."

# Options for the initial message
windowType="utility"
button1="Refresh"
button2="Instructions"
defaultButton="2"
cancelButton="2"
icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
title="Device Refresh Notice"

# Display the initial message and capture the button pressed
buttonPressed=$("$jamfHelper" -windowType "$windowType" -description "$initialMessage" -button1 "$button1" -button2 "$button2" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -title "$title")

# If the Refresh Device button was pressed
if [ "$buttonPressed" == "0" ]; then

    # Prepare the confirmation message
    confirmationMessage="You are about to refresh your device. All data will be wiped and will not be accessible again. Please ensure you have backed up all your important files. Are you sure you want to continue?"

    # Options for the confirmation message
    button1="Yes"
    button2="No"
    defaultButton="2"
    cancelButton="2"

    # Display the confirmation message and capture the button pressed
    buttonPressed=$("$jamfHelper" -windowType "$windowType" -description "$confirmationMessage" -button1 "$button1" -button2 "$button2" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -title "$title")

    # If the Yes button was pressed
    if [ "$buttonPressed" == "0" ]; then

        # Wipe the system
        # Option 1: Wipe the macOS Automatically without prompting user
        # More information can be found here: https://www.jamf.com/blog/howto-erase-all-content-and-settings-macos-redeployment/ 
        # Wipe the system at the end of the day. Use wipeDevice.sh and create a policy with custome trigger as 'wipe' 
        # /usr/local/jamf/bin/jamf policy -event wipe
        
        
        
        # Option 2: Wipe the macOS using Erase Assistant, making sure user sign out of Apple ID. 
        # If you want to prompt the User to Erase the Device themselves, you can add the instruction of same in instruction document. 
        open /System/Library/CoreServices/Erase\ Assistant.app 
    
        fi
        
        # If the See Instructions button was pressed
        elif [ "$buttonPressed" == "2" ]; then
        
            # Open the instructions document (replace the path with the actual path to your instructions document)
            open /path/to/instructions.pdf
        
fi
