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

For any issues or suggestions, please reach out to the Kavan (kavan.joshi@jamf.com, Slack: MacAdmins > Kavan Joshi)

Disclaimer
These scripts are provided as is, without warranty of any kind. The author is not responsible for any damage or data loss that may occur from using these scripts. Always test scripts in a controlled environment before deploying them to production.

Use the scripts from attachment for generating similar messages & Prompts:

1. setExpiryDate.sh
 
<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/16d888e0-6ad3-4d42-a4d0-07599e9563c3">

<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/a50d37dd-81ee-4a12-bb66-d973d8959d28"> 

<img width="532" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/14470196-a6b3-4970-99a3-782822d5d2bc">

<img width="532" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/718f0563-1bc2-4e6f-aa0e-60002585983f">

2. user_message_jamfhelper.sh

<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/c30c1ab6-6d55-4d0d-851f-cd7fc6a21522"> 

<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/d2b2341f-995f-45e9-b5e7-42bf80f06214"> 

3. returnDevice.sh

<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/a6cc4999-77d1-4632-9352-574f99bd4236"> 

<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/90cb1ff1-887c-4813-95da-ecb06382695b"> 

<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/a2d4f5e8-2158-4a84-a662-7e7774a2c167"> 


    These scripts can be used to do manual prompt testing with your desired time and values :
    3.1 returnDevicePrompt1.sh,     3.2 returnDevicePrompt2.sh,    3.3 returnDevicePrompt3.sh 

4. deviceRefresh.sh

<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/946f7bb4-b483-460a-909f-28ac9656ef87"> 

<img width="525" alt="image" src="https://github.com/joshikavan92/deviceoffboarding/assets/3684384/1eb134a5-336e-447b-9642-482476b27b3d"> 


