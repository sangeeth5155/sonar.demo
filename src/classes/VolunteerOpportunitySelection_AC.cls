/*********************************************************************************
Description : It will display volunteer opportunity list for enrolling time sheet for the wish.

*********************************************************************************/

Public Class VolunteerOpportunitySelection_AC{

    public List<volunteerWrapper> volunteerWrapperList{get;set;}
    public Id caseId;
    public Integer i = 0;
    public VolunteerOpportunitySelection_AC(){ 
      volunteerWrapperList = new List<volunteerWrapper>();
      caseId =  ApexPages.currentPage().getParameters().get('caseRecId') ;
      List<User>  currentUserContactId = [SELECT Id,ContactId From User WHERE Id =: UserInfo.getUserId() AND ContactId != Null Limit 1];
      for(Volunteer_Opportunity__c dbVolOppRec : [SELECT Id,Name,Wish__c,Volunteer_Name__c,Volunteer_Name__r.Name,Chapter_Name__c,Chapter_Name__R.Name,Role__c FROM Volunteer_Opportunity__c 
                                    WHERE volunteer_Name__c != Null AND Volunteer_Name__c =: currentUserContactId[0].ContactId 
                                    AND Wish__c =: caseId AND Status__c = 'Approved']){
          volunteerWrapper newWrapIns = new volunteerWrapper();
          newWrapIns.recordSelected = false;
          newWrapIns.volOpp = dbVolOppRec;
          volunteerWrapperList.add(newWrapIns );
          }
        
        if(volunteerWrapperList.size() == 1)
        CreateNewTimeSheet();
        
    }
   
    public pageReference createTimeSheet(){
    
        String OpportunityName;
        String OpportunityId;
        String caseId;
        
        PageReference  pageRef;
        if(volunteerWrapperList.size() > 1){
        for(volunteerWrapper processvolunteerWrapperRec : volunteerWrapperList){
        System.debug('@@@@@ volunteerWrapperList SIZE 2 @@@@'+volunteerWrapperList);
               if(processvolunteerWrapperRec.recordSelected == true){
                  i++;
                  OpportunityName = processvolunteerWrapperRec.volOpp.Name; 
                  OpportunityId = processvolunteerWrapperRec.volOpp.Id;
                  CaseId = processvolunteerWrapperRec.volOpp.Wish__c;
              } 
        }
        if(i > 0 && i == 1){
        String OpportunityFieldId= label.Volunteer_Opportunity_Id;
        String objectId = Time_Sheet__c.sobjecttype.getDescribe().getKeyPrefix();
        pageRef =  new PageReference('/'+objectId+'/e?'+OpportunityFieldId+'='+OpportunityName+'&'+OpportunityFieldId+'_lkid='+OpportunityId+'&retURL='+CaseId);
        }
        if(i == 0){
            DisplayError();
        }
        
        if(i > 1){
         DisplayError();
        }
        }
       
        return pageRef ;
    }
    
    public pageReference CreateNewTimeSheet(){
        String OpportunityName;
        String OpportunityId;
        String caseId;
         PageReference  pageRef;
        if(volunteerWrapperList.size() == 1){
        System.debug('@@@@@ volunteerWrapperList SIZE 1 @@@@'+volunteerWrapperList);
            for(volunteerWrapper processvolunteerWrapperRec : volunteerWrapperList){
               
                  OpportunityName = processvolunteerWrapperRec.volOpp.Name; 
                  OpportunityId = processvolunteerWrapperRec.volOpp.Id;
                  CaseId = processvolunteerWrapperRec.volOpp.Wish__c;
               
        }
        String OpportunityFieldId= label.Volunteer_Opportunity_Id;
        String objectId = Time_Sheet__c.sobjecttype.getDescribe().getKeyPrefix();
        pageRef = new PageReference('/'+objectId+'/e?'+OpportunityFieldId+'='+OpportunityName+'&'+OpportunityFieldId+'_lkid='+OpportunityId+'&retURL='+CaseId);
        }
        
        return pageRef ;
    }
    
    Public pageReference DisplayError(){
        if(i == 0)
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select any one volunteer opportunity.'));
        if(i > 1)
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select only one volunteer opportunity.'));
        
        return null;
    }
    
    
    public class volunteerWrapper{
        
        public boolean recordSelected{get;set;}
        public Volunteer_Opportunity__c volOpp{get;set;}
        
    }
    
   
}