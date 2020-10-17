# WEBSONA

## Product Details
 
#### Q1: What are you planning to build?


We are planning to build Websona - an iOS/Android application that will allow users to instantly connect on multiple social media platforms. Each user will have a unique set of QR codes that can be scanned to access one’s basic information, various social media handles as well as professional details. These QR codes will allow users to add each other as contacts. Users will also be able to label each other with custom tags. 

Moreover, event organisers will be able to create group QR codes that can be used to share upcoming events and export group information. Once a group is formed, it will be equipped with the ‘calendar’ feature that will generate times that all group members are available based on the individual time availability they mark on their calendars.

All in all, the motivation behind designing Websona is to streamline the networking process for individuals as well as event organizers and business HR folks.

----


#### Q2: Who are your target users?

Websona is meant to streamline the networking process and therefore is intended to be used all individuals who use social media to interact with people and build professional links. At the the same time, Websona will also come handy to event organisers who wish to meticulously organise vital participant information.

In the foreseeable future, Websona is scheduled to be used across Toronto restaurants, the Ryerson 2021 residence orientation, and upcoming networking conferences.

----


#### Q3: Why would your users choose your product? What are they using today to solve their problem/need?

There are several reasons why users would want to use a service like Websona:

* Given the COVID-19 context, the use of Websona will allow waiters to have the user's basic information (name and phone number, for example) with a quick QR code scan instead of the user having to write it down at every location they visit.

* Event organizers and business HR folks can create a group QR code that individuals can scan to be added to the group. Once added, groups hosts may share any upcoming events, and have access to all the information that users are willing to share. The host will be able to organize events, see who’s attending, and export the group information thereby making it easier to collect and distill participant information.

* The ‘calendar’ button in group chats will allow individuals to fill out their calendars with times they are unavailable. Once everyone has confirmed their calendars, overlapping free-times will be displayed. This calendar can be synced via email with their existing calendars should they choose to reduce redundancies in labour. The group can also “vote” for which time slot works best, and once that decision is finalized the time is “blocked” off on their respective calendars. This will provide users an easy outlet for comparing timetables and finding matching times.

----

#### Q4: How will you build it?

### Tech-Stack V1

- Mobile
    - Flutter + Dart
    - Testing: Use built-in testing frameworks from flutter for Unit Testing, Widget Testing & Integration Testing
- Web App
    - Vue.js + TypeScript
        - Why Vue? Lots of good looking prebuilt components with native bootstrap support
        - Why TS? Same syntax as JavaScript but with better auto-complete
    - Testing
        - Jest: Already includes assertion library unlike Mocha which requires libraries like Chai
- CI/CD
    - CircleCI
        - Easy integration with GitHub
        - Can build the entire pipeline on it without the need for using other tools (from building to testing to deployment)
        - Can have different branch specific pipelines
- Back-End
    - Node.js + TypeScript
        - Why Node? Easy to setup and use. Works anywhere with minimal effort
        - Why TS? Same syntax as JavaScript but with better auto-complete
        - Can use libraries like Nodemailer (really easy to use) to send group emails
- Deployment
    - Hosting: AWS
        - Provides fine grained control over the entire infrastructure → Can balance cost & performance ourselves based on the user count instead of relying on automated tools that give the same cost to performance ratio irrespective of user count
        - Reliable
        - Lots of services are available for free for a year
        - Better than literally everything else
        - If there is no in-memory data structure, Lambda functions can be used to save on cost modularize the server
        - Has it's own CI/CD tools if needed
- Testing Strategy
    - Every PR would need to pass unit tests + integration tests to be approved.
    - If a PR consists of visual changes (E.g.: new component on the mobile app or web app), there should be test deployment that can be used to review the changes
        - Can use Netlify for this

#### Q5: What are the user stories that make up the MVP?

----

### Mobile App
- Sign Up + Login
	- As a user, I should be able to open the app and create an account. If I already have an account, I should be able to login using my credentials so that I can access the app
- Create User Profile
	- As a user, I want to create a profile with my information on so that I can create QR codes and share my profile with other users
