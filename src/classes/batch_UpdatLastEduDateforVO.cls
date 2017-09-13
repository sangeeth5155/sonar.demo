global class batch_UpdatLastEduDateforVO implements Database.Batchable<AggregateResult>{ 

  
     
    
     global Iterable<AggregateResult> start(Database.BatchableContext bc){ 
     
         list<AggregateResult> volunteerOppList = [SELECT Volunteer_Name__c FROM Volunteer_Opportunity__c
                                                  WHERE Migrated_Record__c = True
                                                  AND Volunteer_Name__c != Null AND Volunteer_Name__r.Migrated_Record__c = True
                                                  GROUP BY Volunteer_Name__c];
        
         return volunteerOppList;                      
                                
     }
     
    
     global void execute(Database.BatchableContext bc, list<AggregateResult> scope)
     {
           Set<Id> volunteerIds = new Set<Id>();
           for(AggregateResult currVol : scope)
           {
              volunteerIds.add(String.valueOf(currVol.get('Volunteer_Name__c')));
           }  
           
           Map<Id,Date> volunteerTrainedDate = new Map<Id,Date>();
           for(Volunteer_Opportunity__c currRec : [SELECT Id, Volunteer_Name__c,createdDate,Volunteer_Name__r.Date_of_last_engagement__c
                                                            FROM Volunteer_Opportunity__c
                                                            WHERE Migrated_Record__c = True
                                                            AND Volunteer_Name__c != Null AND Volunteer_Name__c IN :volunteerIds
                                                            AND Volunteer_Name__r.Migrated_Record__c = True])
           {
            
                 if(currRec.createdDate > currRec.Volunteer_Name__r.Date_of_last_engagement__c)
                  {
                    if(volunteerTrainedDate.containsKey(currRec.Volunteer_Name__c))
                    {
                       if(currRec.CreatedDate >  volunteerTrainedDate.get(currRec.Volunteer_Name__c))
                          volunteerTrainedDate.put(currRec.Volunteer_Name__c,Date.valueOf(currRec.createdDate));
                    }
                    else
                      volunteerTrainedDate.put(currRec.Volunteer_Name__c,Date.valueOf(currRec.createdDate));
                    
                  } 
           }
           
           List<Contact> updateContacts = new List<Contact>();
           for(Id currVolId : volunteerTrainedDate.keySet())
           {
               contact currContact = new Contact();
               currContact.id = currVolId;
               currContact.Date_of_last_engagement__c = volunteerTrainedDate.get(currVolId);
               updateContacts.add(currContact);
           }
          
           if(updateContacts.size() > 0)
               update updateContacts;
           
       }


      global void finish(Database.BatchableContext bc)
      {
      
      }


}