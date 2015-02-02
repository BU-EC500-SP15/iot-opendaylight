#“Multi-Thing” IoT Applications over OpenDaylight Project Outline



####Index
1. Vision
2. Properties
  *  Security Needs
  *  Components
  *  Functionality 
  *  Performance 
  *  Scalability
3. Scope
4. Things to Explore
5. Users/Personas/Roles of Project
6. References


####1. Vision 
   This project will aim at providing two smart city mobile applications, that will save money for Boston, upgrade city infrastructure, and/or make human life better.
   
####2. Properties
  *  Security Needs: Must require password protected administrator login/registration to access data
  
  *  Components: Smart devices, Reasoner, rendering engine, mobile app
  
  *  Functionality: Collect data from smart devices. Retrieve, dissect and organize data.  Display required information on mobile application

  *  Performance: Low energy smart devices may upload data (occasionally or continuously) to the cloud and quickly display results on mobile app
  
  *  Scalability: Can apply to multiple cities in order to upgrade infrastructure, cut costs or benefit the environment

####3. Scope
#####a.  Inside Project’s Scope
  This project will enable end users to view data collected over sensors in a favorable manner by underlying layer that will enable the architecture. Hence, the project will highly concentrate on Storage aspect of Cloud Computing and will incorporate most layers of IoT Reference model esp. the innermost (Physical Devices and Connectivity) and outermost (Application and Access) layers. Also, in due course the scope may be extended to an added implementation layer for data aggregation.
#####b. Out of Scope
  The project will provide clients with an application to view statistical data. It will work highly similar to on a Request/Pull format. i.e. users would be able to pull data out of ODl Server. An interaction or a response-driven action are not incorporated within it and hence are out of this project’s scope.


####4. Techniques and Technologies to be used/ Things to be Explored
###### Overall Structure of the project
  *  Smart device collects the data and sends to ODL data store
       *  Implement oneM2M CRUDs over HTTP or CoAP
  *  Reasoner (a software module in Java running within or on top of ODL) extracts IoT data from the ODL data store (or back-end database), and process it to produce the solution of the problem
  *  Rendering engine takes the output of the reasoner and makes it available to be consumed by a client IoT application
  *  Mobile application/visual to display by accessing a URL located on the ODL server

####5.User / Roles / Personas of Project :
  *  Principal Users : 
       *  Residents and Tourists
       *  Higher Authorities taking implementation decisions for Smart Cities
  *  User Characteristics to be considered : 
       *  Age group
       *  Usage Statistics for related applications/ activities


####6. References :

######For Project Proposal : 
  *  Release planning (Sprint Planning And Schedule Overview)
       *  Sprint 1/Week 1 : Project Outline,Planning and Researching Technologies to be Used
       *  Sprint 2/Week 2  : Project Proposal and End-User Survey ; Familiarizing with REST and ODl
       *  Sprint 3/Week 3 : ‘Calibrating’ Sensors and Working over Data Collection Techniques
       *  Sprint 4/Week 4 : ODl - Working with ‘Data In’ Phase
       *  Sprint 5/Week 5 : ODl - Pushing Data In, Working over Mobile App to represent Data-1(Pulling Data Out)
       *         *  Sprint 6/Week 6 :  Working over Mobile App to represent Data-2
       *  Sprint 7/Week 7 : Project Demo - Will try to accomplish a successful demo showing the Data without the Compute Aspect over a simple application.
       *         *  Sprint 8-10/Week 8-9 : Exploring Test Cases
       *  Sprint 11/Week 10 : Implementing Test Cases
       *  Sprint 12/Week 11 : Deploying the Application for feedback
       *  Sprint 13/Week 12 : Analysing Feedback and Enforcing Improvements


