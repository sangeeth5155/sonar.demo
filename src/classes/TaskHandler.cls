/*****************************************************************************************************************
Author      : MST Solutions
Date        : 6/1/2016
Description : This class is used to create tasks when a task is completed and used to change the ownership
of the 'Brithday Remainder Task' to the primary volunteer and assign tasks to cae team member based on roles
*******************************************************************************************************************/
public class TaskHandler {
    
    // This method is used to assign the 'Birthday Remainder Task' to primary volunteer
    public static void BirthdayTaskPrimaryVolunteerAssign(List<Task> birthdayTasksList, Set<Id> taskRelatedContactIdsSet) {
        
        Set<Id> caseIdsSet = new Set<Id>();
        Map<Id,Id> caseContactIdsMap = new map<Id,Id>();
        Map<Id,Id> taskRelatedCaseIdsMap = new Map<Id,Id>();
        for(Case caseDetails : [SELECT Id, ContactId FROM Case WHERE Id IN : taskRelatedContactIdsSet]) {
            caseIdsSet.add(caseDetails.Id);
            caseContactIdsMap.put(caseDetails.Id, caseDetails.ContactId);
            taskRelatedCaseIdsMap.put(caseDetails.Id, caseDetails.contactId);
        }
        if(caseIdsSet.size()>0) {
            Map<Id,Id> caseTeamMembersMap = new Map<Id,Id>();
            for(CaseTeamMember memberDetails : [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE ParentId IN : caseIdsSet ORDER BY CreatedDate ASC]) {
                
                if(!caseTeamMembersMap.containsKey(memberDetails.ParentId)) {
                    caseTeamMembersMap.put(memberDetails.ParentId,memberDetails.MemberId);
                }
            }
            if(caseTeamMembersMap.size()>0) {
                Map<Id,Id> contactRelatedUsersIdsMap = new Map<Id,Id>();
                for(User getUserDetails : [SELECT Id, ContactId FROM User WHERE ContactId IN : caseTeamMembersMap.values()]) {
                    if(!contactRelatedUsersIdsMap.containsKey(getUserDetails.ContactId)) {
                        contactRelatedUsersIdsMap.put(getUserDetails.ContactId, getUserDetails.Id);
                    }
                }
                
                for(Task assignTaskOwner : birthdayTasksList) {
                    if(caseTeamMembersMap.containsKey(assignTaskOwner.whatId)) {
                       if(contactRelatedUsersIdsMap.get(caseTeamMembersMap.get(assignTaskOwner.whatId))!=Null)
                         assignTaskOwner.OwnerId=contactRelatedUsersIdsMap.get(caseTeamMembersMap.get(assignTaskOwner.whatId));
                    }
                    if(taskRelatedCaseIdsMap.containsKey(assignTaskOwner.whatId)) {
                        assignTaskOwner.whoId= taskRelatedCaseIdsMap.get(assignTaskOwner.whatId);
                    }
                }
            }
        }
    }

    
    
