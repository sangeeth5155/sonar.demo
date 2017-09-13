global class batch_UpdatLastEduDate implements Database.Batchable<AggregateResult>{ 

  
     
    
     global Iterable<AggregateResult> start(Database.BatchableContext bc){ 
     
         list<AggregateResult> volunteerOppList = [SELECT Volunteer__c FROM Volunteer_Orientation_Training__c 
                                                     WHERE RE_Completed_Date__c !=Null
                                                     AND Volunteer__c != Null AND Type__c = 'Training' 
                                                     AND Migrated_Record__c = True
                                                     GROUP BY Volunteer__c];
        
         return volunteerOppList;                      
                                
     }
     
    
     global void execute(Database.BatchableContext bc, list<AggregateResult> scope)
     {
           Set<Id> volunteerIds = new Set<Id>();
           for(AggregateResult currVol : scope)
           {
              volunteerIds.add(String.valueOf(currVol.get('Volunteer__c')));
           }  
           
           Map<Id,Date> volunteerTrainedDate = new Map<Id,Date>();
           for(Volunteer_Orientation_Training__c currRec : [SELECT Id, RE_Completed_Date__c,Volunteer__c FROM Volunteer_Orientation_Training__c 
                                                            WHERE RE_Completed_Date__c !=Null AND Volunteer__c IN :volunteerIds
                                                            AND Volunteer__c != Null AND Type__c = 'Training' AND Migrated_Record__c = True])
           {
             string dateVal = currRec.RE_Completed_Date__c.subString(0,10);
             if(volunteerTrainedDate.containsKey(currRec.Volunteer__c))
             {
                if(volunteerTrainedDate.get(currRec.Volunteer__c) < Date.valueOf(dateVal)) 
                  volunteerTrainedDate.put(currRec.Volunteer__c,Date.valueOf(dateVal));
                     
             }
             else
                 volunteerTrainedDate.put(currRec.Volunteer__c,Date.valueOf(dateVal));
                
           }
           
           List<Contact> updateContacts = new List<Contact>();
           
           for(String currId : volunteerTrainedDate.KeySet())
           {
               Contact currContact = new Contact();
               currContact.id = currId;
               currContact.Last_Continuing_Edu_Date__c = volunteerTrainedDate.get(currId);
               currContact.Date_of_last_engagement__c = volunteerTrainedDate.get(currId);
               updateContacts.add(currContact);
           }
           
           if(updateContacts.size() > 0)
               update updateContacts;
           
       }


      global void finish(Database.BatchableContext bc)
      {
      
      }


}