- Generate & Manage QR Codes
	- As a user, I should be able to generate QR codes for different sets of social media that I want to associate with those QR codes. I should also be able to delete 		  existing QR codes, or update them by adding or removing social media links. This would let me share my info with other users and allow me them to connect with me on             other platforms easily
- Scan other user codes
	- As a user, I want to be able to scan other users' QR codes to add them as a contact and receive their social media links so that I can connect with them on other 		  platforms
- Follow links to external Apps
	- As a user, I should be able to click on social media links on other users' profile and see their profile on those platforms so that I can connect with them easily
- Contact List
	- As a user, I want to add tags to each user whose code I scan so I can easily identify and filter all the scanned users
- Support for Tags
	- As a user, I want to add tags to each user whose code I scan so I can easily identify and filter all the scanned users
- Add group email/texts/events
	- As a user, I want to send group emails/texts/calendar events to groups of users that have certain tags associated with them so I can communicate with a certain set of users easily without having to contact them separately on other platforms
- Scanning code without Websona
	- As a new user, I should be provided with an option to download websona after scanning someone's QR code If I don't have it. Once I download the app, the process of adding that person as a contact should continue without having to re-scan the QR code so I can start using websona right away with minimal hassle
- Event Codes
	- As an event organizer, I want to generate QR code(s) specific to the event that I can share with the attendees so I can get a centralized list of all the attendees (and their relevant info) for the event

----

### Website

- Login
	- As a user, I want to login to my account on the website and look at all my contacts so that I can access them from my computer or other devices when I don't have access to the app
- Info Page for the App
	- As a potential user, I want to find more information about the app so that I can understand what the app is about and decide if I want to download the app or not
- Create links to App Store, Play Store
	- As a potential user, I want to click on links to play store or the app store so I can easily find and download the app after I visit the website
	
----

#### Q6: What are the roles & responsibilities on the team?


Websona is a project that is more backend heavy as compared to front end when it comes to the actual implementation. The UI aspect would be fairly basic as compared to the work in the backend. That is precisely why we have decided to have four back-end and two front-end developers. 

Aside from the development roles, we have one scrum master who would be responsible for ensuring that every team member adheres to the agreed upon agile principles. He/She is also responsible for holding regular scrum meetings as requested or needed. 

Since communication with our partners is vital for the project’s success, we have one person assigned as the Communications Lead. He/She would be responsible for all the communication between the team and the project manager and arranging ad-hoc meetings if necessary and ensuring everyone is on the same page at all times.




Our following outlines the various strengths and weaknesses of our team members:

1. __Gautam Gireesh__

    __Role__: Front-end Developer
    
    __Description__: Ensuring seamless flow throughout the app and connecting the front end aspect of the application to our backend.

    
    __Strength__:
    
   * Mobile Development
   * Version Control
   * Framework knowledge

   __Weakness__: 

   * Cloud Computing
   * Testing
   * Databases
   
   

2. __Parshva Shah__

   __Role__: Back-end Developer
   
   __Description__: Integrating authentication and authorization for the mobile and web app.

   
   __Strength__: 
   
   * Framework knowledge, 
   * Application Deployment (AWS, Heroku, Firebase etc.)
   * Data structure design

   __Weakness__: 
   
   * Interface Designing 
   * Clear and concise communication
   * Time management



3. __Ibrahim Fazili__

   __Role__: Back-end Developer / Scrum Master
   
   __Description__: Setting up databases and collections to efficiently store user information. As a Scrum Master, Ibrahim will also be responsible in conducting regular scrum meetings and ensuring everyone is working as per deadlines.

   
   __Strength__: 
   
   * Framework knowledge 
   * Quick to learn new technologies
   * Mobile Development 

   __Weakness__: 
   
   * AWS 
   * Limited work with backend
   * CI/CD




4. __Lakshya Gupta__

   __Role__: Back-end Developer 
   
   __Description__: Storing user media like profile photos safely and generating secure links that our application can use to fetch the required media. Lakshya will also be responsible for creating a CI/CD pipeline for improving work efficiency by automating building and testing. 

   
   __Strength__:
   
   * Experience with AWS
   * Extensive experience with backend development
   * CI/CD
   
   __Weakness__:
   
   * UI design
   * Front-end testing
   * Mobile testing + design



