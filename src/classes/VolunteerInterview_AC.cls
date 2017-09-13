/**************************************************************************************
Created by: Vennila Paramasivam
Author: MST Solutions
CreatedDate : 06/28/2016
Description: Volunteer can provide their availability time for Interivew via Portal. Based
on the Volunteer Availability time, Chapter staff will confirm their Interview Date and Time.
****************************************************************************************/

Public class VolunteerInterview_AC
{
   Public Task currTask{get;set;}
   Public boolean displayPopUp{get;set;}
   Public boolean isTaskCreated{get;set;}
   public boolean displayConfirmTask{get;set;}
   User currUser;
   Public List<Task> volTask{get;set;}
   Public String interviewRT;
   Public String taskId;
   public String interviewContent{get;set;}
   public boolean bgTabPermission{get;set;}
   public boolean trainingTabVisible{get;set;} 
   List<npe5__Affiliation__c> currAffliation{get;set;} 
   public VolunteerInterview_AC()
    {
        currTask = new Task();
        displayPopUp = false;
        isTaskCreated = false;
        displayConfirmTask = false;
        Constant_AC  constant = new Constant_Ac();
        interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
        String chapterId;
        
        currUser = [SELECT id, contactId,contact.OwnerId FROM User WHERE Id = :userInfo.getUserId()];
        
        System.debug('currUser++++++++++++++++++++++ ' + currUser);
        currAffliation = [SELECT id,npe5__Organization__c,npe5__Organization__r.Volunteer_Manager__c FROM npe5__Affiliation__c WHERE npe5__Contact__c = :currUser.contactId AND npe5__Primary__c = True limit 1];
         
         if(currAffliation.size() >0)
         {
             chapterId = currAffliation[0].npe5__Organization__c;
         }
     
        // Based on the parameter value, It would display Background tab.
        if(ApexPages.currentPage().getParameters().get('bgRequired') != Null)
                bgTabPermission = Boolean.valueOf(ApexPages.currentPage().getParameters().get('bgRequired'));
        if(ApexPages.currentPage().getParameters().get('trainingRequired') != Null)
                trainingTabVisible = Boolean.valueOf(ApexPages.currentPage().getParameters().get('trainingRequired'));
      
        String nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.nationalRT).getRecordTypeId();
   
        // Dynamic Content for displaying text on Portal.
        for(Dynamic_Content__c currContent : [SELECT Id,Interview_Additional_Info__c  FROM Dynamic_Content__c 
                                              WHERE RecordTypeId = :nationalRT  AND Active__c = True])
        {
         
          if(currContent.Interview_Additional_Info__c != Null)
              interviewContent = currContent.Interview_Additional_Info__c;
         
        
        }
         volTask  = new List<Task>();
      /*  volTask = [SELECT id,Available_Date1__c, Available_Date2__c, Available_Date3__c,  Available_Time1__c,venue__c,
                             Available_Time2__c, Available_Time3__c, Chapter_Name__c, Subject, Status,
                             Confirmed_Time__c, Confirmed_Date__c, Availability_Time_Other1__c,Availability_Time_Other2__c,
                             Availability_Time_Other3__c FROM Task 
                             WHERE (Status = 'Scheduled') AND Confirmed_Date__c != Null AND Confirmed_Date__c > :Date.Today() AND
                             whoId =:currUser.ContactId AND Subject = 'Interview Task' AND RecordTypeId = :interviewRT  Order by CreatedDate DESC limit 1]; */
       
         String jsonbody = VolunteerInterviewTask_AC.getClassOfferingRecList(currUser.ContactId);
         System.debug('jsonBody+++++++++++++++++++ ' + jsonbody);
         List<Task> newTask = new List<Task>();
         List<Task> newTaskList;
         if(!Test.isRunningTest())     
         newTaskList =  (List<Task>) JSON.deserialize(jsonbody, List<Task>.class);
         else
             newTaskList = new list<task>();
         for(Task currTask : newTaskList)
         {
            if(currTask.Status == 'Scheduled' && currTask.Confirmed_Date__c  != Null && currTask.Confirmed_Date__c >= system.Today())
               volTask.add(currTask);
            else if(currTask.Status == 'Not Started')
                newTask.add(currTask);
         }
         System.debug('newTAsk+++++++++++++++++++++++'+ newTaskList);               
      
      // If Volunteer already registered and Interivew date confirmed by Chapter staff then
      // Confirmation Date and Time would be displayed on the Portal.
        if(volTask.size() > 0)
        {
         
          displayConfirmTask = True;
          taskId = volTask[0].id;
        
        
        }
        // If volunteer submitted their availability time but interview date not yet confirmed, Acknowlegement would be 
        //display on Portal.
        if(newTask.size() > 0)
        {
            isTaskCreated = True;
        } 
    }
    
    public PageReference submit()
    {
     try
     {
     
      Boolean flag = true;
      // Each Volunteer should submit two Available Time and Date. Its mandatory for all. Else It will throw an error message to 
      // submit volunteer for two available Date and Time. And also it should not be conflict. 
      if(currTask.Available_Date1__c == Null || currTask.Available_Time1__c == Null || currTask.Available_Time1__c == '')
      {
            flag = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter at least 2 available dates and times.');
            ApexPages.addMessage(myMsg);
            return null;
      }
      
      if(currTask.Available_Date2__c == Null || currTask.Available_Time2__c == Null || currTask.Available_Time2__c == '')
      {
            flag = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter at least 2 available dates and times.');
            ApexPages.addMessage(myMsg);
            return null;
      }
      
      if((currTask.Available_Date3__c != Null && (currTask.Available_Time3__c == Null || currTask.Available_Time3__c == '')) ||
         (currTask.Available_Date3__c == Null && currTask.Available_Time3__c != Null))
      {
            flag = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Available Date and Time3');
            ApexPages.addMessage(myMsg);
            return null;
      }
      
       if(currTask.Available_Date1__c <= Date.Today() ||  currTask.Available_Date2__c <= Date.Today() || currTask.Available_Date3__c <= Date.Today())
       {
            flag = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Available date should be greater than today.');
            ApexPages.addMessage(myMsg);
            return null;
       }
     
      if(((currTask.Available_Date1__c == currTask.Available_Date2__c) && (currTask.Available_Time1__c==currTask.Available_Time2__c)) &&
         ((currTask.Available_Date1__c == currTask.Available_Date3__c) && (currTask.Available_Time1__c==currTask.Available_Time3__c)) &&
         ((currTask.Available_Date2__c == currTask.Available_Date3__c) && (currTask.Available_Time2__c==currTask.Available_Time3__c)))
      {
      
            flag = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Available date and time 1, 2 and 3 should not be same.');
            ApexPages.addMessage(myMsg);
            return null;
      }
    
      if((currTask.Available_Date1__c == currTask.Available_Date2__c) && (currTask.Available_Time1__c==currTask.Available_Time2__c))
      {
            flag = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Available date and time 1 and 2 should not be same.');
            ApexPages.addMessage(myMsg);
            return null;
      
      }
      if((currTask.Available_Date1__c == currTask.Available_Date3__c) && (currTask.Available_Time1__c==currTask.Available_Time3__c))
      {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Available date and time 1 and 3 should not be same.');
            ApexPages.addMessage(myMsg);
            return null;
      
      }
      if((currTask.Available_Date2__c == currTask.Available_Date3__c) && (currTask.Available_Time2__c==currTask.Available_Time3__c))
      {
      
            flag = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Available date and time 2 and 3 should not be same.');
            ApexPages.addMessage(myMsg);
            return null;
      
      }
      
      if((currTask.Available_Time1__c == 'Other' && (currTask.Availability_Time_Other1__c == '' || currTask.Availability_Time_Other1__c == Null)) ||
         (currTask.Available_Time2__c == 'Other' && (currTask.Availability_Time_Other2__c == '' || currTask.Availability_Time_Other2__c == Null)) || 
         (currTask.Available_Time3__c == 'Other' && (currTask.Availability_Time_Other3__c == '' || currTask.Availability_Time_Other3__c == Null)))
      {
            flag = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Other details');
            ApexPages.addMessage(myMsg);
            return null;
      }
      
         if(flag == True)
         {
           currTask.recordTypeId = interviewRT;
           if(currAffliation.size() > 0)
           {
             if(currAffliation[0].npe5__Organization__r.Volunteer_Manager__c != Null)
                 currTask.OwnerId = currAffliation[0].npe5__Organization__r.Volunteer_Manager__c; 
           } 
           else
            currTask.OwnerId = currUser.contact.OwnerId; 
         
           currTask.whoId = currUser.ContactId;
           currTask.subject = 'Interview Task';
           currTask.Priority = 'High';
           currTask.ActivityDate = system.today() + 3;
           upsert currTask; // Creating Interview Task. 
           
           isTaskCreated = True;
          
         }
       
     }
     Catch(DMLException e)
     {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
            return null;
     }
        // Send the user back to current page.  
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     public void confirmReschedule()
     {
         displayPopUp = true;
     }
     
     public void hidePopup()
     {
       displayPopUp = false;
     }
     // There is an option for Volunteer to reschedule their Available Date and Time. If user submits
     // Reschedule button, Existing Availability would be changed to Rescheduled and New Page would render 
     // for capturing new Availability.
     public void Reschedule()
     {
      
      try
      {
        Task updateTask = new Task();
        updateTask.id = taskId;
        updateTask.status = 'Rescheduled';
        update updateTask;
        displayConfirmTask = false;
        isTaskCreated = false;
        displayPopUp = false;
      }
      Catch(DMLException e)
      {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
      
      }
     
     }
     
     // Retrieving Availability Time value from Field and Display on Portal.
     public List<SelectOption> getTimes()
     {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Task.Available_Time1__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
            
        }  
        return options;
     }  
     
}