    public static void UpdateAffiliationStatus(Set<Id> volunteerContactSet)
    {
        Constant_AC  constant = new Constant_Ac(); 
        Id triainingRecordTypeId = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();
        Set<Id> bgRequiredvolIdsSet = new Set<Id>();
        Set<Id> chapterRoleSet = new Set<Id>();
        Set<Id> contactIdSet = new Set<Id>();
        Map<String, Set<String>> volunteerChapterRoleMap = new Map<String, Set<String>>();
        Map<Id,Volunteer_Orientation_Training__c > volunteerMap = new Map<Id,Volunteer_Orientation_Training__c>();
        Set<String> chapterRoleOandTsSet = new Set<String>();
        Map<String,Conflict_Of_Interest__c> coiMap = new Map<String,Conflict_Of_Interest__c>();
        List<npe5__Affiliation__c> updateAffliationList = new List<npe5__Affiliation__c>();
        Set<Id> activeContactIdsSet = new Set<Id>();
        List<Volunteer_Roles__c> updateVolunteerRoleStatus = new List<Volunteer_Roles__c>();
        
        for(Volunteer_Roles__c currRole : [SELECT Id,Name,Chapter_Role__c,Status__c,Chapter_Role__r.Background_Check_Required__c,Volunteer_Name__c From Volunteer_Roles__c  WHERE Volunteer_Name__c  IN:volunteerContactSet])
        {
            Volunteer_Roles__c updateStatus = new Volunteer_Roles__c();
            
            updateStatus.id = currRole.id;
            if(currRole.Status__c != 'Chapter Review' && currRole.Status__c != 'Trained')
            {
                updateStatus.Status__c = 'Pending Training';
                updateVolunteerRoleStatus.add(updateStatus);
            }
            
            if(currRole.Chapter_Role__r.Background_Check_Required__c == TRUE)
                bgRequiredvolIdsSet.add(currRole.Volunteer_Name__c);
            chapterRoleSet.add(currRole.Chapter_Role__c);
            if(volunteerChapterRoleMap.containsKey(currRole.Volunteer_Name__c))
                volunteerChapterRoleMap.get(currRole.Volunteer_Name__c).add(currRole.Chapter_Role__c);
            else
                volunteerChapterRoleMap.put(currRole.Volunteer_Name__c, new Set<String>{currRole.Chapter_Role__c});
        }
        
        if(chapterRoleSet.size() > 0)
        {
            for(Chapter_Role_O_T__c currChapterRole : [SELECT Id,Name,Orientation_Training__c,Orientation_Training__r.RecordTypeId,Required__c,Chapter_Role__c FROM Chapter_Role_O_T__c WHERE Chapter_Role__c IN :chapterRoleSet AND Required__c = TRUE AND Orientation_Training__r.RecordTypeId =:triainingRecordTypeId])
            {
                chapterRoleOandTsSet.add(currChapterRole.Chapter_Role__c);
            }
        }
        
        
        for(Conflict_Of_Interest__c currCOI : [SELECT  id, Volunteer_Contact__c, Expiration_Date__c FROM Conflict_Of_Interest__c  WHERE Volunteer_Contact__c IN :volunteerContactSet AND Expiration_Date__c > : Date.Today()])
        {
            coiMap.put(currCOI.Volunteer_Contact__c, currCOI);
        }
        
        
        for(npe5__Affiliation__c currRec : [SELECT Id,npe5__Contact__c,npe5__Primary__c,npe5__Status__c,npe5__Organization__c FROM npe5__Affiliation__c WHERE npe5__Contact__c IN :volunteerContactSet AND npe5__Status__c != 'Active'])
        {
            npe5__Affiliation__c currAffiliation = new npe5__Affiliation__c();
            currAffiliation.id = currRec.id;
            if(coiMap.containsKey(currRec.npe5__Contact__c))
                currAffiliation.npe5__Status__c = 'Active';
            else
                currAffiliation.npe5__Status__c = 'Pending';
            
            if(bgRequiredvolIdsSet.contains(currRec.npe5__Contact__c))
            {
                currAffiliation.npe5__Status__c = 'Pending';
            }
            if(volunteerChapterRoleMap.containsKey(currRec.npe5__Contact__c)){
                for(String currChapterRole : volunteerChapterRoleMap.get(currRec.npe5__Contact__c))
                {
                    if(chapterRoleOandTsSet.contains(currChapterRole))
                    {
                        currAffiliation.npe5__Status__c = 'Pending';
                    }
                    
                }
            }
            
            if(currAffiliation.npe5__Status__c == 'Active')
                activeContactIdsSet.add(currRec.npe5__Contact__c);
            
            updateAffliationList.add(currAffiliation);
            
        }
        
        if(updateVolunteerRoleStatus.size() > 0)
            update updateVolunteerRoleStatus;
        
        if(updateAffliationList.size() > 0)
        {
            Update updateAffliationList;
            if(activeContactIdsSet.size() > 0)
                VolunteerOandTHandler.updateUser(activeContactIdsSet);
        }
        
    }
    
