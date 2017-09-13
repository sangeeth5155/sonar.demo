/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Chandrasekar Nallusamy
Date        : 5/23/2016
Description : This controller referred in the BackgroundCheck_Vf page. Volunteer will submit their details for Background 
verification.When Volunteer submits Background check, It will create Background check record as well
as Background check task for the chatper staff.
*******************************************************************************************************************/
public class BackgroundCheck_AC{

    Public contact con{get;set;}
    public Background_check__c backGroundCheck{get;set;}
    public boolean statusValue{get;set;}
    public User currUser;
    public String taskRecordTypeId;
    List<Background_check__c> existingBGCheckRecList{get;set;}
    public boolean isBGFinished{get;set;}
    public string residingInPast7Years{get;set;}
    public string whyNeedBGCheck{get;set;}
    public boolean bgTabPermission{get;set;}
    public boolean trainingTabVisible{get;set;}
    public string areYouinUS7Yrs{get;set;}
    Constant_AC constant = new Constant_AC();
    
    public BackgroundCheck_AC()
    {
        currUser=  [SELECT Id,ContactId,contact.account.volunteer_manager__c,Contact.OwnerId FROM User WHERE Id =: userInfo.getUserId() Limit 1];
      //  sysAdmin = [SELECT Id,Name,Email FROM User WHERE Email =: 'furqan@mstsolutions.com' Limit 1];
        backGroundCheck = new Background_check__c();
        existingBGCheckRecList = [SELECT Id,Resided_in_US_for_past_7_years__c FROM Background_check__c WHERE VOLUNTEER__c = :currUser.contactId order by CreatedDate DESC];
        if(existingBGCheckRecList.size() > 0) {
            isBGFinished = true;
            residingInPast7Years = existingBGCheckRecList[0].Resided_in_US_for_past_7_years__c;
        }
        String nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.nationalRT).getRecordTypeId();
         
        List<Dynamic_Content__c> currContent = [SELECT Id, Why_Need_Background_Check__c FROM Dynamic_Content__c 
                                               WHERE RecordTypeId = :nationalRT AND Active__c = true limit 1];
        System.debug('currContent+++++++++++++++++++++++++++ ' + currContent);
        if(currContent.size() > 0)
            whyNeedBGCheck =currContent[0].Why_Need_Background_Check__c;
        // Based on the parameter value, It would display Background tab.
        if(ApexPages.currentPage().getParameters().get('bgRequired') != Null)
                bgTabPermission = Boolean.valueOf(ApexPages.currentPage().getParameters().get('bgRequired'));     
        if(ApexPages.currentPage().getParameters().get('trainingRequired') != Null)
                trainingTabVisible = Boolean.valueOf(ApexPages.currentPage().getParameters().get('trainingRequired'));   
    
    }
   
    //This method used to create backgroundcheck and task record under the current logged in user contact
    public PageReference saveRec()
    {
        backGroundCheck.Date_Requested__c = system.today();
        backGroundCheck.Volunteer__c = currUser.ContactId; 
      //  backGroundCheck.Requested_By__c = sysAdmin.Id;
        backGroundCheck.Resided_in_US_for_past_7_years__c = areYouinUS7Yrs;
        backGroundCheck.OwnerId = currUser.contact.OwnerId;
        if(backGroundCheck.Resided_in_US_for_past_7_years__c == Null) {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please select a value for: Have you resided in the US for the past 7 years?'));
        }
        else{
            statusValue = true;
            if(backGroundCheck.id <> NULL)
                backGroundCheck.id = NULL;
                 
            insert backGroundCheck;
            
            Constant_AC  constant = new Constant_Ac();
            taskRecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.backgroundRT).getRecordTypeId();
            Task newBGTask = new Task();
            newBGTask.Type = 'Email';
            newBGTask.Description = ''; 
            if(currUser.contact.account != Null)
            {
               if(currUser.contact.account.volunteer_manager__c != Null)
                newBGTask.OwnerId = currUser.contact.account.volunteer_manager__c;
            }
            else
                newBGTask.OwnerId = currUser.Contact.OwnerId;
               
            newBGTask.WhoId = currUser.ContactId; 
            newBGTask.whatId = backGroundCheck.id;
            newBGTask.Subject = 'Background Check';
            newBGTask.RecordTypeId = taskRecordTypeId;
            if(!Test.isRunningTest())
               insert newBGTask;
            
            Contact updateContact = new Contact();
            updateContact.id = currUser.contactId;
            updateContact.Onboarding_Status__c = 'Background Check';
            update updateContact;
            
            PageReference pageRef = new PageReference('/apex/BackgroundCheck_VF?bgRequired='+bgTabPermission+'&trainingRequired='+trainingTabVisible);
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }

      public List<SelectOption> getResidedValues(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  BackGround_Check__c.Resided_in_US_for_past_7_years__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Select')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
      }   

}