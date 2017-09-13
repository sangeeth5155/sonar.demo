/***************************************************************
Created By : Vennila Paramsivam
Author : MST Solutions
Created Date : 07/23/2016.
Description : This test class created for VolunteerInterview_Ac and Performing Unit Test for the Volunter Interview
Task Functionality.
***************************************************************************/
@isTest
Public class VolunteerInterview_ACTest
{ 

   // Creating Interview Task.
   static testmethod void createInterviewTask()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
         { 
              TestClassUtil.createDynamicContent();
              PageReference pageRef = Page.VolunteerInterview_VF; 
             
              Constant_AC  constant = new Constant_Ac();
              Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
              // Confirmation Task
             Task confirmationTask = new Task();
             confirmationTask.Subject = 'Interview Task';
             confirmationTask.RecordTypeId = interviewRT;
             confirmationTask.Available_Date1__c = Date.Today();
             confirmationTask.Available_Time1__c = '5 pm';
             confirmationTask.Available_Date2__c = Date.Today();
             confirmationTask.Available_Time2__c = '6 pm';
             confirmationTask.Status = 'Not Started';
             confirmationTask.whoId = con.id;
             insert confirmationTask;
             
             ConfirmationTask.confirmed_Date__c = Date.Today().addDays(5);
             ConfirmationTask.confirmed_Time__c = '6 pm';
             confirmationTask.Venue__c = 'Test';
             confirmationTask.Status = 'Scheduled';
             Update confirmationTask;
             
             
             Task newTask = new Task();
             newTask.Subject = 'Interview Task';
             newTask.RecordTypeId = interviewRT;
             newTask.Available_Date1__c = Date.Today();
             newTask.Available_Time1__c = '5 pm';
             newTask.Available_Date2__c = Date.Today();
             newTask.Available_Time2__c = '6 pm';
             newTask.Status = 'Not Started';
             newTask.whoId = con.id;
             insert newTask;
             
           
             Test.setCurrentPage(pageRef);
             VolunteerInterview_AC controller = new VolunteerInterview_AC();
           
             controller.submit();
             controller.confirmReschedule();
             controller.hidePopup();
             controller.getTimes();
         }
          
    }  
    // Entering Interview details with Blank AvailableDateandTime 1 Blank.
    public testmethod static void AvailableDateandTime1Blank()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
       
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
             currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        // Dynamic Content.
         System.RunAs(currUser)
         {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
            controller.currTask.Available_Date2__c  = Date.Today().addDays(-2);
            controller.currTask.Available_Time2__c  = '7 pm';
            controller.currTask.Available_Date3__c  = Date.Today().addDays(-2);
            controller.currTask.Available_Time3__c  = '8 pm';
            controller.submit();
           
        }
        
    }
     // Entering Interview details with Blank AvailableDateandTime 2 Blank.
    public testmethod static void AvailableDateandTime2Blank()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        // Dynamic Content.
        System.RunAs(currUser)
        {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
            controller.currTask.Available_Date1__c  = Date.Today().addDays(-2);
            controller.currTask.Available_Time1__c  = '7 pm';
            controller.currTask.Available_Date3__c  = Date.Today().addDays(-2);
            controller.currTask.Available_Time3__c  = '8 pm';
            controller.submit();
           
        }
        
     }
      // Entering Interview details with Blank AvailableDateandTime 3 Blank.
    public testmethod static void AvailableDateandTime3Blank()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        // Dynamic Content.
        System.RunAs(currUser)
        {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
            controller.currTask.Available_Date2__c  = Date.Today().addDays(-2);
            controller.currTask.Available_Time2__c  = '7 pm';
            controller.currTask.Available_Date1__c  = Date.Today().addDays(-2);
            controller.currTask.Available_Time1__c  = '8 pm';
            controller.currTask.Available_Date3__c  = Date.Today().addDays(-2);
            controller.submit();
           
        }
        
     }  
     // Creating Interview Task.
    public testmethod static void createInterviewTask1()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
               currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        // Dynamic Content.
        System.RunAs(currUser)
        {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
            controller.currTask.Available_Date1__c  = Date.Today().addDays(-2);
            controller.currTask.Available_Time1__c  = '6 pm';
            controller.currTask.Available_Date2__c  = Date.Today().addDays(-2);
            controller.currTask.Available_Time2__c  = '7 pm';
            controller.currTask.Available_Date3__c  = Date.Today().addDays(-2);
            controller.currTask.Available_Time3__c  = '8 pm';
            controller.submit();
           
        }
        
    }
    // Creating Interview Task with Same Date and Time for Availability.
    public testmethod static void CreateTaskforSameAvailability()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
               currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        // Dynamic Content.
        System.RunAs(currUser)
        {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
           
            controller.currTask.Available_Date1__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time1__c  = '7 pm';
            controller.currTask.Available_Date2__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time2__c  = '7 pm';
            controller.currTask.Available_Date3__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time3__c  = '7 pm';
            controller.submit();
           
        }
        
    }
    // Entering Availability 1 and 2 Same
   public testmethod static void createInterviewTask3()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
               currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        
        // Dynamic Content.
        System.RunAs(currUser)
        {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
           
            controller.currTask.Available_Date1__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time1__c  = '7 pm';
            controller.currTask.Available_Date2__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time2__c  = '7 pm';
            controller.currTask.Available_Date3__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time3__c  = '8 pm';
            controller.submit();
           
        }
        
    }
     // Entering Availability 3 and 2 Same
    public testmethod static void createInterviewTask4()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
               currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        // Dynamic Content.
        System.RunAs(currUser)
        {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
           
            controller.currTask.Available_Date1__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time1__c  = '7 pm';
            controller.currTask.Available_Date2__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time2__c  = '8 pm';
            controller.currTask.Available_Date3__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time3__c  = '8 pm';
            controller.submit();
           
        }
        
    }
    // Entering Availability 3 and 1 Same
    public testmethod static void createInterviewTask5()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
               currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        // Dynamic Content.
        System.RunAs(currUser)
        {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
           
            controller.currTask.Available_Date1__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time1__c  = '7 pm';
            controller.currTask.Available_Date2__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time2__c  = '6 pm';
            controller.currTask.Available_Date3__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time3__c  = '7 pm';
            controller.submit();
           
        }
        
    }
     // Entering Availability Other details
    public testmethod static void withOtherDetails()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
               currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        // Dynamic Content.
        System.RunAs(currUser)
        {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
            controller.currTask.Available_Date2__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time2__c  = '7 pm';
            controller.currTask.Available_Date1__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time1__c  = 'Other';
           
            controller.submit();
           
        }
        
    }  
    // Creating Task with Non Started status.
    public testmethod static void CreateTask()
    {   
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
        // Dynamic Content.
        System.RunAs(currUser)
        {
            TestClassUtil.createDynamicContent();
            PageReference pageRef = Page.VolunteerInterview_VF; 
            Test.setCurrentPage(pageRef);
            VolunteerInterview_AC controller = new VolunteerInterview_AC();
            Constant_AC  constant = new Constant_Ac();
            Id interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
            // Confirmation Task
            controller.currTask.Available_Date2__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time2__c  = '7 pm';
            controller.currTask.Available_Date1__c  = Date.Today().addDays(2);
            controller.currTask.Available_Time1__c  = '6pm';
            controller.currTask.RecordTypeId = interviewRT;
            controller.currTask.Subject = 'Interview Task';
           
            controller.submit();
            controller.Reschedule();
           
        }
        
    }  
}