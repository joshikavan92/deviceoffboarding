#!/bin/bash

# Initialize variables with URL, username, and password for Jamf API
# API User should need access to read & write User Extension Attributes

JAMFURL="https://instance.jamfcloud.com"
JAMFUSER="APIUSER"
JAMFPASS="APIPASSWORD"

# Create base64-encoded username:password string for basic authentication
BASIC_AUTH=$(echo -n "$JAMFUSER:$JAMFPASS" | base64)

# Get the authentication token from Jamf API using curl
authToken=$(curl -s \
    --request POST \
    --url "${JAMFURL}/api/v1/auth/token" \
    --header 'Accept:application/json' \
    --header "Authorization: Basic $BASIC_AUTH")

# Extract API token from authToken using different methods based on Mac OS version
if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
    api_token=$(/usr/bin/awk -F \" 'NR==2{print $4}' <<< "$authToken" | /usr/bin/xargs)
else
    api_token=$(/usr/bin/plutil -extract token raw -o - - <<< "$authToken")
fi


# Define the message
message="Attention! You're setting up the 'Last Working Date' for a user. This action will initiate offboarding policies and enforce offboarding restrictions."

# Display the message box with a caution icon
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -heading "Warning" -description "$message" -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns" -button1 "OK" -defaultButton 1



# Modify the USERS variable to use line breaks
USERS=$(curl -s -X GET "$JAMFURL/JSSResource/users" -H "Authorization: Bearer $api_token" | xmllint --format - | grep "<name>" | sed -e 's/<name>/\
/g' -e 's/<\/name>//')

# Create an array from the user list
IFS=$'\n' read -r -a USER_LIST_ARRAY <<< "$USERS"

# Use AppleScript to create a user selection dialog with line breaks
selectedUser=$(osascript <<EOD
    set userList to paragraphs of "$USERS"
    set selectedUser to choose from list userList with prompt "Please select a user:" default items {""} without multiple selections allowed and empty selection allowed
    if selectedUser is false then
        return ""
    else
        return item 1 of selectedUser
    end if
EOD
)


# Check if HR canceled the user selection
if [[ -z "$selectedUser" ]]; then
    echo "User selection canceled. Exiting script."
    exit 0
fi

# Use AppleScript to prompt HR to enter a new date in YYYY-MM-DD format
newDate=""
while [[ ! $newDate =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; do
    newDate=$(osascript <<EOD
        set newDate to text returned of (display dialog "Enter the new date (YYYY-MM-DD):" default answer "")
        if newDate is "" then
            return ""
        else
            return newDate
        end if
EOD
    )

    if [[ ! $newDate =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        osascript -e 'display dialog "Invalid date format. Please use the format: YYYY-MM-DD" buttons {"OK"} default button "OK" with icon stop'
    fi
done

# Update the User Extension Attribute "Last Working Date"
curl -X PUT "$JAMFURL/JSSResource/users/name/$selectedUser" \
    -H "Content-Type: application/xml" \
    -H "Authorization: Bearer $api_token" \
    -d "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>
    <user>
        <extension_attributes>
            <extension_attribute>
                <id>1</id>  <!-- Replace with the actual Extension Attribute ID -->
                <value>$newDate</value>
            </extension_attribute>
        </extension_attributes>
    </user>"

# Display a completion message in a message box with a green icon
osascript -e 'display dialog "Last Working Date for user '"$selectedUser"' has been updated to '"$newDate"'." buttons {"OK"} default button "OK" with icon "System:Library:CoreServices:CoreTypes.bundle:Contents:Resources:Everyone.icns" as alias'
