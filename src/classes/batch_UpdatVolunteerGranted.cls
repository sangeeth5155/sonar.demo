global class batch_UpdatVolunteerGranted implements Database.Batchable<AggregateResult>{ 

  
     
    
     global Iterable<AggregateResult> start(Database.BatchableContext bc){ 
     
         list<AggregateResult> volunteerOppList = [SELECT Volunteer_Name__c FROM Volunteer_Opportunity__c
                                 where Wish__c != Null and Volunteer_Name__c !=Null AND Migrated_Record__c = True 
                                 group by Volunteer_Name__c];
        
         return volunteerOppList;                      
                                
     }
     
    
     global void execute(Database.BatchableContext bc, list<AggregateResult> scope)
     {
     
           Set<Id> volunteerIds = new Set<Id>();
           for(AggregateResult currVol : scope)
           {
              volunteerIds.add(String.valueOf(currVol.get('Volunteer_Name__c')));
           }  
           
           
           Map<Id,integer> grantedCount = new Map<Id,integer>();
           Map<Id,integer> activeCount = new Map<Id,integer>();
           for(Volunteer_Opportunity__c currRec : [SELECT Id,Wish__c, Wish__r.Status,Wish__r.isClosed,Volunteer_Name__c FROM Volunteer_Opportunity__c
                                                   WHERE Wish__c != Null AND Migrated_Record__c = True AND
                                                   ((Wish__r.Status='Granted' OR wish__r.isClosed=True OR wish__r.status='Completed') OR (Wish__r.Status != 'Granted' 
                                                   AND Wish__r.isClosed=false 
                                                   AND Wish__r.Status != 'inActive'))
                                                   AND Volunteer_Name__c IN :volunteerIds])
           {
              if(currRec.Wish__r.Status=='Granted' || currRec.Wish__r.isClosed==True || currRec.Wish__r.Status=='Completed')
              {
                 if(grantedCount.containsKey(currRec.Volunteer_Name__c))
                 {
                       integer countVal = grantedCount.get(currRec.Volunteer_Name__c)+1;
                       grantedCount.put(currRec.Volunteer_Name__c,countVal);
                 }
                 else
                 {    
                       grantedCount.put(currRec.Volunteer_Name__c,1);
                 }
                     
              }
              
              else
              {
                 if(activeCount.containsKey(currRec.Volunteer_Name__c))
                 {
                       integer countVal = activeCount.get(currRec.Volunteer_Name__c)+1;
                       activeCount.put(currRec.Volunteer_Name__c,countVal);
                 }
                 else
                 {    
                       activeCount.put(currRec.Volunteer_Name__c,1);
                 }
              }
           } 
           
           List<Contact> updateContacts = new List<Contact>();
           for(String currVolId : volunteerIds)
           {
              contact currCon = new Contact();
              currCon.id = currVolId;
              currCon.Number_of_wishes_active__c = activeCount.get(currVolId);
              currCon.Number_of_wishes_granted__c = grantedCount.get(currVolId);
              if(currCon.Number_of_wishes_active__c ==Null)
                  currCon.Number_of_wishes_active__c =0;
              if(currCon.Number_of_wishes_granted__c == Null)
                  currCon.Number_of_wishes_granted__c =0;
              
              updateContacts.add(currCon);
           }
           
           if(updateContacts.size() > 0)
             update updateContacts;
             
     }


  global void finish(Database.BatchableContext bc){
  }


}