5. __Saakshi Shah__

   __Role__: Front-end Developer / Communication-Lead
   
   __Description__: Responsible for the design and testing aspect of the application. Creating front end test suites to ensure the user will not experience any bugs on their side. As communication lead, Saakshi will be responsible for maintaining a strong connection between the team and the project partners to make sure we deliver a product that meets all expectations.

   
   __Strength__: 
   
   * Experience with frontend
   * Node.js
   * Deployment 

   __Weakness__: 
   
   * Working with DB
   * Limited experience CI/CD
   * AWS
   
   

6. __Aditi Dagar__

   __Role__: Back-end Developer
   
   __Description__: Aditi is responsible for deploying the backend of the application to run it on a server that can be easily accessed by our application. She will be in charge of creating backend test suites to ensure no new features affect anything else already in place. 

   
   __Strength__:
   * Experience with Node.js
   * Backend testing (mocha/chai/artillery)
   * Experience with databases

   __Weakness__:
   * Limited CI/CD knowledge
   * Deployment
   * Frontend Experience
   

----


#### Q7: What operational events will you have as a team?

As a team, we are planning to meet with our project partner once a week on Tuesdays as discussed in our first meeting. All the team members live in close proximity so we’re planning to have in-person meetings as well for reviewing code or a code sprint depending on the progress made the past week. This would speed the process and ensure everyone is on the same page regarding the project implementation. 

Each meeting would consist of everyone talking about what they’ve worked on in the past week and if anyone needs any input or help from the rest of the team as a whole. This would make sure everyone is on the same track and would motivate the entire team to keep working.

We’ve had two meetings with our project partner so far. The preliminary meeting was mainly introductory in nature. The partner explained their entire project idea to us including what features they are looking to add and how the app would function to help us better understand what they have envisioned for Websona. We were given time to ask any questions regarding the same as well towards the end of the meeting. 

The second meeting was primarily held to present a mockup of the application we designed according to what we thought was adequate and talk about all the user stories we planned to incorporate. We did this so as to get feedback from our partner, and to make sure the idea we had in mind met their expectations. 

----

#### Q8: What artifacts will you use to self-organize?

Since we have a fixed date of when we have to meet with the partner, we all have individual reminders. Our communication manager, Saakshi Shah, will keep track of any important information that occurs in the weekly meetings with the partners. For our SCRUM meetings, any additional information that is discussed about a particular user story or task will be added on ClickUp. We will be using ClickUp to self-organize the team’s tasks. We will have a separate SCRUM board for the front and backend for both the website and the app. We will split the board into different steps of the process, “Open Tasks”, “InProgress”, “Review”, “Staged”. Each task will have an assigned programmer, priority status, time estimate and a “confidence level”, i.e. how confident the programmer is to finish the task by the deadline. We will first prioritize user stories that are necessary to have a basic implementation of the app, then enhancements come after. User stories will be assigned to team members based on how comfortable they are with it and if they have any experience working with something similar.

----

#### Q9: What are the rules regarding how your team works?


During the process of creating this application, as a group we plan on having meetings twice a week. One meeting will include our project TA and product partner while the other will consist of just the team itself. During our weekly meeting with the partner, we will discuss the current status of the project, as well as discuss certain problems that we have encountered along the way to consistently receive input on changes we can make to create the application our partner desires. We will be creating user stories that can be viewed by both our partner and our TA along with our projected deadline to ensure that we stay up to date with the production of our application.

As a group we will implement the 3 strike system. Everytime a member of the group misses a meeting without giving a reason why they will receive a strike, once their strike count hits three as a group we will make a decision as to whether we contact our professor and have him/her removed from the team. If a member is unable to finish their user stories, as a group we can put additional time in order to make sure we are keeping up with our suggested timeline. 
 