    /*This method is used to update the Affiliation status to 'Declined' when the task status is 'Declined'*/
    public static void UpdateAffiliationStatusAsDeclined(Set<Id> volunteerContactSet)
    {
        List<npe5__Affiliation__c> affiliationList = new List<npe5__Affiliation__c>();
        for(npe5__Affiliation__c dbAffiliationRec : [SELECT Id,npe5__Contact__c,npe5__Primary__c,npe5__Status__c,npe5__Organization__c FROM npe5__Affiliation__c WHERE npe5__Contact__c IN :volunteerContactSet AND npe5__Status__c != 'Active']){
            dbAffiliationRec.npe5__Status__c = 'Declined';
            affiliationList.add(dbAffiliationRec);
        }
        if(affiliationList.size() > 0 ){
            update affiliationList;
        }
    }
    /* This method is used to fetch the values from associated contact of task and assign with the 
corresponding task fields to merge with email template */
    public static void updateTaskEmailMergeFields(Set<id> volunteerConatctIdsSet,list<Task> updatedTaskList){
        Map<Id,Contact> contactInfoMap = new Map<Id,Contact>();
        
        for(Contact getContactInfo : [SELECT ID, Name, Account.Name, Account.Phone, Account.Email__c FROM contact where id IN:volunteerConatctIdsSet]) {
            if(!contactInfoMap.containsKey(getContactInfo.Id)) {
                contactInfoMap.put(getContactInfo.Id, getContactInfo);
            }
        }
        for(Task currRec : updatedTaskList){
            if(currRec.WhoId != Null && contactInfoMap.containsKey(currRec.WhoId)){
                currRec.Account_Name__c = contactInfoMap.get(currRec.WhoId).Account.Name;
                currRec.Account_Phone__c = contactInfoMap.get(currRec.WhoId).Account.Phone;
                currRec.Account_Email__c = contactInfoMap.get(currRec.WhoId).Account.Email__c;
                currRec.Contact_Name_Hidden__c = contactInfoMap.get(currRec.WhoId).Name;
            }
        }
    }
    
    public static void updateCheckinDate(Set<Id> checkInTaskParentIdsSet){
        Constant_AC  constant = new Constant_Ac(); 
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        
        List<Case> caseFamilyCheckinUpdate = new List<Case>();
        for(Case getCase : [SELECT Id, CheckedInFamily__c FROM Case WHERE RecordTypeId =: parentWishRecordTypeId AND CheckedInFamily__c = null AND Id IN : checkInTaskParentIdsSet]) {
            getCase.CheckedInFamily__c = System.today();
            caseFamilyCheckinUpdate.add(getCase);
        }
        if(caseFamilyCheckinUpdate.size() > 0) {
            update caseFamilyCheckinUpdate;
        }
    }
    
