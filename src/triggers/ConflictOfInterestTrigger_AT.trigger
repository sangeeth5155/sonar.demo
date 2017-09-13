/*******************************************************************************
Description : Mapping fields from Contact to Conflict Of Interest. These fields are mail merge fields in email template.
*********************************************************************************/

trigger ConflictOfInterestTrigger_AT on Conflict_Of_Interest__c (before insert,before update,after update,after insert) {
    
    if((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isupdate))
    {
        Set<Id> volContactIdSet = new Set<Id>();
        Map<Id,Contact> conMap = new Map<Id, Contact>();
        for(Conflict_Of_Interest__c newCOI : Trigger.new){
                if(newCOI.Account_Name__c == Null || newCOI.Account_Phone__c == Null || newCOI.Hidden_Volunteer_Contact_Email__c == Null)
                volContactIdSet.add(newCOI.Volunteer_Contact__c);
        }
        
        for(Contact VoluContact : [SELECT Id,Email,AccountId,OwnerId,Region_Chapter__r.Name,Region_Chapter__r.Phone,Region_Chapter__r.Email__c,Region_Chapter__c FROM Contact WHERE Id IN : volContactIdSet]){
            conMap.put(VoluContact.Id,VoluContact);
        }
        
        for(Conflict_Of_Interest__c newCOI : Trigger.new){
            if(conMap.containsKey(newCOI.Volunteer_Contact__c)){
                newCOI.Account_Name__c = conMap.get(newCOI.Volunteer_Contact__c).Region_Chapter__r.Name;
                newCOI.Account_Phone__c= conMap.get(newCOI.Volunteer_Contact__c).Region_Chapter__r.Phone;
                newCOI.Hidden_Volunteer_Contact_Email__c = conMap.get(newCOI.Volunteer_Contact__c).Email;
                newCOI.Account_Email__c = conMap.get(newCOI.Volunteer_Contact__c).Region_Chapter__r.Email__c;
                newCOI.ownerId = conMap.get(newCOI.Volunteer_Contact__c).OwnerId;
            }
            
            if(newCOI.Signed_Date__c != Null && (Trigger.isInsert || (Trigger.isUpdate && newCOI.Signed_Date__c != Trigger.oldMap.get(newCOI.id).Signed_Date__c)))
            {
                newCOI.Expiration_Date__c = newCOI.Signed_Date__c.addYears(1);
                if(newCOI.current__c == False)
                   newCOI.current__c = True;
            }
        }
     }
     
     if(Trigger.isInsert && Trigger.isAfter)
     {
         Set<Id> recordIds = new Set<Id>();
         Set<Id> volunteerIds = new Set<Id>();
         Set<Id> ownerIds = new Set<Id>();
         List<Contact> updateVolunteerContact = new List<Contact>();
         Contact updateCon;
         for(Conflict_Of_Interest__c  currCOI : Trigger.new)
         {
            if(currCOI.current__c == True)
            {
                recordIds.add(currCOI.Id);
                volunteerIds.add(currCOI.Volunteer_Contact__c);
            }
            
             ownerIds.add(currCOI.ownerId);
             
             if(currCOI.Expiration_Date__c != Null && currCOI.Volunteer_Contact__c  != Null){
                 //updateVolunteerContact.add(curr);
                  updateCon = new Contact();
                  updateCon.Id = currCOI.Volunteer_Contact__c;
                  updateCon.COI_Expiration_Date__c = currCOI.Expiration_Date__c;
                  updateVolunteerContact.add(updateCon);
             }
        
         }
         
         
        if(volunteerIds.size() > 0 && recordIds.size() > 0)
        {
          UpdateExistingRecords(recordIds,volunteerIds);
        }
        
        if(updateVolunteerContact.Size() > 0)
            Update updateVolunteerContact;
        
        if(ownerIds.size() > 0)
            COIRecordSharing(ownerIds,Trigger.new);
     
     }
     
     // Updating COI Expiration Date on Volunteer Contact.
     if(Trigger.isAfter && Trigger.isUpdate)
     {
       List<Contact> updateVolunteerContact = new List<Contact>();
       Set<Id> recordIds = new Set<Id>();
       Set<Id> volunteerIds = new Set<Id>();
       Set<Id> ownerIds = new Set<Id>();
       Set<Id> volunteerContactIdSet = new Set<Id>();
        for(Conflict_Of_Interest__c  currCOI : Trigger.new)
        {
           if(currCOI.Expiration_Date__c  != Trigger.oldMap.get(currCOI.id).Expiration_Date__c && currCOI.Expiration_Date__c != Null)
           {
                if(currCOI.Volunteer_Contact__c != Null)
                {
                   Contact updateVolunteer = new Contact();
                   updateVolunteer.Id = currCOI.Volunteer_Contact__c;
                   updateVolunteer.COI_Expiration_Date__c = currCOI.Expiration_Date__c;
                   updateVolunteerContact.add(updateVolunteer);
                }
           }
           
           if(currCOI.HiddenConflictExpire__c == true && trigger.oldMap.get(currCOI.Id).HiddenConflictExpire__c  == false){
               volunteerContactIdSet.add(currCOI.Volunteer_Contact__c);
           }
           
           if(currCOI.current__c == True && Trigger.oldMap.get(currCOI.id).current__c == False)
            {
                recordIds.add(currCOI.Id);
                volunteerIds.add(currCOI.Volunteer_Contact__c);
                
            }
            
            if(currCOI.ownerId != Trigger.oldMap.get(currCOI.id).OwnerId)
                ownerIds.add(currCOI.ownerId);
                
              
        }
        
        
        if(updateVolunteerContact.size() > 0)
          update updateVolunteerContact;
          
        if(ownerIds.size() > 0)
            COIRecordSharing(ownerIds,Trigger.new);  
          
        if(volunteerIds.size() > 0 && recordIds.size() > 0)
        {
          UpdateExistingRecords(recordIds,volunteerIds);
        }
        
        if(volunteerContactIdSet.size() > 0)
         BackGroundCheckTriggerHandler.UpdateVOppAndVRoleStatus(volunteerContactIdSet,'COI');
     }
     
     
     Static Void COIRecordSharing(Set<Id> ownerIds, List<Conflict_Of_Interest__c> coiList)
     {
         Map<Id,String> userRoleMap = UserRoleUtility.getUserRole(ownerIds);
         Map<String, List<Conflict_Of_Interest__c>> coiMap = new Map<String, List<Conflict_Of_Interest__c>>();
         
         for(Conflict_Of_Interest__c currCOI : coiList)
         {
             if(currCOI.Account_Name__c != Null && userRoleMap.get(currCOI.OwnerId) == 'National Staff')
              {
                   if(coiMap.containsKey(currCOI.Account_Name__c))
                    {
                        coiMap.get(currCOI.Account_Name__c).add(currCOI);
                    }
                    else
                        coiMap.put(currCOI.Account_Name__c, new List<Conflict_Of_Interest__c>{currCOI});
                            
                 
              }
         }
         
         if(coiMap.size() > 0)
             ChapterStaffRecordSharing_AC.COIRecordSharing(coiMap);
     
     
     }
     
      
     
     
     
     Static void UpdateExistingRecords(Set<Id> recordIds, Set<Id> volunteerIds)
     {
         List<Conflict_Of_Interest__c>  recordsToUpdate = new List<Conflict_Of_Interest__c>();
         for(Conflict_Of_Interest__c currRec : [SELECT id from Conflict_Of_Interest__c WHERE Volunteer_Contact__c IN :volunteerIds AND Id NOT IN :recordIds AND current__c = True])
         {
             Conflict_Of_Interest__c newRec = new Conflict_Of_Interest__c();
             newRec.id = currRec.id;
             newRec.current__c = false;
             recordsToUpdate.add(newRec);
             
         }
         
         if(recordsToUpdate.size() > 0)
             update recordsToUpdate;
     }

}