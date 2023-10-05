#!/bin/bash

# Initialize variables with URL, username, and password for Jamf API
JAMFURL="https://instance.jamfcloud.com"
JAMFUSER="API_User"
JAMFPASS="API_Password"

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

# Assuming the user data is provided in the format: 
# user54|Dwight Schrute|dwight.schrute@example.com|777-777-7781
user_data="user51|Luke Skywalker|luke.skywalker@example.com|777-777-7778
user52|Leia Organa|leia.organa@example.com|777-777-7779
user53|Han Solo|han.solo@example.com|777-777-7780
user54|Dwight Schrute|dwight.schrute@example.com|777-777-7781
user55|Michael Scott|michael.scott@example.com|777-777-7782
user56|Rachel Green|rachel.green@example.com|777-777-7783
user57|Monica Geller|monica.geller@example.com|777-777-7784
user58|Chandler Bing|chandler.bing@example.com|777-777-7785
user59|Richard Hendricks|richard.hendricks@example.com|777-777-7786
user60|Dinesh Chugtai|dinesh.chugtai@example.com|777-777-7787
user61|Erlich Bachman|erlich.bachman@example.com|777-777-7788
user62|Pam Beesly|pam.beesly@example.com|777-777-7789
user63|Jim Halpert|jim.halpert@example.com|777-777-7790
user64|Gilfoyle|gilfoyle@example.com|777-777-7791
user65|Joey Tribbiani|joey.tribbiani@example.com|777-777-7792
user66|Ross Geller|ross.geller@example.com|777-777-7793
user67|Phoebe Buffay|phoebe.buffay@example.com|777-777-7794
user68|Jared Dunn|jared.dunn@example.com|777-777-7795
user69|Stanley Hudson|stanley.hudson@example.com|777-777-7796
user70|Angela Martin|angela.martin@example.com|777-777-7797
user71|Yoda|yoda@example.com|777-777-7798
user72|Boba Fett|boba.fett@example.com|777-777-7799
user73|Kevin Malone|kevin.malone@example.com|777-777-7800
user74|Bertram Gilfoyle|bertram.gilfoyle@example.com|777-777-7801
user75|Janice Litman|janice.litman@example.com|777-777-7802
user76|Toby Flenderson|toby.flenderson@example.com|777-777-7803
user77|Gavin Belson|gavin.belson@example.com|777-777-7804
user78|Monica Hall|monica.hall@example.com|777-777-7805
user79|Nelson Bighetti|nelson.bighetti@example.com|777-777-7806
user80|Pied Piper|pied.piper@example.com|777-777-7807
user81|Creed Bratton|creed.bratton@example.com|777-777-7808
user82|Gunther|gunther@example.com|777-777-7809
user83|Meredith Palmer|meredith.palmer@example.com|777-777-7810
user84|Nelson Bighetti|nelson.bighetti@example.com|777-777-7811
user85|Russ Hanneman|russ.hanneman@example.com|777-777-7812
user86|Oscar Martinez|oscar.martinez@example.com|777-777-7813
user87|Carla Walton|carla.walton@example.com|777-777-7814
user88|Laurie Bream|laurie.bream@example.com|777-777-7815
user89|Jan Levinson|jan.levinson@example.com|777-777-7816
user90|Andy Bernard|andy.bernard@example.com|777-777-7817
user91|Ryan Howard|ryan.howard@example.com|777-777-7818
user92|Kelly Kapoor|kelly.kapoor@example.com|777-777-7819
user93|Erin Hannon|erin.hannon@example.com|777-777-7820
user94|Darryl Philbin|darryl.philbin@example.com|777-777-7821
user95|Holly Flax|holly.flax@example.com|777-777-7822
user96|Carol Stills|carol.stills@example.com|777-777-7823
user97|David Wallace|david.wallace@example.com|777-777-7824
user98|Ron LaFlamme|ron.laflamme@example.com|777-777-7825
user99|Jian Yang|jian.yang@example.com|777-777-7826
user100|Roy Anderson|roy.anderson@example.com|777-777-7827"
IFS='|' read -ra user_parts <<< "$user_data"

# Format the user data in JSON for the API request
json_payload=$(cat <<EOF
{
  "name": "${user_parts[1]}",
  "email": "${user_parts[2]}",
  "phone": "${user_parts[3]}"
}
EOF
)

# Upload the user data to the Jamf API
response=$(curl -s \
    --request POST \
    --url "${JAMFURL}/api/v1/users" \
    --header "Authorization: Bearer $api_token" \
    --header "Content-Type: application/json" \
    --data "$json_payload")

# Print the response (for debugging purposes)
echo "$response"
