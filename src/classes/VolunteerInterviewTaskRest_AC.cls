@RestResource (urlMapping='/orientation/*')
global class VolunteerInterviewTaskRest_AC
{
    @HttpGet
    global static List<Task> getClassOffering()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/');
        String contactId = uriKeys.get(uriKeys.size()-1);
        List<Task> taskList = new List<Task>();
        Constant_AC  constant = new Constant_Ac(); 
        System.debug('contactId ++++++++++++++++++++++++++++++++++++++ ' + contactId);
       
        Id  interviewRT= Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.interviewRT).getRecordTypeId();
       
          taskList  =        [SELECT id,Available_Date1__c, Available_Date2__c, Available_Date3__c,  Available_Time1__c,venue__c,
                             Available_Time2__c, Available_Time3__c, Subject, Status,
                             Confirmed_Time__c, Confirmed_Date__c, Availability_Time_Other1__c,Availability_Time_Other2__c,
                             Availability_Time_Other3__c FROM Task 
                             WHERE 
                             whoId =:contactId AND Subject = 'Interview Task' 
                             AND RecordTypeId = :interviewRT  Order by CreatedDate DESC limit 1]; 
          System.debug('taskList++++++++++++++++++++++++++++++++++++++ ' + taskList);
                              
        return taskList;                          
    }

}