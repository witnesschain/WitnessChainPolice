# WitnessChainPolice

## Quickstart

Begin with a working installation of XCode. Clone our iosApp repository in your folder of choice by running:

```
git clone https://github.com/witnesschain/server
```
After that, open up Xcode and open any file within your newly cloned folder. This should get you to a screen that looks like this:

![XCode Start Screen](images/xcode.png)

However, before installing our app on your phone, you will have to hardcode the address of the server that you started in the server Quickstart guide. You can locate the url in the terminal where you are running the server. It should look like this:

![Server Running](images/terminal.png)

Then, navigate to the ```appDelegate.swift``` tab on the left, and look for line 19 of the code. You should see something that says

```
let baseUrl: String = "http://10.xxx.xxx.xx:xxxx"
```

Replace this string with your address that was given through your server terminal. Then, plug in an iPhone to your computer, ensure that it is selected as the target device in the top left corner, and hit play. The app should be running on your phone now.


## How to Use the App

The app begins with a login screen. Enter your credentials, and create an account if you do not already have one.

![Login Screen](images/signin.png)

Then, link your account to your Ethereum public address. This will ensure your wallet is the same as your public one, if you already have one.

![Public Key Screen](images/publickey.png)

Now, you should have arrived at the evidence screen. Here, you can view evidence submitted to your police jurisdiction. As an officer, you may scroll through the evidence and select one that seems like a ticket could be valid.

<TODO: Add picture of evidence screen, pointing to next screen>

On that page, you can see all of the blurred versions of the evidence as well as some location and time metadata. Should you choose to approve those pictures and purchase the evidence, you may tap the "Approve and Purchase" button, which will pay the submitter of the evidence.

<TODO: Add picture of evidence view screen, pointing to next screen>

From there, you can switch to the approved tab and view the purchased evidence files, gaining access to the "clear" versions of the images.
