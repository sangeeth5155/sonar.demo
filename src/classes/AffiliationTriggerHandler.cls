/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kesavakumar Murugesan
Date        : 7/12/2016
Description : This class is used to add the volunteer to appropriate chatter group based on their chapter when they become an active volunteer
*******************************************************************************************************************/
public class AffiliationTriggerHandler {
    
    // Used to add a user to chatter group based on their chapter when the volunter become active.
    
    public static void addUserToChaptterGroup(Set<Id> volunteerContactIdsSet, Set<Id> affiliationsIdsSet) {
        
        Map<Id,String> volunteerChaptersMap = new Map<Id,String>();
        Set<String> chapterNamesSet = new Set<String>();
        Map<Id, Id> volunteerUsersMap = new Map<Id,Id>();
        Map<String,Id> chatterGroupNameIdsMap = new Map<String,Id>();
        List<CollaborationGroupMember> chatterGroupMembersList = new List<CollaborationGroupMember>();
        
        for(npe5__Affiliation__c getChapters : [SELECT Id, npe5__Organization__r.Name, npe5__Contact__c FROM npe5__Affiliation__c WHERE npe5__Contact__c IN : volunteerContactIdsSet AND Id IN : affiliationsIdsSet]) {
            if(!chapterNamesSet.contains(getChapters.npe5__Organization__r.Name)) {
                chapterNamesSet.add(String.valueOf(getChapters.npe5__Organization__r.Name).removeStart('Make-A-Wish '));
            }
            volunteerChaptersMap.put(getChapters.npe5__Contact__c, String.valueOf(getChapters.npe5__Organization__r.Name).removeStart('Make-A-Wish '));
        }
        
        System.debug('ChapterName Set'+ chapterNamesSet);
        // Used to get volunteer user id and volunteer contact id
        for(User relatedUsers : [SELECT Id, ContactId FROM User WHERE ContactId IN : volunteerContactIdsSet]) {
            volunteerUsersMap.put(relatedUsers.ContactId ,relatedUsers.Id);
        }        
        if(chapterNamesSet.size()>0) {
            // Used to get the group name based on the chapter names
            for(CollaborationGroup getgroupId : [SELECT Id, Name FROM CollaborationGroup WHERE Name IN : chapterNamesSet]) {
                chatterGroupNameIdsMap.put(getgroupId.Name,getgroupId.Id);
            }
        }
        System.debug('chatterGroupNameIdsMap>>>'+chatterGroupNameIdsMap);
        Set<String> chatterGroupsMembersSet = new Set<String>();
        for(CollaborationGroupMember chatterGroupMemberExistCheck : [SELECT Id, MemberId, CollaborationGroupId FROM CollaborationGroupMember WHERE MemberId IN : volunteerUsersMap.values()])  {
            chatterGroupsMembersSet.add(chatterGroupMemberExistCheck.CollaborationGroupId+'-'+chatterGroupMemberExistCheck.MemberId);
        }
        //Used to check whether a user exists in the chatter group before adding the user to group
        for(Id volunteerContact : volunteerContactIdsSet) {
            if(volunteerChaptersMap.containsKey(volunteerContact) && chatterGroupNameIdsMap.containsKey(volunteerChaptersMap.get(volunteerContact)) && volunteerChaptersMap.containsKey(volunteerContact)) {
                if(!chatterGroupsMembersSet.contains(chatterGroupNameIdsMap.get(volunteerChaptersMap.get(volunteerContact))+'-'+volunteerUsersMap.get(volunteerContact))) {
                    chatterGroupMembersList.add(new CollaborationGroupMember (CollaborationGroupId = chatterGroupNameIdsMap.get(volunteerChaptersMap.get(volunteerContact)), MemberId = volunteerUsersMap.get(volunteerContact)));
                }
            }            
        }
        if(chatterGroupMembersList.size()>0) {
            if(!Test.isRunningTest()) {
                insert chatterGroupMembersList; // adding members to the group.
            }
        }
    }
    //used to update the status field in contact for reporting purpose
    public static void updateContact(Map<id,npe5__Affiliation__c> contactMap, Set<Id> affiliationIds){
        RecursiveTriggerHandler.isFirstTime = false;
        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        Id wichChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        Id familyContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        Id MedicalProfContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
        Id boardMemberRT = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.boardMemberRT).getRecordTypeId();
        Id chapterRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        
        List<Contact> conList=[SELECT id,Hidden_Status__c, RecordTypeId, RecordType.Name  from contact where id IN :contactMap.keyset()];
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT id,recordtypeid FROM Account WHERE Id IN :affiliationIds]);
        
        Map<String,integer> recordTypeOrder = new Map<String, integer>();
        recordTypeOrder.put('Board Member',1);
        recordTypeOrder.put('Volunteer',2);
        recordTypeOrder.put('Medical Professional',3);
        recordTypeOrder.put('Wish Child',4);
        recordTypeOrder.put('Wish Family',5);
        
        
        Map<String,String> recordTypeNames = new Map<String, String>();
        recordTypeNames.Put(volunteerRecordTypeId,'Volunteer');
        recordTypeNames.Put(wichChildRecordTypeId,'Wish Child');
        recordTypeNames.Put(familyContactRecordTypeId,'Wish Family');
        recordTypeNames.Put(MedicalProfContactRecordTypeId ,'Medical Professional');
        recordTypeNames.Put(boardMemberRT,'Board Member');
        
        Map<String,String> recordTypes = new Map<String, String>();
        recordTypes.put('Volunteer',volunteerRecordTypeId);
        recordTypes.put('Wish Child',wichChildRecordTypeId);
        recordTypes.put('Wish Family',familyContactRecordTypeId);
        recordTypes.put('Medical Professional',MedicalProfContactRecordTypeId );
        recordTypes.put('Board Member',boardMemberRT);
        
        
        
        for(Contact currContact : conList){
            npe5__Affiliation__c currAffiliation =  contactMap.get(currContact.id);
            currContact.Hidden_Status__c=currAffiliation.npe5__Status__c;
            
            if(currAffiliation.Constituent_code__c != Null && recordTypeNames.containsKey(currContact.recordTypeId))
            {
                if(currAffiliation.Constituent_code__c != recordTypeNames.get(currContact.recordTypeId))
                {
                    if(recordTypeOrder.get(currAffiliation.Constituent_code__c) < recordTypeOrder.get(recordTypeNames.get(currContact.recordTypeId)))
                    {
                        if(recordTypes.containsKey(currAffiliation.Constituent_code__c) && accountMap.get(currAffiliation.npe5__Organization__c).recordTypeId == chapterRT)
                            currContact.RecordTypeId =recordTypes.get(currAffiliation.Constituent_code__c);  
                    }
                }
            }
        } 
        update conList;
        
    }
    // Used to add a user to group based on their affilaition when the affilaition created. 
    @future 
    public static void insertGroupMember(Set<string> vlounteerNameSet,Set<String> chapterNameSet,set<id> affiliationSet ){
        Map<id,User> userMap = new Map<id,user>();
        Map<Id, String> chapterNameMap = new Map<Id, String>();
        map<string,id> publicGroupMap = new map<string,id>();
        List<GroupMember> groupMemberList = new List<GroupMember>();
        if(vlounteerNameSet.size() > 0){
            for(User currentUser : [SELECT ID,ContactID FROM User WHERE ContactID IN: vlounteerNameSet]){
                userMap.put(currentUser.ContactID,currentUser);
            }
        }
        
        if(chapterNameSet.size() > 0){
            for(Account currentAccount :[SELECT Id,Name FROM Account WHERE Id IN: chapterNameSet]){
                String chapterNameTrim = currentAccount.Name.removeStart('Make-A-Wish ');
                chapterNameMap.put(currentAccount.Id, chapterNameTrim);
            }
        }
        
        for(Group currentGroup : [SELECT Id, Name FROM Group WHERE Type = 'Regular']){
            publicGroupMap.put(currentGroup.Name, currentGroup.id);
        }
        
        for(npe5__Affiliation__c currentRec : [SELECT ID,Name,npe5__Organization__c,npe5__Contact__c FROM npe5__Affiliation__c WHERE ID IN: affiliationSet]){
            if(userMap.containsKey(currentRec.npe5__Contact__c) && chapterNameMap.containsKey(currentRec.npe5__Organization__c)){
                
                GroupMember newGroupMem = new GroupMember();
                newGroupMem.GroupId= publicGroupMap.get(chapterNameMap.get(currentRec.npe5__Organization__c));
                newGroupMem.UserOrGroupId = userMap.get(currentRec.npe5__Contact__c).id;
                groupMemberList.add(newGroupMem);
            }
        }
        
        if(groupMemberList.size() > 0){
            insert groupMemberList;
        }
    }
    // Used to remove a user from group based on their affilaition when the affilaition deleted.    
    @future 
    public static void removeMemberFromGroup(Set<string> vlounteerNameSet,Set<String> chapterNameSet,set<id> affiliationSet){
        map<string,id> publicGroupMap = new map<string,id>();
        Map<id,id> userMap = new Map<id,id>();
        Map<id,String> groupNameMap = new Map<id,String>();
        List<GroupMember> grpList = new List<GroupMember>();
        for(Account chapterName : [SELECT ID,Name FROM Account WHERE ID IN: chapterNameSet]){
            String groupNameTrim = chapterName.Name.removeStart('Make-A-Wish ');
            groupNameMap.put(chapterName.id,groupNameTrim);
        }
        for(User currentuser : [SELECT ID,ContactID FROM User WHERE ContactID IN: vlounteerNameSet]){
            userMap.put(currentuser.ContactID, currentuser.Id);
        }
        
        for(Group currentGroup : [SELECT Id, Name FROM Group WHERE Type = 'Regular' AND Name IN: groupNameMap.values()]){
            publicGroupMap.put(currentGroup.Name, currentGroup.id);
        }
        for(GroupMember currentmember :[SELECT ID,GroupId,UserOrGroupId  FROM GroupMember WHERE GroupId IN: publicGroupMap.values() AND UserOrGroupId IN: userMap.values()]){
            grpList.add(currentmember);
        }
        if(grpList.size() > 0){
            delete grpList;
        }
        
    }
    
     public static void inactiveAffiliations(Set<Id> volunteerIdSet){
        Set<Id> inactiveVolunteerIdSet = new set<Id>();
        for(npe5__Affiliation__c currAff : [SELECT id,npe5__Status__c,npe5__Contact__c  FROM npe5__Affiliation__c WHERE  npe5__Contact__c IN :volunteerIdSet]){
               
               if(currAff.npe5__Status__c != 'Active'){
                   inactiveVolunteerIdSet.add(currAff.npe5__Contact__c); 
               }
               else if(currAff.npe5__Status__c == 'Active' && inactiveVolunteerIdSet.Contains(currAff.npe5__Contact__c)){
                   inactiveVolunteerIdSet.Remove(currAff.npe5__Contact__c);
               }
        }
        if(inactiveVolunteerIdSet.Size() > 0){
               updateBCandCOIVolunteerInactive(inactiveVolunteerIdSet,True);
         }
     }
     
     public static void activeAffiliations(Set<Id> volunteerIdsSet){
        Set<Id> activeVolunteerIdSet = new set<Id>();
        Set<Id> volunteerIdSet = new Set<Id>();
        for(npe5__Affiliation__c currAff : [SELECT id,npe5__Status__c,npe5__Contact__c  FROM npe5__Affiliation__c WHERE  npe5__Contact__c IN :volunteerIdsSet]){
               
               if(currAff.npe5__Status__c == 'Active'){
                   volunteerIdSet.add(currAff.npe5__Contact__c); 
               }
               
        }
        if(volunteerIdSet.Size() > 0){
                For(User currUser : [SELECT Id,ContactId FROM User Where contactId IN :volunteerIdSet AND isActive = True]){
                    activeVolunteerIdSet.add(currUser.ContactId);
                }
                if(activeVolunteerIdSet.Size() > 0){
                    updateBCandCOIVolunteerInactive(activeVolunteerIdSet,False);
                }
         }
     }
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