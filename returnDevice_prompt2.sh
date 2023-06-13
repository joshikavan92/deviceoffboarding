#!/bin/bash

# The path to the Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Prepare the confirmation message
confirmationMessage="You are about to surrender the device. All data will be wiped and will not be accessible again. Are you sure you want to continue?"

# Options for the confirmation message
windowType="utility"
button1="Yes"
button2="No"
defaultButton="2"
cancelButton="2"
icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
title="Confirmation Required"

# Display the confirmation message and capture the button pressed
buttonPressed=$("$jamfHelper" -windowType "$windowType" -description "$confirmationMessage" -button1 "$button1" -button2 "$button2" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -title "$title")

echo $buttonPressed
