#!/bin/bash

# Get the currently logged in user's username
CURRENT_USER=$(stat -f%Su /dev/console)

# Get the full name of the currently logged in user
FULL_NAME=$(dscl . -read /Users/$CURRENT_USER RealName | tail -1 | cut -c 2-)

# The path to the Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Options for the initial warning message
windowType="utility"
initialMessage="An important message from IT is about to display. Please ensure no one else is viewing your screen before proceeding."
button1="Proceed"
button2="Not Now"
defaultButton="1"
cancelButton="2"
icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
title="Attention Required"

# Display the initial warning message and capture the button pressed
buttonPressed=$("$jamfHelper" -windowType "$windowType" -description "$initialMessage" -button1 "$button1" -button2 "$button2" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -title "$title")

# If the Not Now button was pressed, sleep for a delay then re-run this script
if [ "$buttonPressed" == "2" ]; then
    sleep 3600 # 1 hour delay
    exec "$0" # Re-run this script
    exit
fi

# Prepare the farewell message
FarewellMessage="Dear $FULL_NAME,

We regret to see you depart, your contributions have been invaluable. As you embark on a new professional journey, we want to ensure a smooth offboarding process for you.

Over the next few days, we will assist you with all the necessary offboarding formalities. We're placing a checklist file on your desktop that outlines the steps involved and what you can expect in the coming days.

This device is a corporate asset. It's important to adhere to our data policy while copying your personal data, as a breach can have serious consequences.

Thank you for your time with us. We wish you all the best in your future endeavors."

# Options for the farewell message
description="$FarewellMessage"
button1="Close"
button2="Open File"
defaultButton="2"
cancelButton="1"

# Create the checklist file
checklistFile="/Users/$CURRENT_USER/Desktop/Offboarding Checklist.txt"
echo "Offboarding Checklist:
1. Back up personal files: Ensure any personal files on the machine are backed up. 
2. Remove personal accounts: Any personal accounts (like Apple ID, Google, etc.) associated with the system should be removed. 
3. Return hardware: Any physical items, like security keys or access cards, should be returned.
4. Transfer work files: If there are files or documents related to work, ensure they are transferred to the appropriate person or place.
5. Provide contacts: If there are individuals that will need to take over your tasks, please provide this information to your supervisor. 
6. Prepare the machine: The machine will need to be returned in a state ready for the next user. This includes cleaning the machine, packing it in its original box if available, etc.
7. Data Security: Please ensure adherence to the data policy while transferring personal data.

Over the next few days, you will receive more information on the above points." > "$checklistFile"

# Display the farewell message with Jamf Helper and capture the button pressed
buttonPressed=$("$jamfHelper" -windowType "$windowType" -description "$description" -button1 "$button1" -button2 "$button2" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -title "$title")

# If the Open Checklist button was pressed
if [ "$buttonPressed" == "2" ]; then
    open "$checklistFile"
fi
