/***************************************************************************
Author : MST Solutions
Created Date : 08/16/2016
Description : It will update the Volunteer Affiliation Status based on the Background status.
If it is approved, Affiliation Status would be updated  as "Pending/Active" based on the Training Required for chatper role.
****************************************************************************/

Public class BackGroundCheckTriggerHandler
{

    // If Interview Task is rejected, then update affiliation status as "Declined".
    public static void UpdateAffiliationStatusToDeclined(Set<Id> rejectedIds)
    {
      List<npe5__Affiliation__c> affiliationList = new List<npe5__Affiliation__c>();
      for(npe5__Affiliation__c dbAffiliationRec : [SELECT Id,npe5__Contact__c,npe5__Primary__c,npe5__Status__c,npe5__Organization__c FROM npe5__Affiliation__c WHERE npe5__Contact__c IN :rejectedIds AND npe5__Status__c != 'Active'])
      {
                    npe5__Affiliation__c  updateRec = new npe5__Affiliation__c();
                    updateRec.npe5__Status__c = 'Declined';
                    updateRec.id = dbAffiliationRec.id;
                    affiliationList.add(updateRec);
      }
                
        if(affiliationList.size() > 0){
            update affiliationList;
        }
    
    }
    
    // If Interview Task is approved, then update affiliation status as "Pending/Active" based on the training required.
    public static void UpdateAffiliationStatusToPending(Set<Id> approvedVolunteerIds)
    {   
        List<npe5__Affiliation__c> updateAffliationList = new List<npe5__Affiliation__c>();
        Set<Id> activeContactIdsSet = new Set<Id>();
        Constant_AC  constant = new Constant_Ac(); 
        Id triainingRecordTypeId = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();  
        Set<Id> orientationTrainingId = new Set<Id>();
        Map<String, Set<String>> volunteerChapterRoleMap = new Map<String, Set<String>>();
        Set<Id> chapterRolesSet = new Set<Id>();
        for(Volunteer_Roles__c currRole : [SELECT Id,Name,Chapter_Role__c,Volunteer_Name__c FROM Volunteer_Roles__c  WHERE Volunteer_Name__c  IN :approvedVolunteerIds])
        {
            chapterRolesSet.add(currRole.Chapter_Role__c);
            if(volunteerChapterRoleMap.containsKey(currRole.Volunteer_Name__c))
                volunteerChapterRoleMap.get(currRole.Volunteer_Name__c).add(currRole.Chapter_Role__c); 
            else
                volunteerChapterRoleMap.put(currRole.Volunteer_Name__c, new Set<String>{currRole.Chapter_Role__c}); 
        }
            
        Set<String> chapterRoleOandTsSet = new Set<String>();
        Map<String,Conflict_Of_Interest__c> coiMap = new Map<String,Conflict_Of_Interest__c>();
            
        for(Chapter_Role_O_T__c currChapterRole : [SELECT Id,Name,Orientation_Training__c,Orientation_Training__r.RecordTypeId,Required__c,Chapter_Role__c FROM Chapter_Role_O_T__c WHERE Chapter_Role__c IN :chapterRolesSet AND Required__c = TRUE AND Orientation_Training__r.RecordTypeId =:triainingRecordTypeId])
        {
            chapterRoleOandTsSet.add(currChapterRole.Chapter_Role__c);
        }
            
        for(Conflict_Of_Interest__c currCOI : [SELECT  id, Volunteer_Contact__c, Expiration_Date__c FROM Conflict_Of_Interest__c  WHERE Volunteer_Contact__c IN :approvedVolunteerIds AND Expiration_Date__c > : Date.Today()])
        {
             coiMap.put(currCOI.Volunteer_Contact__c, currCOI);
        }
            
        for(npe5__Affiliation__c dbAffiliationRec : [SELECT Id,npe5__Contact__c,npe5__Primary__c,npe5__Status__c,npe5__Organization__c FROM npe5__Affiliation__c WHERE npe5__Contact__c IN : approvedVolunteerIds AND npe5__Status__c != 'Active'])
        {
        
                npe5__Affiliation__c currAffiliation = new npe5__Affiliation__c();
                if(coiMap.containsKey(dbAffiliationRec.npe5__Contact__c))
                {
                    currAffiliation.npe5__Status__c = 'Active';
                }
                else
                {
                    currAffiliation.npe5__Status__c = 'Pending';
                }
                currAffiliation.id = dbAffiliationRec.id;    
            if(volunteerChapterRoleMap.containsKey(dbAffiliationRec.npe5__Contact__c)){
                for(String currChapterRole : volunteerChapterRoleMap.get(dbAffiliationRec.npe5__Contact__c))
                {
                    if(chapterRoleOandTsSet.contains(currChapterRole))
                    {
                        currAffiliation.npe5__Status__c = 'Pending';
                    }
                 
                }
            }
        
                if(currAffiliation.npe5__Status__c == 'Active')
                    activeContactIdsSet.add(dbAffiliationRec.npe5__Contact__c);
                updateAffliationList.add(currAffiliation);
        }
           
           if(updateAffliationList.size() > 0)
           {
               update updateAffliationList;
               if(activeContactIdsSet.size() > 0)
                   VolunteerOandTHandler.updateUser(activeContactIdsSet);
           }
            
    }
     
   // DeActivate Existing Background Check.
   
   public static void DeactivateExistingRecords(Set<Id> newRecordIds, Set<Id> volunteerIds)
   {
       List<Background_check__c> deactivateExRecords = new List<Background_check__c>();
        for(Background_check__c exRec : [SELECT id,current__c FROM Background_check__c WHERE current__c = True AND Id NOT IN :newRecordIds AND Volunteer__c IN :volunteerIds])
        {
                Background_check__c updateRec = new Background_check__c();
                updateRec.current__c = false;
                updateRec.id = exRec.id;
                deactivateExRecords.add(updateRec);
                
        }
        
        if(deactivateExRecords.size() > 0)
        {
            Update deactivateExRecords;
        }
   }

  // Update Hidden Email Field
  
  public static void UpdateHiddenEmailField(Set<Id> volunteerIds, List<Background_check__c> newRecords)
  {
     Map<Id, Contact> volunteerMap = new Map<Id, Contact>();
     for(Contact currRec : [SELECT Id,OwnerId,AccountId,Account.Name,Account.Phone,Account.Email__c, Email FROM Contact WHERE Id IN :volunteerIds])
     {
            volunteerMap.put(currRec.Id,currRec);
     }
   
     for(Background_check__c currRec : newRecords)
     {
             if(volunteerMap.containsKey(currRec.Volunteer__c)){
               currRec.Hidden_Volunteer_Contact_Email__c = volunteerMap.get(currRec.Volunteer__c).Email;
                 currRec.OwnerId = volunteerMap.get(currRec.Volunteer__c).OwnerId;
             }
     }
  }
   
   // Updating most recent BC Expiration Date on Volunteer Contact.
  public static void UpdateVolunteerExpirationDate(Map<Id,Background_check__c>   expirationDateMap)
  {
      List<Contact> volunteerListToUpdate = new List<Contact>();
      for(Background_check__c currBGRec : expirationDateMap.values())
      {
        if(currBGRec.volunteer__c != Null)
        {
          Contact updateVolunteer = new Contact();
          updatevolunteer.id = currBGRec.volunteer__c;
          updateVolunteer.B_C_Expiration_Date__c = currBGRec.Date__c;
          volunteerListToUpdate.add(updateVolunteer);
        }
      }
      
      if(volunteerListToUpdate.size() > 0)
        update volunteerListToUpdate;
  
   }
   
   //Update volunteer Opportunity and volunteer Role status.
   Public static void UpdateVOppAndVRoleStatus(Set<Id> volunteerContactIdSet,String objectName){
       if(volunteerContactIdSet.size() > 0){
       List<Volunteer_Opportunity__c> updateVolOpportunityList = new List<Volunteer_Opportunity__c>();
       List<Volunteer_Roles__c> updateVolunteerRoleList = new List<Volunteer_Roles__c>();
       Map<Id,Volunteer_Roles__c> VolunteerRoleMap = new Map<Id,Volunteer_Roles__c>();
       for(Volunteer_Opportunity__c dbVolOpportunity : [SELECT Id,Volunteer_Name__c,Status__c FROM Volunteer_Opportunity__c WHERE Volunteer_Name__c IN: volunteerContactIdSet]){
           
           Volunteer_Opportunity__c updateVolStatus = new Volunteer_Opportunity__c();
           updateVolStatus.Id = dbVolOpportunity.Id;
           updateVolStatus.Status__c  = 'Out of Compliance';
           updateVolOpportunityList.add(updateVolStatus);
          
       }
       
       for(Volunteer_Roles__c dbVolRole : [SELECT Id,Volunteer_Name__c,Status__c,Chapter_Role__c,Chapter_Role__r.Background_Check_Required__c FROM Volunteer_Roles__c Where Volunteer_Name__c IN: volunteerContactIdSet ]){
           
           Volunteer_Roles__c updateVolStatus = new Volunteer_Roles__c();
           updateVolStatus.Id = dbVolRole.Id;
           if(dbVolRole.Chapter_Role__r.Background_Check_Required__c == true && objectName == 'backgroundCheck'){
           updateVolStatus.Status__c = 'Out of Compliance';
           }
           if(objectName == 'COI'){
           updateVolStatus.Status__c = 'Out of Compliance';
           }
           
           VolunteerRoleMap.put(updateVolStatus.Id,updateVolStatus);
       }
       
       
       
       if(updateVolOpportunityList.size() > 0)
       update updateVolOpportunityList;
       
       if(VolunteerRoleMap.size() > 0)
       update VolunteerRoleMap.values();
     }
   }

}