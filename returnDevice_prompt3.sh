#!/bin/bash

# The path to the Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Time at which to wipe the system (in 24-hour format)
wipeTime="25"

# Calculate the remaining time
remainingTime=$((wipeTime - $(date +%H)))

# Prepare the hourly message
hourlyMessage="Your account will be disabled in $remainingTime hours. Please complete any remaining work and send necessary emails in advance. If you wish to submit your device early, please click 'Return Device'."

# Options for the hourly message
windowType="utility"
button1="Return Device"
button2="Not Now"
defaultButton="2"
cancelButton="2"
icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
title="Attention Required"

# Display the hourly message and capture the button pressed
buttonPressed=$("$jamfHelper" -windowType "$windowType" -description "$hourlyMessage" -button1 "$button1" -button2 "$button2" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -title "$title")

echo $button