As is the case with every group assignment, teammates are bound to disagree and conflicts will arise. Non-responsiveness is a major downfall to many group projects, especially when deadlines are nearing, with each individual having their own responsibilities it is vital that the entire group stays on track and has their user stories completed on time. Our focus is to finish the task at hand, if an individual was to be unresponsive, the remaining members would equally split the load, and he/she will be dealt with at a later time for their actions.

Since we are a large group, it will be nearly impossible for any decision based on tech stack or implementation to be unanimous. We have already discussed that certain members may feel less comfortable with the languages/frameworks we choose to use for this project, however, we have decided to split the implementation in a manner such that either each individual has had experience with the language, or is doing something similar enough to a point where the learning curve wont be too steep.

Along with this, we will move forward with every decision on a majority basis i.e. 4 out of 6 members will have to agree on every decision we make. As per any other major conflicts, since we have worked with each other in the past, and trust one-another with any sort of task, we eliminate the possibility of ignoring each other's concerns and requests. This underlying team chemistry will be vital for us to meet our deadlines and design the application Websona as envisioned by our partners.



----
### Highlights

Our first meeting with the team of Websona was a productive one. We were able to make four critical decisions related to the product and one regarding our process. The following paragraphs will outline these decisions, the alternatives, and why we ultimately decided on the given conclusion.

1) __QR Codes__

	After introducing members of both teams, the first idea we tackled was QR codes. Our team was unsure of what Websona required. The options we discussed were having 2 set QR codes: Personal, Professional with the added option of having an optional customizable QR code. We also discussed the prospect of having 5 QR codes available to the customer, and they are free to choose from 1-5 customizable QR codes. While the first option set the tone of the app, it limited the consumer. On the contrary, the second option was what Websona deemed ideal. With this, the consumer would be able to customize the QR codes to their specific needs. Having discussed this for a while, both teams realized the second option made more sense for the target demographic.

2) __Website__

	Upon finalizing QR codes, one of our team members asked Websona whether or not they envisioned a website alongside the mobile app. While the Websona team had not discussed a website, they loosely described they wanted a website to redirect consumers to download the app, and have the standard information regarding the app. We presented Websona with two alternatives that added to their existing idea. One being, the website would additionally serve as the redirection point: if users who scanned a QR code from a Websona user did not have the app, the information the code stored would be redirected to open up on the Websona website instead. The second option we presented was the idea of a web app. Wherein the web app would fully function as the mobile app. Both alternatives were well received by Websona; they saw the appeal to having a fully functional web app. However, considering time constraints, both the Websona team and our TA suggested we stick to the first alternative. Furthermore, Websona was focused on getting the mobile app done first and saw a web app as a future improvement. Having discussed both options, both teams agreed to have a basic website that served as a redirection.

3) __Social Media Integration__

	An aspect of the app that was still up for discussion was whether or not social media would be fully integrated into the app. We discussed numerous options; one option considered was access to a user's social media profiles in the app itself. So once the user scanned a QR code and was presented with an Instagram handle, they'd be able to see that Instagram profile within the Websona app with one click. After thorough deliberation with the team, we realized this feature would require countless permissions and ideas outside of our skillset. An alternative both teams brainstormed was linking. Instead of having consumers login within the Websona app, they'd be redirected to the app or website of the given social media handle. This alternative was well within the boundary of our expertise and not as time-consuming as the initial approach. With the approval of Websona, we were also able to finalize this aspect of the app.

4) __Messaging Services__

	The initial proposal Websona presented us with explained how they'd like a group messaging service integrated into the app. We discussed this in-depth during our meeting and realized, like social media integration, there was simply not enough time and tools to deliver this. Furthermore, our TA strongly advised us against this; she explained how this required functionality outside our expertise. Considering her advice, both teams mutually concluded that this feature would be omitted for the time being.

5) __Communication__

	Having discussed product specifics, we finally discussed communication channels. Seeing how productive our Zoom meeting had been, both the Websona team and us decided weekly Zoom meetings would be ideal. We very quickly were able to determine our meetings would be on Tuesdays at 9 pm. Lastly, to make communication easier, the Websona team required one person as a point of contact that would represent our team. Having decided this before the meetings amongst us, we concluded that Saakshi would be the appointed individual. With this, we completed the communication aspect of our discussion.





