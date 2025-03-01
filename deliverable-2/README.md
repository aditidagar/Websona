# Websona

## Description 
 * Websona is a cross platform(iOS/Android) application that allows people to instantly connect with others through multiple social medias with a simple QR scan. 
 * This will help save the user's time when they meet new people and wish to add them on various social media platforms. Instead of individually adding people on different social media platforms, Websona will provide the person's social media handles through a simple QR code scan. By separately organising one's basic information, social media handles and professional details, users can choose what information they wish to share with a new person.
 * Given the COVID-19 context, the use of Websona will allow waiters to have the user's basic information (name and phone number, for example) with a quick QR code scan instead of the user having to write it down at every location they visit.

## Key Features
 * Create your own QR Code to hold whichever social platforms you choose. Create one for your personal accounts, professional accounts, and social accounts etc.
 * You can scan QR Codes for individuals you meet, access the social media platforms they have given you access to, and add them as a contact for future reference
 * Any account you scan will automatically be added to your contacts directory along with information on how you met them
* Easily add any platform and create as many QR Codes as you like!

## Instructions
 
* Once you have launched the app on the emulator, you will first be taken to a screen where you need to either log in or sign up, the process is really simple and the app will guide you through the steps to confirm you account
* You will then be taken to the screen above, you can click the hovering + button to launch your camera and scan someone else’s QR Code, or you can hit the + in the top right corner to create your own QR
* You can navigate to the contacts tap to view anyone you have gotten in touch with in recent time, and view their social links
* If you hit the button to create a new QR Code, you will be taken to this page, where you can generate a new QR with any given name, and pass any of your linked social media accounts. Hitting create will save this QR and other can begin scanning it.
* Once you have scanned another user’s QR, you can choose to add them as a contact or dismiss it.

 
 ## Development requirements
 * If a developer were to set this up on their machine or a remote server, what are the technical requirements (e.g. OS, libraries, etc.)? 
   * Flutter version 1.22.2
   * Dart 2.10.2
   * Node version 10.16.3

###  Instructions to run the application (Flutter App)

#### Installing the apk
* Plug your android device intor your computer and make sure USB tehtering is turned on.

* Open terminal and change directory till you reach the directory called websona(which is located at /app/websona)

*Run the following commmand
```bash
flutter build apk --split-per-abi
```

* Then
```bash
flutter install
```

#### Running the application through an emulator
* The first step is to ensure that you have flutter and dart installed on your local machine, to test this run 
```bash
flutter --help
```
If this returns a version you are ready to move on, if not, you may follow the instructions on installing flutter here https://flutter.dev/docs/get-started/install/macos

 * Once flutter is installed, clone the github repository with the following command:  

```bash
git clone https://github.com/csc301-fall-2020/team-project-29-websona.git
```
 * Next traverse to the app/websona directory within the repository and run: flutter pub get (to download the dependencies)
 * If you are on macOS, simply download the latest version of Xcode available on the App Store which comes pre-installed with a series of iPhone and other Apple Emulators
* If you are on Windows, download Android Studio. You can then pick specific devices to run our application on
* Once you emulator is downloaded, simply launch the emulator
* You can now run the application with the command: flutter run
* If you have Visual Studio Code setup for flutter (recommended), then VSCode takes care of the dependencies and detects the emulator automatically (android emulator only). Then you can simply go to `main.dart` file and hit run. This should launch the emulator and install the app.
* You can also use a physical android or iOS device (iOS device only works on macOS) to run the app. The steps to install are the same as above. Just pick your physical device from vscode instead of an emulator

#### Note: On the profile page, don't try to update the profile picture for the user. The feature is a bit buggy right now. If you're on iOS, you'll get stuck on the image selection screen

###  Instructions to run the application server (Node.js App)
 * First step is to clone the github repository with the following command:  

```bash
git clone https://github.com/csc301-fall-2020/team-project-29-websona.git
```
* Next traverse to the backend folder and run:  npm i
* You can now run the server with the command: `npm start`

#### Note: Most of the features on the server would be unusable because they require some enviroment variables that are loaded from a .env file on server bootup. If you need to use those features, you may email anyone from the team and we will provide you with a stripped down version of the enviroment file. (we can't provide the original file because it contains some sensitive info (aws access keys etc.))
 
 ## Deployment and Github Workflow


 * We have weekly meetings where we decide who does what and when it needs to be done. Accordingly, everyone branches from master and work on their individual branches so as to avoid conflicts with each other. We assign work in such a way that whatever that can be done that doesn’t need something to be done before is done first. Whenever someone is done with their work, they make a pull request, leave a small description about what the branch is, and request the other members to review. Also if there are any merge conflicts with the master branch, the original poster will need to resolve them before making the PR. This ensures that no broken code is pushed to the main branch and that there is always a working instance of our code with a new feature at each iteration. Whoever is free will review the PR and if there are any adjustments, will request so and the original poster will add the necessary fixes. Once that is done, the reviewer will merge it with the master and the original poster will be assigned a different task.

 * As for the naming branches convention, it's always named something relevant to the feature of the branch. E.g, if the branch is supposed to be the backend code for sign-up logic, it would be called “sign-up-backend”

 * For deployment, we use a variety of tools. We use CircleCI for continuous integration for automated testing of our unit tests. This is to make sure that our code always compiles and doesn’t break certain conditions. We also use AWS to host our cloud infrastructure. We have EC2 instances running behind a load balancer. We use AWS S3 buckets to store & serve media & secret enviroment variables needed by the server. We also use Github Webhooks to notify our server of new updated on push to master branch. The webhook triggers a new instances to be deployed and the old instances to be destroyed.

 ## Licenses 

 * As discussed with our partner, our codebase would be made private and so we would not be using any public licensing but rather copyright the software under the partner/company’s name.

 * The development process remains the same but it’s just that no one is allowed to copy/modify our codebase.

 * We made this collective decision because we wanted to prevent any sort of copying and distribution of the idea.
