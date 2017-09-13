/********************************************************************************
Author : MST Solutions
Description: This is Volunteer Landing page. Once Volunteer successfully signed up into volunteer portal, they can redirected
to this volunteer landing page. This would display welcome message. This welcome message is dynamic content that is stored under 
Dynamic Content object.  And also this page would display two buttons 1. Become A Volunteer and 2. Continue Process.
1. Become A Volunteer would display when a volunteer login to portal without submitting any orientation.
2. Continue Process would display if the volunteer registered for orientation.
3. It will display the status of the form. Example, If orientation has been completed, then the status
would display in Green checked color. Once the Orientation completed only, It will redirect the user 
to Application page. Similary if user finished the application form only, they can submit background check.
*********************************************************************************/

public Class VolunteerWelcomePage_AC
{
    public Boolean displayBecomAVolunteer{get;set;}
    public Boolean displayContinueProcess {get;set;}
    public String welcomText{get;set;}
    public String becomeAVolunteer {get;set;}
    public Boolean isBecomVolunteer {get;set;}
    public Boolean continueProcess {get;set;}
    String chapterId;
    String eventsRTId;
    Constant_AC constant;
    public List<Contact> checkcontactApplicationList {get;set;}
    public List<Background_check__c> checkBackGroundList {get;set;}
    public List<Task> checkInterviewList {get;set;}
    public List<Volunteer_Orientation_Training__c> trainingList {get;set;}
    public List<Volunteer_Orientation_Training__c> orientationList {get;set;}
    public String gotoPage {get;set;}
    
    public String orientationStatus {get;set;}
    public String applicationStatus {get;set;}
    public String interviewStatus {get;set;}
    public String backgroundCheckStatus {get;set;}
    public String trainingStatus {get;set;}
    
    Set<Id> requiredOrientationIds = new Set<Id>();
    Set<Id> completedVolunteerTrainingIds = new Set<Id>();
    
    public Boolean bgRequired{get;set;}
    public Boolean trainingRequired{get;set;}
    
    
    public VolunteerWelcomePage_AC() {
        applicationStatus = null;
        interviewStatus = null;
        backgroundCheckStatus = null;
        trainingStatus = null;
        
        isBecomVolunteer = true;
        continueProcess = false;
        constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.activeVolRT).getRecordTypeId();
        Id volunteerContactRecordTypeId = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        Id orientationRecordTypeId = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get(constant.OrientationRT).getRecordTypeId();
        Id trainingRecordTypeId = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();
        Id boardMemberContactRecTyped = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.boardMemberRT).getRecordTypeId();
        gotoPage = '';
        trainingList = new List<Volunteer_Orientation_Training__c>();
        orientationList = new List<Volunteer_Orientation_Training__c>();
        User currentUser = [SELECT ID,ContactId FROM User WHERE Id = :userInfo.getUserId()];
        
        for(Volunteer_Orientation_Training__c checkOrientationAndTraining : [SELECT Id, Volunteer_Attendance__c, Class_Offering__c, Class_Offering__r.Chapter_Role_O_T__c,
                                                                             Class_Offering__r.Chapter_Role_O_T__r.Orientation_Training__r.RecordTypeId 
                                                                             FROM Volunteer_Orientation_Training__c WHERE Volunteer_Attendance__c != 'Cancelled' AND Volunteer__c =: currentUser.ContactId]) {
            if(checkOrientationAndTraining.Class_Offering__r.Chapter_Role_O_T__r.Orientation_Training__r.RecordTypeId == orientationRecordTypeId) {
                orientationList.add(checkOrientationAndTraining);
            } else if(checkOrientationAndTraining.Class_Offering__r.Chapter_Role_O_T__r.Orientation_Training__r.RecordTypeId == trainingRecordTypeId) {
                trainingList.add(checkOrientationAndTraining);
            }
        }
        
        // retrieving application details for getting application status.
        checkContactApplicationList = [SELECT Id,is_Application__c, (SELECT Id, Chapter_Role__c FROM Volunteer_Roles__r WHERE Chapter_Role__r.Background_Check_Required__c = true), RecordTypeId FROM Contact WHERE (RecordTypeId =:volunteerContactRecordTypeId OR RecordTypeId =:boardMemberContactRecTyped) AND Id =: currentUser.ContactId];
        
        bgRequired =false;
        trainingRequired = false;
        if(checkContactApplicationList[0].Volunteer_Roles__r.size() > 0)
        {
            bgRequired = true;
        }
        
        // retrieving background details for getting background check status.
        checkBackGroundList = [SELECT Id, Volunteer__c,Status__c FROM Background_check__c WHERE Volunteer__c =: currentUser.ContactId ORDER BY CreatedDate DESC LIMIT 1];
        // retrieving interview details for getting interivew status.
       
         String jsonbody = VolunteerInterviewTask_AC.getClassOfferingRecList(currentUser.ContactId);
         
         List<Task> newTask = new List<Task>();
         
         List<Task> newTaskList;
         if(!Test.isRunningTest())     
         newTaskList =  (List<Task>) JSON.deserialize(jsonbody, List<Task>.class);
         else
             newTaskList = new list<task>();
         checkInterviewList  = new List<Task>();
         for(Task currTask : newTaskList)
         {
            if(currTask.Status == 'Approved')
               checkInterviewList.add(currTask);
        
         }
       
       // checkInterviewList = [SELECT Id, Status FROM Task WHERE Subject ='Interview Task' AND WhoId =: currentUser.ContactId  AND (Status = 'Completed' OR Status = 'Approved') LIMIT 1];
        
        
        List<npe5__Affiliation__c> currAffliation = [SELECT id,npe5__Organization__c FROM npe5__Affiliation__c WHERE npe5__Contact__c = :currentUser.contactId AND npe5__Primary__c = true limit 1];
        
        constant = new Constant_AC();
        
        if(currAffliation.size() >0) {
            chapterId = currAffliation[0].npe5__Organization__c;
        }
        
        Set<Id> requiredTrainigIds = new Set<Id>();
        Set<Id> chatperRoleIds = new Set<Id>();
        
        for(Volunteer_Roles__c currRec : [SELECT id, chapter_role__c,Volunteer_Name__c  FROM Volunteer_Roles__c WHERE Volunteer_Name__c = :currentUser.contactId])
        {
            chatperRoleIds.add(currRec.chapter_role__c);
        }
        for(Chapter_Role_O_T__c currChapterRoleOT : [SELECT id,Orientation_Training__c FROM Chapter_Role_O_T__c WHERE Required__c = true AND Chapter_Role__r.chapter_Name__c = :chapterId  AND Orientation_Training__r.RecordTypeId = :orientationRecordTypeId])
        {
            requiredOrientationIds.add(currChapterRoleOT.Orientation_Training__c);
        }
        
        for(Chapter_Role_O_T__c currChapterRoleOT : [SELECT id,Orientation_Training__c FROM Chapter_Role_O_T__c WHERE Required__c = true AND Chapter_Role__c IN :chatperRoleIds AND Orientation_Training__r.RecordTypeId = :trainingRecordTypeId])
        {
            requiredTrainigIds.add(currChapterRoleOT.Orientation_Training__c);
        }
        
        if((requiredTrainigIds.size() > 0))
        {
            trainingRequired = true;
        }
        
        
        
        for(Volunteer_Orientation_Training__c checkOrientationAndTraining : [SELECT Id,Volunteer_Attendance__c,Class_Offering__r.Chapter_Role_O_T__c,
                                                                            Class_Offering__r.Chapter_Role_O_T__r.Orientation_Training__r.RecordTypeId, 
                                                                            Class_Offering__c FROM Volunteer_Orientation_Training__c WHERE 
                                                                            Volunteer_Attendance__c = 'Completed' AND Hidden_O_T_Id__c IN :requiredOrientationIds 
                                                                            AND Volunteer__c =: currentUser.ContactId AND Class_Offering__r.Chapter_Role_O_T__r.Orientation_Training__r.RecordTypeId = :orientationRecordTypeId]) 
        {
            completedVolunteerTrainingIds.add(checkOrientationAndTraining.id);
        }
        
        
        String nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.nationalRT).getRecordTypeId();
        String ProspectiveRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.prospectiveVolunteerRT).getRecordTypeId();
        
        //isBecomVolunteer = true;
        for(Dynamic_Content__c currContent : [SELECT Id,How_do_I_Become_a_Volunteer__c,Welcome_Text__c FROM Dynamic_Content__c 
                                              WHERE RecordTypeId = :nationalRT AND Active__c = true])
        {
            
            if(currContent.Welcome_Text__c != Null)
                welcomText = currContent.Welcome_Text__c;
            
        }
        
        List<Dynamic_Content__c> getBecomeAVolText =  [SELECT Id,How_do_I_Become_a_Volunteer__c,Welcome_Text__c FROM Dynamic_Content__c 
                                                       WHERE RecordTypeId = :ProspectiveRT AND Chapter_Name__c =:chapterId AND Active__c = true];
        
        if(getBecomeAVolText.size() > 0)
            becomeAVolunteer = getBecomeAVolText[0].How_do_I_Become_a_Volunteer__c;
        
        List<Volunteer_Orientation_Training__c> volunteerOritentationList = [SELECT id FROM Volunteer_Orientation_Training__c WHERE Volunteer__c = :currentUser.contactId AND Volunteer_Attendance__c != 'Cancelled'];
        if(volunteerOritentationList.size() > 0)
        {
            isBecomVolunteer=false;
        }
        findVolunteerStatus();
        
    }
    // It will redirect the volunteer based on the status. 
    public void findVolunteerStatus() 
    {
        // No orientation completed, then user moved to Orienation page.
        if(completedVolunteerTrainingIds.size() == 0)
        {
            isBecomVolunteer = true;
            orientationStatus = 'InProgress';
            gotoPage = 'VolunteerOrientation_VF';
            
        } // If user done the orientation, then redirect to Application page.
        else if(requiredOrientationIds.size() == completedVolunteerTrainingIds.size())
        {
            continueProcess = true;
            orientationStatus = 'Completed';
            gotoPage = 'Application_VF';
            
        }
        else
        {
            continueProcess = true;
            orientationStatus = 'InProgress';  
            gotoPage = 'VolunteerOrientation_VF';
        }
        
        
        // If application is completed redirect to interview page else landed to Application page.
        for(Contact checkContactStatus :checkcontactApplicationList) {
            if(checkContactStatus.is_Application__c == 'Submit' && orientationStatus == 'Completed') {
                applicationStatus = 'InProgress';
                gotoPage = 'Application_VF';             
            } else if(checkContactStatus.is_Application__c == 'Approved' && orientationStatus == 'Completed') {
                applicationStatus = 'Completed';
                gotoPage = 'VolunteerInterview_VF';
            }
        }
        // If interview completed, will land to BackgroundCheck page else redirect to interview page.
        if(checkInterviewList.size()>0 && applicationStatus == 'Completed') {
            interviewStatus = 'Completed';
            if(bgRequired == true)
                gotoPage = 'BackgroundCheck_VF';
            else
                gotoPage = 'VolunteerTraining_VF';
        }
        else if(checkInterviewList.size() == 0 && applicationStatus == 'Completed') {
            interviewStatus = 'InProgress';
            gotoPage = 'VolunteerInterview_VF';
        }
        
        // If background check completed, user will redirect to Training page. Else redirect to Background check page itself.
        for(Background_check__c checkBackground : checkBackGroundList) {
            if((checkBackground.Status__c == ''|| checkBackground.Status__c == null) && interviewStatus == 'Completed') {
                backgroundCheckStatus = 'InProgress';
                if(bgRequired == true)
                    gotoPage = 'BackgroundCheck_VF';
            } else if((checkBackground.Status__c == 'Approved' || checkBackground.Status__c == 'Approved w/ Conditions') && interviewStatus == 'Completed' ) {
                backgroundCheckStatus = 'Completed';
                if(trainingRequired == true)
                    gotoPage = 'VolunteerTraining_VF';
            }
        }
        
        for(Volunteer_Orientation_Training__c checkOrientationStatus : trainingList) {
            if(checkOrientationStatus.Volunteer_Attendance__c == 'Registered' && (backgroundCheckStatus == 'Completed' || bgRequired == false ) && trainingRequired == true) {
                trainingStatus = 'InProgress';
                gotoPage = 'VolunteerTraining_VF';
            } else if((checkOrientationStatus.Volunteer_Attendance__c == 'Completed') && (backgroundCheckStatus == 'Completed' || bgRequired == false) && trainingRequired == true ) {
                trainingStatus = 'Completed';
                gotoPage = 'VolunteerTraining_VF';
            }
        } 
    }
    
    // Fetching Top 4 Events of the volunteer chapter and display on the landing page. 
  /*  public list<NonWishEvents> getEvents() {
        eventsRTId = Schema.Sobjecttype.Non_Wish_Events__c.getRecordTypeInfosByName().get(constant.events).getRecordTypeId();
        List<NonWishEvents> eventRecords = new List<NonWishEvents>();
        for(Non_Wish_Events__c  currRec : [SELECT id,Name,Event_Name__c, Priority__c,Event_Image__c,Event_Text__c,Event_Date__c
                                                 FROM Non_Wish_Events__c  WHERE chapter__c = :chapterId AND Event_Date__c >= :Date.Today() AND RecordTypeId = :eventsRTId AND priority__c != Null order by priority__c ASC limit 4])
         
        {
        
           eventRecords.add(new  NonWishEvents(currRec.Event_Image__c,currRec.Event_Name__c,currRec.Event_Date__c,currRec.Event_Text__c));
        }                                        
      
      
        if(eventRecords.size() < 4)
        {
            for(Non_Wish_Events__c  currRec : [SELECT id,Name,Event_Name__c, Priority__c,Event_Image__c,Event_Text__c,Event_Date__c
                                               FROM Non_Wish_Events__c  WHERE chapter__c = :chapterId AND Event_Date__c >= :Date.Today() AND RecordTypeId = :eventsRTId AND priority__c = Null limit 4])
            {
                
                if(eventRecords.size() < 4)
                    eventRecords.add(new  NonWishEvents(currRec.Event_Image__c,currRec.Event_Name__c,currRec.Event_Date__c,currRec.Event_Text__c));
            }
        }
        return eventRecords;
    } */
    
     //This method is used to display top 4 events of that chapter.
    public list<Non_Wish_Events__c> getEvents() {
        eventsRTId = Schema.Sobjecttype.Non_Wish_Events__c.getRecordTypeInfosByName().get(constant.events).getRecordTypeId();
        List<Non_Wish_Events__c> eventRecords = [SELECT id,Name,Event_Name__c, Priority__c,Event_Image__c,Event_Text__c,Event_Date__c
                                                 FROM Non_Wish_Events__c  WHERE chapter__c = :chapterId AND Event_Date__c >= :Date.Today() AND RecordTypeId = :eventsRTId AND priority__c != Null order by priority__c ASC limit 4];
      
        if(eventRecords.size() < 4)
        {
          for(Non_Wish_Events__c  currRec : [SELECT id,Name,Event_Name__c, Priority__c,Event_Image__c,Event_Text__c,Event_Date__c
                                               FROM Non_Wish_Events__c  WHERE chapter__c = :chapterId AND Event_Date__c >= :Date.Today() AND RecordTypeId = :eventsRTId AND priority__c = Null limit 4])
          {
           
            if(eventRecords.size() < 4)
                eventRecords.add(currRec);
           
          }
        }
        return eventRecords;
        
    } 
    
    // If the clicks Become A Volunteer / Continue Process, Based on the page status, they will redirect to the next page 
    // in the prospective volunteer portal.
    public pagereference becomeAVolunteer(){
        PageReference pageRef = new PageReference('/apex/'+gotoPage+'?bgRequired='+bgRequired+'&trainingRequired='+trainingRequired);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public class NonWishEvents
    {
       public string eventImage{get;set;}
       public string eventName{get;set;}
       public Date eventDate{get;set;}
       public string eventText{get;set;}
       
       public NonWishEvents(string eImage, string eName, Date eDate, string eText)
       {
           eventImage = eImage;
           eventName = eName;
           eventDate = eDate;
           eventText = eText;
       }
       
    
    }
}