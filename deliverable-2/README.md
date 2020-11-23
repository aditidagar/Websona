# Websona

> _Note:_ This document is intended to be relatively short. Be concise and precise. Assume the reader has no prior knowledge of your application and is non-technical. 

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

####  Instructions to run the application
* The first step is to ensure that you have flutter and dart installed on your local machine, to test this run 
```bash
flutter --help
```
If this returns a version you are ready to move on, if not, you may follow the instructions on installing flutter here https://flutter.dev/docs/get-started/install/macos

 * Once flutter is installed, clone the github directory with the following command:  

```bash
git clone https://github.com/csc301-fall-2020/team-project-29-websona.git
```
 * Next traverse to the websona directory within the backend folder and run:  npm i (macOS) or flutter pub get(Windows)
 * If you are on macOS, simply download the latest version of Xcode available on the App Store which comes pre-installed with a series of iPhone and other Apple Emulators
* If you are on Windows, our preference would be to download Android Studio, from which you can then pick specific devices to run our application on
* Once you emulator is downloaded, simply launch the emulator
* You can now run the application with the command: flutter run
 
 ## Deployment and Github Workflow


 * We have weekly meetings where we decide who does what and when it needs to be done. Accordingly, everyone branches from master and work on their individual branches so as to avoid conflicts with each other. We assign work in such a way that whatever that can be done that doesn’t need something to be done before is done first. Whenever someone is done with their work, they make a pull request, leave a small description about what the branch is, and request the other members to review. Also if there are any merge conflicts with the master branch, the original poster will need to resolve them before making the PR. This ensures that no broken code is pushed to the main branch and that there is always a working instance of our code with a new feature at each iteration. Whoever is free will review the PR and if there are any adjustments, will request so and the original poster will add the necessary fixes. Once that is done, the reviewer will merge it with the master and the original poster will be assigned a different task.

 * As for the naming branches convention, it's always named something relevant to the feature of the branch. E.g, if the branch is supposed to be the backend code for sign-up logic, it would be called “sign-up-backend”

 * For deployment, we use a variety of tools. We use CircleCI for continuous integration for automated testing of our unit tests. This is to make sure that our code always compiles and doesn’t break certain conditions. We also use AWS to host our cloud infrastructure. Our EC2 is behind a load balancer and we also use Github Workflows to notify our EC2 of new code, so this triggers a new instance to be deployed and the old instance to be destroyed.

 ## Licenses 

 * As discussed with our partner, our codebase would be made private and so we would not be using any public licensing but rather copyright the software under the partner/company’s name.

 * The development process remains the same but it’s just that no one is allowed to copy/modify our codebase.

 * We made this collective decision because we wanted to prevent any sort of copying and distribution of the idea.
