/**************************************************************************************
Created By: Vennila Paramasivam
Author : MST Solutions
Created Date : 06/28/2016
Description : Updating Primary as True when affiliation record is creating for contact as a first record
and used to add user to chatter group when the user becomes active for the chapter
***************************************************************************************/

trigger Affiliation_AT on npe5__Affiliation__c (Before Insert,Before Update,After Update,After Insert,After Delete) {
    
    Set<Id> contactIds = new Set<Id>();
    Map<String,Integer> contactsMap = new Map<String,Integer>();
    Map<id,String> contactMap=new Map<id,String>();
   
   // Whenever first Affiliation record is fallon under contact, assigning that record as primary.
    if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
     {
        if(Trigger.isBefore && Trigger.isInsert) 
        {
            Constant_Ac  constant = new constant_Ac();
            Map<Id,Contact> getContactRecType = new Map<Id,Contact>();
            Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
    
            for(npe5__Affiliation__c currRec : Trigger.new) 
            {
                contactIds.add(currRec.npe5__Contact__c);
            }
            
            if(contactIds.size() > 0)
            {
               getContactRecType.putAll([SELECT id,RecordTypeId FROM Contact WHERE Id IN :contactIds]);
            }
           
            
            for(AggregateResult ar : [SELECT npe5__Contact__c, count(Id) cnt FROM npe5__Affiliation__c 
                                      WHERE npe5__Contact__c IN :contactIds 
                                      GROUP BY npe5__Contact__c])
            {
                contactsMap.put(String.valueOf(ar.get('npe5__Contact__c')), Integer.valueOf(ar.get('cnt')));
            }
            
            for(npe5__Affiliation__c currRec : Trigger.new) 
            {
                if(!(contactsMap.containsKey(currRec.npe5__Contact__c))) {
                    currRec.npe5__Primary__c = True;
                }
                
                if(currRec.npe5__Contact__c != Null && getContactRecType.containsKey(currRec.npe5__Contact__c))
                {
                   if(getContactRecType.get(currRec.npe5__Contact__c).RecordTypeId != volunteerRecordTypeId)
                      currRec.npe5__Status__c = 'Active';
                   else
                      currRec.npe5__Status__c = 'Prospective';
                }
            }
            
        }
        //This used to get affiliation's crossponding user name and email to merge in active user welcome email template
        if(trigger.isBefore&& trigger.isUpdate)
        {
            set<Id> contactIdsSet = new set<Id>();
            list<npe5__Affiliation__c> UpdateAffiliationList = new List<npe5__Affiliation__c>();
            Map<Id,User>volunteerUserMap = new map<Id,User>();
            for(npe5__Affiliation__c currRec : Trigger.new){
                if((currRec.npe5__Status__c != Null && currRec.npe5__Status__c == 'Active') && (trigger.oldmap.get(currRec.id).npe5__Status__c != currRec.npe5__Status__c)){
                    contactIdsSet.add(currRec.npe5__Contact__c);
                }
            }
            for(User currUser : [SELECT ID,Username,ContactId,Email FROM User WHERE ContactId IN:contactIdsSet]){
                if(contactIdsSet.contains(currUser.ContactId)){
                    volunteerUserMap.put(currUser.ContactId, currUser);
                }
            }
            
            for(npe5__Affiliation__c currRec : Trigger.new){
                if((currRec.npe5__Status__c != Null && currRec.npe5__Status__c == 'Active') && (volunteerUserMap.containsKey(currRec.npe5__Contact__c))){
                    currRec.User_Name_Hidden__c = volunteerUserMap.get(currRec.npe5__Contact__c).Username;
                    currRec.User_Email_Hidden__c = volunteerUserMap.get(currRec.npe5__Contact__c).Email;
                }
            }
            
        }
        
        //Used to add user to chatter group when a user becomes active to particular chapter
        if(Trigger.isAfter && Trigger.isUpdate) {
            List<npe5__Affiliation__c> affilationsList = new List<npe5__Affiliation__c>();
            Set<string> vlounteerNameSet = new Set<String>();
            Set<String> chapterNameSet = new Set<String>();
            set<id> affiliationSet = new set<id>();
            Set<Id> affiliationsIdsSet = new Set<Id>();
            Set<Id> volunteerContactIdsSet = new Set<Id>();
            Set<id> VolunteerOppIdSet=new Set<id>();
            Set<Id> volunteerContactIdSet = new Set<Id>();
            Set<Id> activeVolunteerIdSet = new Set<Id>();
            Map<String,String> memberRemoveMap = new Map<String,String>();
            for(npe5__Affiliation__c modifiedAffiliation : Trigger.New) {
                if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null){
                    if(modifiedAffiliation.npe5__Status__c == 'Active' && Trigger.oldMap.get(modifiedAffiliation.Id).npe5__Status__c != modifiedAffiliation.npe5__Status__c) {
                        volunteerContactIdsSet.add(modifiedAffiliation.npe5__Contact__c);
                        affilationsList.add(modifiedAffiliation);
                        affiliationsIdsSet.add(modifiedAffiliation.Id);
                    }
                    if(modifiedAffiliation.npe5__Status__c== 'Inactive' && trigger.oldMap.get(modifiedAffiliation.id).npe5__Status__c != 'Inactive'){
                        VolunteerOppIdSet.add(modifiedAffiliation.npe5__Contact__c);//npe5__Contact__c,currRec.npe5__Status__c);
                    }
                    if(modifiedAffiliation.npe5__Status__c != 'Active' && trigger.oldMap.get(modifiedAffiliation.id).npe5__Status__c == 'Active'){
                        volunteerContactIdSet.add(modifiedAffiliation.npe5__Contact__c);
                    }
                    if(modifiedAffiliation.npe5__Status__c == 'Active' && trigger.oldMap.get(modifiedAffiliation.id).npe5__Status__c != 'Active'){
                        activeVolunteerIdSet.add(modifiedAffiliation.npe5__Contact__c);
                    }
                }
                
            }
            
            if(affilationsList.size()>0 && volunteerContactIdsSet.size()>0 && affiliationsIdsSet.size()>0) {
                AffiliationTriggerHandler.addUserToChaptterGroup(volunteerContactIdsSet,affiliationsIdsSet);
            }
            
            
            if(VolunteerOppIdSet.size() > 0 && VolunteerOppIdSet != Null){
                System.Debug('Trigger List @@@@@@@@@@*******');
                if(!Test.isRunningTest()) {
                    InactiveVolunteerHandler.createTaskforVolunteerManager(VolunteerOppIdSet);
                }
                               
            }
            
            if(volunteerContactIdSet.Size() > 0 && volunteerContactIdSet != Null){
                AffiliationTriggerHandler.inactiveAffiliations(volunteerContactIdSet);
            }
            
            if(activeVolunteerIdSet.Size() > 0){
                AffiliationTriggerHandler.activeAffiliations(activeVolunteerIdSet);
            }
            
        }
        
        // AFter insert trigger is used to add the user to the public group to access the approved In-Kind donor account record based on the affiliation record   
        if(Trigger.isAfter && (Trigger.isUpdate || trigger.isinsert )){
            Map<id,npe5__Affiliation__c> affiliationMap = new Map<id,npe5__Affiliation__c>();
            Set<Id> affiliationIds = new Set<Id>();
            
            
            Set<string> vlounteerNameSet = new Set<String>();
            Set<String> chapterNameSet = new Set<String>();
            set<id> affiliationSet = new set<id>();
            id groupId;
            id userId;
            
            for(npe5__Affiliation__c currRec : trigger.new){
                if(trigger.isinsert || currRec.npe5__Status__c!=trigger.oldMap.get(currRec.id).npe5__Status__c 
                   || currRec.Constituent_code__c != trigger.oldMap.get(currRec.id).Constituent_code__c){
                       affiliationMap.put(currRec.npe5__Contact__c,currRec);
                       affiliationIds.add(currRec.npe5__Organization__c);
                   }
                
                if(trigger.isinsert && currRec.npe5__Contact__c != Null && currRec.npe5__Organization__c != Null){
                    
                    vlounteerNameSet.add(currRec.npe5__Contact__c);
                    chapterNameSet.add(currRec.npe5__Organization__c);  
                    affiliationSet.add(currRec.id);
                }
            }
            
            if(affiliationMap.size() >0 &&  RecursiveTriggerHandler.isFirstTime == true)
            {
                AffiliationTriggerHandler.updateContact(affiliationMap,affiliationIds);
            }
            
            if(vlounteerNameSet.size() > 0 && chapterNameSet.size() > 0 && affiliationSet.size() > 0){
                AffiliationTriggerHandler.insertGroupMember(vlounteerNameSet,chapterNameSet,affiliationSet);
            }
        }
        
        // AFter delete trigger is used to remove the user to the public group to restrict the approved In-Kind donor account record based on the affiliation record   
        if(Trigger.isAfter && Trigger.isDelete) {
            Set<string> vlounteerNameSet = new Set<String>();
            Set<String> chapterNameSet = new Set<String>();
            set<id> affiliationSet = new set<id>();
            for(npe5__Affiliation__c currentRecord : trigger.old){
                vlounteerNameSet.add(currentRecord.npe5__Contact__c);
                chapterNameSet.add(currentRecord.npe5__Organization__c);  
                affiliationSet.add(currentRecord.id);
            }
            
            if(vlounteerNameSet.size() > 0 && chapterNameSet.size() > 0 && affiliationSet.size() > 0){
                AffiliationTriggerHandler.removeMemberFromGroup(vlounteerNameSet,chapterNameSet,affiliationSet);
            }
        }
        
   }
}