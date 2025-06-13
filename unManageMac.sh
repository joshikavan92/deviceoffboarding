#!/bin/bash

# Determine the serial number of the computer
SERIAL_NUMBER=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $NF}')

# Check if the serial number is empty (indicating it couldn't be determined)
if [ -z "$SERIAL_NUMBER" ]; then
    echo "Serial number could not be determined."
    exit 1
fi

# Initialize variables with URL, username, and password for Jamf API
JAMFURL="https://k1demo.jamfcloud.com"
JAMFUSER=""
JAMFPASS=""

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

# Endpoint to retrieve computer ID by serial number
COMPUTER_ID_ENDPOINT="/JSSResource/computers/serialnumber/${SERIAL_NUMBER}"

# Use curl to get the computer ID
COMPUTER_ID=$(curl -s \
    --url "${JAMFURL}${COMPUTER_ID_ENDPOINT}" \
    --header "Authorization: Bearer $api_token" \
    | xmllint --xpath "/computer/general/id/text()" -)

# Check if the COMPUTER_ID is empty (indicating the serial number was not found)
if [ -z "$COMPUTER_ID" ]; then
    echo "Computer with serial number $SERIAL_NUMBER not found."
    exit 1
fi

# Endpoint for unmanaging a computer using its ID
ENDPOINT="/JSSResource/computers/id/${COMPUTER_ID}"

# Perform the unmanage operation using the obtained API token and computer ID
curl -X PUT "$JAMFURL$ENDPOINT" \
    -H "Content-Type: application/xml" \
    -H "Authorization: Bearer $api_token" \
    -d "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>
    <computer>
        <general>
            <remote_management>
                <managed>false</managed>
            </remote_management>
        </general>
    </computer>"
