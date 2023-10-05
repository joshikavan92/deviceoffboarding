# DeviceOffboarding
Presented at MacSysAdmin 2023. 

This repository contains scripts for managing macOS devices using Jamf Pro presented at Masters of Mac events. 

The scripts serve various purposes such as device refresh, user offboarding, and providing hourly notifications for account disablement.

List of Scripts
Here is a brief description of each script:

Initial User Offboarding Prompt: This script presents the user with a dialog box stating that their last working day is approaching and their account will be disabled at the end of the day.

Confirmation Prompt for User Offboarding: This script prompts the user to confirm if they want to surrender their device. It warns them that all data will be wiped and will not be accessible again.

Hourly Account Disablement Notification: This script prompts the user with an hourly reminder that their account will be disabled soon. It calculates the remaining time and updates the message accordingly.

Device Refresh Notice: This script notifies the user that a device refresh is coming up and provides instructions on how to back up their data and set up a new Mac. It also allows the user to proceed with the device refresh if they are ready.

Usage
To use these scripts, you need to:

Download the scripts.
Modify them as needed to suit your specific environment and requirements. For example, you may need to replace placeholder text or paths with actual content.
Implement the scripts in your Jamf Pro instance, typically as policies or configuration profiles.
Please note that the scripts may need to be tested and modified before being deployed in a production environment. Be sure to follow best practices for scripting and Jamf Pro management to ensure that the scripts work as expected and do not cause unintended side effects.

For any issues or suggestions, please reach out to the author.

Disclaimer
These scripts are provided as is, without warranty of any kind. The author is not responsible for any damage or data loss that may occur from using these scripts. Always test scripts in a controlled environment before deploying them to production.

Use the scripts from attachment for generating similar messages & Prompts:

1. setExpiryDate.sh
<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/16d888e0-6ad3-4d42-a4d0-07599e9563c3">

<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/a50d37dd-81ee-4a12-bb66-d973d8959d28"> 


<img width="532" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/14470196-a6b3-4970-99a3-782822d5d2bc">

<img width="532" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/718f0563-1bc2-4e6f-aa0e-60002585983f">


