global class batch_UpdatAffiliationStatus implements Database.Batchable<AggregateResult>{ 

  
     
    
     global Iterable<AggregateResult> start(Database.BatchableContext bc)
     { 
     
         list<AggregateResult> volunteerOppList = [Select npe5__Contact__c from npe5__Affiliation__c WHERE 
                                                   npe5__Contact__r.Recordtype.name = 'Volunteer Contact' 
                                                   and npe5__Status__c != 'Inactive'
                                                   AND Constituent_Code__c = 'Volunteer'
                                                   AND Hidden_Status_Updated__c = false 
                                                   AND npe5__Organization__r.Recordtype.name = 'Chapter'
                                                   AND Migrated_Record__c = True 
                                                   GROUP BY npe5__Contact__c];
        
         System.debug('volunteerOppList++++++++++++++++++++++++++= ' + volunteerOppList);
         return volunteerOppList;                      
                                
                                
     }
     
    
     global void execute(Database.BatchableContext bc, list<AggregateResult> scope)
     {
           Set<Id> volunteerIds = new Set<Id>();
           Map<id,String> volunteerRoleMap = new Map<Id, String>();
           Set<Id> bcgAvailable = new Set<Id>();
           Map<Id, Background_check__c> validBCG  = new Map<Id, Background_check__c>();
           Map<Id, Conflict_Of_Interest__c> validCOI  = new Map<Id, Conflict_Of_Interest__c>();
           
            System.debug('in++++++++++++++++++++++++++= ' );
           for(AggregateResult currVol : scope)
           {
              volunteerIds.add(String.valueOf(currVol.get('npe5__Contact__c')));
              System.debug('volunteerIds++++++++++++++++++++++++++= ' + volunteerIds);
           }  
           
           
           for(Background_check__c currRec : [SELECT id,Volunteer__c,Date__c FROM Background_check__c WHERE volunteer__c IN : volunteerIds])
           {
                bcgAvailable.add(currRec.volunteer__c);
                
                if(currRec.Date__c > = Date.today())
                  validBCG.put(currRec.Volunteer__c,currRec);
           }
           
           for(Conflict_Of_Interest__c currRec : [SELECT id,Volunteer_Contact__c, Expiration_Date__c FROM Conflict_Of_Interest__c 
                                                  WHERE Expiration_Date__c >= :Date.Today() AND Volunteer_Contact__c IN :volunteerIds])
           {
                 validCOI.put(currRec.Volunteer_Contact__c, currRec);
           }
           
           
           for(Volunteer_Roles__c currContact : [SELECT Id, Status__c, Volunteer_Name__c FROM  Volunteer_Roles__c 
                                                   WHERE Volunteer_Name__c  IN :volunteerIds])
           {
                if(volunteerRoleMap.containsKey(currContact.Volunteer_Name__c))
                {
                        if(volunteerRoleMap.get(currContact.Volunteer_Name__c) != 'Trained')
                          volunteerRoleMap.put(currContact.Volunteer_Name__c, currContact.Status__c);
                
                }
                else
                    volunteerRoleMap.put(currContact.Volunteer_Name__c, currContact.Status__c);
           }
           
           List<npe5__Affiliation__c> affList = new List<npe5__Affiliation__c>();
           
           for(npe5__Affiliation__c  currAffiliation : [Select Id, npe5__Contact__c from npe5__Affiliation__c WHERE 
                                                       npe5__Contact__r.Recordtype.name = 'Volunteer Contact' 
                                                       and npe5__Status__c != 'Inactive' 
                                                       AND Constituent_Code__c = 'Volunteer'
                                                       AND npe5__Organization__r.Recordtype.name = 'Chapter'
                                                       AND npe5__Contact__c IN :volunteerIds
                                                       AND Migrated_Record__c = True
                                                       AND Hidden_Status_Updated__c = false])
           {
           
             System.debug('currAffiliation++++++++++++++++++++++++++= ' + currAffiliation);
           
                   npe5__Affiliation__c currAff = new npe5__Affiliation__c();
                   currAff.id = currAffiliation.id;
                   if(volunteerRoleMap.get(currAffiliation.npe5__Contact__c) == 'Trained' && validCOI.containsKey(currAffiliation.npe5__Contact__c) )
                   {
                     
                      if(bcgAvailable.contains(currAffiliation.npe5__Contact__c))
                        {
                          if(validBCG.containsKey(currAffiliation.npe5__Contact__c))
                             currAff.npe5__Status__c = 'Active';
                          else
                             currAff.npe5__Status__c = 'Inactive';
                        }
                      else
                           currAff.npe5__Status__c = 'Active';
                   }
                   else if(volunteerRoleMap.get(currAffiliation.npe5__Contact__c) != 'Trained' && validCOI.containsKey(currAffiliation.npe5__Contact__c) )
                   {
                        if(bcgAvailable.contains(currAffiliation.npe5__Contact__c))
                        {
                          if(validBCG.containsKey(currAffiliation.npe5__Contact__c))
                             currAff.npe5__Status__c = 'Pending';
                          else
                             currAff.npe5__Status__c = 'Inactive';
                        }
                      else
                           currAff.npe5__Status__c = 'Pending';
                   
                   }
                   else
                       currAff.npe5__Status__c = 'Inactive';
                   currAff.Hidden_Status_Updated__c = true;
                   affList.add(currAff);
           }
           
           if(affList.size() > 0)
                   update affList;
           
     }


      global void finish(Database.BatchableContext bc)
      {
      
      }


}