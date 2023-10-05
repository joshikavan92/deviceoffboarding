#!/bin/bash

# Initialize variables for Jamf API
JAMFURL="https://instance.jamfcloud.com"
JAMFUSER="APIUSER"
JAMFPASS="APIPASSWORD"
BASIC_AUTH=$(echo -n "$JAMFUSER:$JAMFPASS" | base64)

# Authenticate to the Jamf API
authToken=$(curl -s \
    --request POST \
    --url "${JAMFURL}/api/v1/auth/token" \
    --header 'Accept:application/json' \
    --header "Authorization: Basic $BASIC_AUTH")

if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
    api_token=$(/usr/bin/awk -F \" 'NR==2{print $4}' <<< "$authToken" | /usr/bin/xargs)
else
    api_token=$(/usr/bin/plutil -extract token raw -o - - <<< "$authToken")
fi

# Get the macOS serial number
SERIAL_NUMBER=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $NF}')

# Get the computer ID from Jamf using the serial number
computerIDResponse=$(curl -s \
    --header "Authorization: Bearer $api_token" \
    --url "${JAMFURL}/api/v1/computers/serialnumber/${SERIAL_NUMBER}" )

computerID=$(echo "$computerIDResponse" | /usr/bin/awk -F \" '/id/{print $4}')

# Send the erase command to the device using the retrieved computerID
passcode="000000"
response=$( /usr/bin/curl \
--header "Authorization: Bearer $api_token" \
--header "Content-Type: text/xml" \
--request POST \
--silent \
--url "${JAMFURL}/JSSResource/computercommands/command/EraseDevice/passcode/$passcode/id/$computerID" )

echo "$response"

# Expire the auth token
/usr/bin/curl \
--header "Authorization: Bearer $api_token" \
--request POST \
--silent \
--url "${JAMFURL}/api/v1/auth/invalidate-token"

exit 0
