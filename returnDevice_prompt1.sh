#!/bin/bash

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

# Display the initial message and capture the button pressed
buttonPressed=$("$jamfHelper" -windowType "$windowType" -description "$initialMessage" -button1 "$button1" -button2 "$button2" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -title "$title")

echo $buttonPressed