    public static void createCheckinRecurrenceTask(List<Task> createCheckinTaskList, Set<Id> checkinTaskIdSet){
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Id defaultRecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.taskRT).getRecordTypeId();
        Id volunteerTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.volunteerTaskRT).getRecordTypeId();
        List<Task> newRecTaskList = new List<Task>();
        Map<Id,Case> parentCaseMap = new Map<Id,Case>([SELECT Id,Status,ParentId FROM Case WHERE RecordTypeId = :parentWishRecordTypeId AND Id IN :checkinTaskIdSet]);
        
        for(Task recCheckinTask : createCheckinTaskList) {
            if((parentCaseMap.containsKey(recCheckinTask.WhatId) && (parentCaseMap.get(recCheckinTask.WhatId).Status != 'Granted'))) {
                Task newSubTask = new Task();
                newSubTask.Subject = recCheckinTask.Subject;
                newSubTask.ActivityDate = System.Today() + 30;
                newSubTask.WhatId = recCheckinTask.WhatId;
                newSubTask.Task_Type__c = recCheckinTask.Task_Type__c;
                newSubTask.WhoId = recCheckinTask.WhoId;
                newSubTask.RecordTypeId = volunteerTaskRT;
                if(recCheckinTask.OwnerId != Null)
                    newSubTask.OwnerId = recCheckinTask.OwnerId;
                newRecTaskList.add(newSubTask);
            }
        }
        if(newRecTaskList.size() > 0) {
            insert newRecTaskList;
        }
    }
    
    //For creating sneakpeek task for chapter st
    public static void sneakPeekTask(Map<Id, Task> flightBookTaskMap,Map<Id, Task> budgetBookTaskMap, Map<Id, Task> passportRequestMap){
        
        List<Task> updateTaskList = new List<Task>();
        if(flightBookTaskMap.size() > 0) {
            for(Task sneakPeek : [SELECT Id, ActivityDate FROM Task WHERE WhatId IN : flightBookTaskMap.keySet() AND isClosed = false AND Subject ='Sneak Peek Letter']) {
                if(sneakPeek.ActivityDate != null) {
                    sneakPeek.ActivityDate = sneakPeek.ActivityDate.addDays(7);
                } else {
                    sneakPeek.ActivityDate = System.today() + 7;
                }
                
                updateTaskList.add(sneakPeek);
            } 
        }
        if(budgetBookTaskMap.size() > 0) {
            for(Task sneakPeek : [SELECT Id, ActivityDate FROM Task WHERE WhatId IN : budgetBookTaskMap.keySet() AND isClosed = false AND (Subject ='Request Passports from family' OR Subject = 'Passports Requested from family')]) {
                if(sneakPeek.ActivityDate != null) {
                    sneakPeek.ActivityDate = sneakPeek.ActivityDate.addDays(7);
                } else {
                    sneakPeek.ActivityDate = System.today() + 7;
                }
                updateTaskList.add(sneakPeek);
            } 
        }
        if(passportRequestMap.size() > 0) {
            for(Task sneakPeek : [SELECT Id, ActivityDate FROM Task WHERE WhatId IN : passportRequestMap.keySet() AND isClosed = false AND Subject ='Cruise request form']) {
                if(sneakPeek.ActivityDate != null) {
                    sneakPeek.ActivityDate = sneakPeek.ActivityDate.addDays(14);
                } else {
                    sneakPeek.ActivityDate = System.today() + 14;
                }
                updateTaskList.add(sneakPeek);
            } 
        }
        
        if(updateTaskList.size() > 0) {
            update updateTaskList;
        }
    }
    
    //Create upload task for volunteer
   /* public static void createUploadTaskForWishOwner(Map<id,id> createUploadTaskWishMap){
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Id defaultRecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.taskRT).getRecordTypeId();
        List<Task> newRecTaskList = new List<Task>();
        Id staffTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.staffTaskRT).getRecordTypeId();
        Map<Id,String> wishContactIdMap = new Map<Id,String>();
        Map<Id, Id> caseContactMap = new Map<Id, Id>();
        for(Case getChildInfo : [SELECT Id, Contact.Name, ContactId FROM Case WHERE Id IN : createUploadTaskWishMap.keySet() AND RecordTypeId =:parentWishRecordTypeId]) {
            wishContactIdMap.put(getChildInfo.Id, getChildInfo.Contact.Name);
            caseContactMap.put(getChildInfo.Id, getChildInfo.ContactId);
        }
        for(Id parentId : createUploadTaskWishMap.Keyset()) {
            Task newSubTask = new Task();
            newSubTask.Subject = 'Review Photos and Videos for '+wishContactIdMap.get(parentId);
            if(caseContactMap.containsKey(parentId)) {
                newSubTask.WhoId = caseContactMap.get(parentId);
            }
            newSubTask.WhatId = parentId;
            newSubTask.RecordTypeId = staffTaskRT;
            newSubTask.ActivityDate = System.today() + 5;
            newSubTask.OwnerId = createUploadTaskWishMap.get(parentId);
            newRecTaskList.add(newSubTask);
            
        }
        if(newRecTaskList.size() > 0) {
            insert newRecTaskList;
        }
    }*/
    
    //Volunteer wish granted task check
    Public static void checkWishGrantTask(Set<Id> wishGrantTaskWhatIdSet) {
        Constant_AC  constant = new Constant_Ac(); 
        Id wishGrantTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        List<Case> wishGrankClosedWishList = new List<Case>();
        Map<Id,Case> parentWishMap = new Map<Id,Case>([SELECT Id, isWishGrantTasksClosed__c FROM Case WHERE Id IN : wishGrantTaskWhatIdSet AND RecordTypeId =: parentWishRecordTypeId]);
        List<Task> wishGrantOpenTaskCheckList = [SELECT Id FROM Task WHERE IsClosed = FALSE AND RecordTypeId =: wishGrantTaskRT];
        Set<Id> childTaskExistParentIdSet = new Set<Id>();
        
        for(AggregateResult agg : [SELECT count(Id) recCount, WhatId parentWishId FROM Task WHERE WhatId IN : wishGrantTaskWhatIdSet  AND isClosed = FALSE GROUP BY WhatId]) {
            
            if(parentWishMap.containsKey((ID)agg.get('parentWishId'))) {
                childTaskExistParentIdSet.add(parentWishMap.get((ID)agg.get('parentWishId')).Id);
            }
        }
        
        if(parentWishMap.size() > 0) {
            for(Id parentWishId : parentWishMap.keySet()) {
                if(!childTaskExistParentIdSet.contains(parentWishId)) {
                    if(parentWishMap.containsKey(parentWishId)) {
                        parentWishMap.get(parentWishId).isWishGrantTasksClosed__c = true;
                        wishGrankClosedWishList.add(parentWishMap.get(parentWishId));
                    }
                }
            }
        }
        
        
        if(wishGrankClosedWishList.size() > 0) {
            update wishGrankClosedWishList;
        }
    }
    
    //Check volunteer followup task
    public static void checkFollowUpTask(Map<Id, Task> followUpTaskMap, Set<Id> followUpTaskOwnerId) {
        Set<Id> communityUserIdSet = new Set<Id>();
        Set<Id> openTaskIdSet = new Set<Id>();
        
        Set<Id> ownerIdSet = new Set<Id>();
        for(CaseTeamMember caseTeamMem : [SELECT ParentId, MemberId, TeamRoleId, TeamRole.Name FROM CaseTeamMember WHERE TeamRole.Name = 'Wish Granter' AND ParentId IN : followUpTaskMap.keySet()]) {
            ownerIdSet.add(caseTeamMem.MemberId);
        }
        
        for(Task existingTask : [SELECT Id, WhatId, OwnerId FROM Task WHERE WhatId IN : followUpTaskMap.keySet() AND isClosed = false AND OwnerId IN : ownerIdSet]) {
            openTaskIdSet.add(existingTask.WhatId);
        }
        for(Task checkOpenTask : followUpTaskMap.values()) {
            if(openTaskIdSet.contains(checkOpenTask.WhatId)) {
                checkOpenTask.addError('Please close other follow up task before closing this task');
            }
        }
    }
    public static void updateVolunteerRecord(Map<Id,Task> taskMap,Set<Id> ownerIds, Set<Id> caseIds)
    {
        Map<Id,User> volunteerMap = new Map<Id,User>();
        Map<Id, Set<Id>> caseTeamMemberMap = new Map<Id, Set<Id>>();
        List<Contact> updateContactList = new List<Contact>();
        for(CaseTeamMember currMemb : [SELECT id,ParentId,MemberId FROM CaseTeamMember WHERE ParentId = :caseIds AND TeamRole.Name = 'Wish Granter'])
        {
            ownerIds.add(currMemb.MemberId);
            if(!caseTeamMemberMap.containsKey(currMemb.ParentId))
            {
                caseTeamMemberMap.put(currMemb.ParentId, new set<Id>{currMemb.memberid});
                
            }
            else
            {
                caseTeamMemberMap.get(currMemb.ParentId).add(currMemb.memberid);
            }
        }
        
        
        for(User currVol : [SELECT Id,ContactId,Contact.Date_of_last_engagement__c  FROM User WHERE Id IN :ownerIds AND Profile.Name = 'Active Volunteer'])
        {
            volunteerMap.put(currVol.id,currVol);
        }
        
        for(Task currTask : taskMap.values())
        {
            
            if(caseTeamMemberMap.containsKey(currTask.whatId))
            {
                for(Id currId : caseTeamMemberMap.get(currTask.whatId))
                {
                    if(volunteerMap.containsKey(currId))
                    {
                        if(volunteerMap.get(currId).Contact.Date_of_last_engagement__c == Null || volunteerMap.get(currId).Contact.Date_of_last_engagement__c < Date.Today())
                        {
                            Contact updateContact = new Contact();
                            updateContact.id = volunteerMap.get(currId).ContactId;
                            updateContact.Date_of_last_engagement__c = Date.Today();
                            updateContactList.add(updateContact);
                        }
                    }
                }
            }
            
            
        }
        
        if(updateContactList.size() > 0)
            update updateContactList;
        
    }
    
    public static void colseTaskValidation(List<Task> validationTaskList) {
        
        //Used to get recordTypeId 
        Constant_AC  constant = new Constant_Ac(); 
        Id wishGrantTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        
        Set<Id> conceptTaskParentSet = new Set<Id>(); //Holds parent Id for Concept Task
        Set<Id> wishNotClosedParentIdSet = new Set<Id>(); //Holds parent Id for Wish Not Closed Task
        Set<Id> presentationParentIdSet = new Set<Id>(); //Holds parent Id for Presentation Close Task
        List<Task> conceptTask = new List<Task>(); // Holds Concept Task List 
        List<Task> wishPresentationTaskList = new List<Task>(); // Holds Presentation Date Task List 
        List<Task> wishNotClosedTaskList = new List<Task>(); // Holds Wish Not Closed Task List 
        
        
        //Used to split task based on subject
        for(Task checkSubject : validationTaskList) {
            if(checkSubject.subject == 'Wish concept approval') {
                conceptTaskParentSet.add(checkSubject.WhatId);
                conceptTask.add(checkSubject);
            } else if(checkSubject.subject == 'Wish Presentation not set') {
                wishPresentationTaskList.add(checkSubject);
                presentationParentIdSet.add(checkSubject.WhatId);
            } else if (checkSubject.subject == 'Wish not closed') {
                wishNotClosedParentIdSet.add(checkSubject.WhatId);
                wishNotClosedTaskList.add(checkSubject);
            }
        }
        
        
        if(conceptTaskParentSet.size() > 0) {
            Map<Id, Case> conceptApprovalMap = new Map<Id, Case>();
            
            for(Case conceptApprovalCheck : [SELECT Id, Status, Sub_Status__c FROM Case WHERE RecordTypeId =: parentWishRecordTypeId AND Id IN : conceptTaskParentSet]) {
                conceptApprovalMap.put(conceptApprovalCheck.Id, conceptApprovalCheck);
            }
            if(conceptApprovalMap.size() > 0) {
                for(Task throwError : conceptTask) {
                    if(conceptApprovalMap.containsKey(throwError.WhatId)) {
                        if(conceptApprovalMap.get(throwError.WhatId).Status != 'Wish Determined' && conceptApprovalMap.get(throwError.WhatId).Sub_Status__c != 'Within Policy') {
                            throwError.addError('Wish Determination is not within the policy');
                        }
                    }
                }
            }
        }
        
        if(presentationParentIdSet.size() > 0) {
            Map<Id, Date> presentationCaseMap = new Map<Id, Date>();
            for(Case parentCasePresentationDateCheck : [SELECT Id, Presentation_Date__c, RecordTypeId, ParentId FROM Case WHERE ParentId IN : presentationParentIdSet AND Presentation_Date__c = null AND RecordTypeId =: wishGrantTaskRT]) {
                presentationCaseMap.put(parentCasePresentationDateCheck.ParentId, parentCasePresentationDateCheck.Presentation_Date__c);
            }
            
            if(presentationCaseMap.size() > 0) {
                for(Task presentationValidate : wishPresentationTaskList) {
                    if(presentationCaseMap.containsKey(presentationValidate.WhatId)) {
                        presentationValidate.addError('Please enter presentation date before closing this task');
                    }
                }
            }
        }
        
        if(wishNotClosedParentIdSet.size() > 0 ) {
            Set<Id> openCaseIdSet = new Set<Id>();
            for(Case wishStatusCheck : [SELECT Id, Status, RecordTypeId FROM Case WHERE Id IN : wishNotClosedParentIdSet AND (Status != 'Completed' OR Status != 'Closed') AND RecordTypeId =: parentWishRecordTypeId]) {
                openCaseIdSet.add(wishStatusCheck.Id);
            }
            
            if(openCaseIdSet.size() > 0) {
                for(Task preventTaskClose : wishNotClosedTaskList) {
                    if(openCaseIdSet.contains(preventTaskClose.WhatId)) {
                        preventTaskClose.addError('Please close the wish before closing this task');
                    }
                }
            }
        }
    }
    
    //Below method is for sprint 12 ticket
    public static void autoCloseTask(List<Task> closeTaskList, Set<Id> closeTaskParentIdsSet) {
        Constant_AC  constant = new Constant_Ac(); 
        Id wishGrantTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        
        Set<Id> caseTeamMemberSet = new Set<Id>();
        
        for(CaseTeamMember caseTeamMem : [SELECT ParentId, MemberId, TeamRoleId, TeamRole.Name FROM CaseTeamMember WHERE TeamRole.Name = 'Wish Granter' AND ParentId IN : closeTaskParentIdsSet]) {
            caseTeamMemberSet.add(caseTeamMem.MemberId);
        }
        
        if(closeTaskParentIdsSet.size() > 0) {
            System.debug('>>>>>>>');
            Map<Id, Integer> taskCount = new Map<Id, Integer>();
            for(AggregateResult aggr : [SELECT Count(Id) recCount,  WhatId parentRecId FROM Task WHERE WhatId IN : closeTaskParentIdsSet AND Subject != 'Volunteer wish follow-up activities not complete' AND status != 'Completed' AND OwnerId IN : caseTeamMemberSet  GROUP BY WhatId] ) {
                taskCount.put((Id)aggr.get('parentRecId'), (Integer)aggr.get('recCount'));
            }
            
            Set<Id> closeFolowupTaskIdSet = new Set<Id>();
            for(Id parentId : closeTaskParentIdsSet) {
                if(!taskCount.containsKey(parentId)) {
                    closeFolowupTaskIdSet.add(parentId);
                }
            }
            
            if(closeFolowupTaskIdSet.size() > 0) {
                List<Task> closeFolowUpTaskList = new List<Task>();
                for(Task closeFollowUpTask : [SELECT Id FROM Task WHERE WhatId IN : closeFolowupTaskIdSet AND Subject = 'Volunteer wish follow-up activities not complete']) {
                    closeFollowUpTask.Status = 'Completed';
                    closeFolowUpTaskList.add(closeFollowUpTask);
                }
                if(closeFolowUpTaskList.size() > 0) {
                    update closeFolowUpTaskList;
                }
            }
        } 
    }
    
     //Update the Lead Closed Date.
    public static void updateLeadCloseDate(List<Id> leadIdList){
        List<Lead> updateLeadList = new List<Lead>();
        
        for(Lead currLead : [SELECT Id,Closed_Date__C FROM Lead WHERE Id IN :leadIdList]){
            currLead.Closed_Date__c = System.Today();
            updateLeadList.add(currLead);
        }
        if(updateLeadList.Size() > 0)
            Update updateLeadList;
    }
    
    //Used to update contact to the given task
    public static void UpdateContactToTask(List<Task> matchContactTaskList, Set<Id> taskParentIdSet) {
        
        Constant_AC  constant = new Constant_Ac();
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Id planningWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();
        Map<Id, Id> caseContactInfoMap = new Map<Id, Id>();
        Map<Id,Id> plainingParentInfoMap = new Map<Id, Id>();
        for(Case parentCaseInfo : [SELECT Id, ContactId, parentId, parent.ContactId, RecordTypeId FROM Case WHERE Id IN : taskParentIdSet]) {
            if(parentCaseInfo.RecordTypeId == parentWishRecordTypeId) {
                caseContactInfoMap.put(parentCaseInfo.Id, parentCaseInfo.ContactId);
            } else if(parentCaseInfo.RecordTypeId == planningWishRecordTypeId) {
                caseContactInfoMap.put(parentCaseInfo.parentId, parentCaseInfo.parent.ContactId);
                plainingParentInfoMap.put(parentCaseInfo.Id, parentCaseInfo.parentId);
            }
            
        }
        
        for(Task mapContactInfo : matchContactTaskList) {
            if(caseContactInfoMap.containsKey(mapContactInfo.WhatId) && mapContactInfo.Subject != 'Budget needs to be revised' && mapContactInfo.Subject != 'Budget is approved' && mapContactInfo.Subject != 'Case ET : Budget Approval Request') {
                mapContactInfo.WhoId = caseContactInfoMap.get(mapContactInfo.WhatId);
            } else if(mapContactInfo.Subject == 'Budget needs to be revised' || mapContactInfo.Subject == 'Budget is approved' || mapContactInfo.Subject == 'Case ET : Budget Approval Request') {
                if(plainingParentInfoMap.containsKey(mapContactInfo.WhatId)) {
                    if(caseContactInfoMap.containsKey(plainingParentInfoMap.get(mapContactInfo.WhatId))) {
                        mapContactInfo.WhoId = caseContactInfoMap.get(plainingParentInfoMap.get(mapContactInfo.WhatId));
                        mapContactInfo.WhatId = plainingParentInfoMap.get(mapContactInfo.WhatId);
                    }
                    
                }
            }
        }
        
    }
}