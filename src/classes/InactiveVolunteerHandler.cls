Public class  InactiveVolunteerHandler{
@future
    public Static void createTaskforVolunteerManager(Set<Id> userList){
        
        Map<Id,Id> volunteerManagerId = new Map<Id,Id>();
        List<Volunteer_Opportunity__c> VolunteerOpportunityActive=new List<Volunteer_Opportunity__c>([SELECT id,Chapter_Name__r.Volunteer_Manager__c,Volunteer_Name__c  FROM Volunteer_Opportunity__c WHERE Volunteer_Name__c IN: userList AND Inactive__c =False]);
        for(Volunteer_Opportunity__c  currRec:VolunteerOpportunityActive){
               volunteerManagerId.put(currRec.Volunteer_Name__c,currRec.Chapter_Name__r.Volunteer_Manager__c);
               system.debug('*********'+currRec.Volunteer_Name__c+'*****');
        }
        if(volunteerManagerId.size() >0){
            List<Task> ActiveTask=new List<Task>();
            Task newTask;
            for(Id currRec:volunteerManagerId.keyset()){
                    newTask=new Task();
                    newTask.OwnerId=volunteerManagerId.get(currRec);
                    newTask.WhoId=currRec;
                    newTask.Subject='Inactive Volunteer - review volunteer opportunities';
                    ActiveTask.add(newTask);
                    system.debug('@@@@@@@@@@@'+currRec+'*****');     
            }
            Insert ActiveTask;
        }
       // updateBCandCOIVolunteerInactive(userList,True);
    }
    
   
     @future
     public static void updateBCandCOIVolunteerInactive(Set<Id> inactiveVolunteerIdSet,Boolean isInactiveVolunteer){
            List<Background_check__c> updateBCList = New List<Background_check__c>();
            List<Conflict_Of_Interest__c> updateCOIList = New List<Conflict_Of_Interest__c>();
            for(Background_check__c currBC : [SELECT Id,Volunteer_is_Inactive__c FROM Background_check__c WHERE Volunteer__c IN :inactiveVolunteerIdSet AND Volunteer_is_Inactive__c !=: isInactiveVolunteer]){
                currBc.Volunteer_is_Inactive__c = isInactiveVolunteer;
                updateBCList.add(currBc);
            }
            
            if(updateBCList.Size() > 0){
                 Update updateBCList;
            }
            for(Conflict_Of_Interest__c currCOI : [SELECT Id,Volunteer_is_Inactive__c FROM Conflict_Of_Interest__c WHERE Volunteer_Contact__c IN : inactiveVolunteerIdSet AND Volunteer_is_Inactive__c !=: isInactiveVolunteer]){
                currCOI.Volunteer_is_Inactive__c = isInactiveVolunteer;
                updateCOIList.add(currCOI);
            }
            if(updateCOIList.Size() > 0){
                Update updateCOIList;
            }
        
    }
    
    
}