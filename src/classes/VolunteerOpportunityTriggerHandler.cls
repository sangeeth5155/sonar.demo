/*************************************************************************************************
Author   : MST Solutions
CreatedDate : 05/27/2016
Description : 1. This VolunteerOpportunityTriggerHandler is used to invoke the apporval process when the volunteer contact name is entered into the volunteer contact field.
2. And also it is used to update count of the no.of volunteer opportunities that are registered for the corresponding NonWish & Event. 
3. And it is used to update count of the number of volunteer opportunities that are created for the corresponding NonWish & Event.
4. And also it is used when the chapter staff is approved then the volunteer contact is added in to the coressponding case team.
*************************************************************************************************/

Public class VolunteerOpportunityTriggerHandler 
{
    
    Static Integer count = 0;
    Static Map<Id,Case> caseMap = new Map<Id,Case>();
    
    Static Set<Id> ParentCaseSet = new Set<Id>();
    
    /* This SubmitforApprovalProcess() invoke the approval process when the volunteer contact name is entered into the volunteer contact field.*/
    Public Static Void SubmitforApprovalProcess(List<Volunteer_Opportunity__c> recordsForApprovalProcess, Set<Id> chapterIdsSet)
    {
        List<Approval.ProcessSubmitRequest> approvalReqList=new List<Approval.ProcessSubmitRequest>();
        List<Volunteer_Opportunity__c> statusPendingList = new List<Volunteer_Opportunity__c>();
        
        Map<Id,Id> volunteerManagerIdsMap = new Map<Id,Id>();
        
        for(Account getAccountName : [SELECT Id, Name, volunteer_manager__c FROM Account WHERE Id IN : chapterIdsSet]) {
            volunteerManagerIdsMap.put(getAccountName.id,getAccountName.volunteer_manager__c);
            
        }
        
        //Default user not give by client so we assign it to active user
        // User userns = [SELECT Id,username, profile.Name FROM User WHERE profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        for(Volunteer_Opportunity__c newVolunteerRole : recordsForApprovalProcess)
        {
            /* if(newVolunteerRole.Status__c == 'Pending'){
statusPendingList .add(newVolunteerRole);
}*/
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            //req1.setSubmitterId(user1.Id);
            req.setComments('Submitting request for approval.');
            req.setObjectId(newVolunteerRole.id);
            if(volunteerManagerIdsMap.containsKey(newVolunteerRole.Chapter_Name__c)) {
                if(volunteerManagerIdsMap.get(newVolunteerRole.Chapter_Name__c) != Null)
                    req.setNextApproverIds(new Id[] {volunteerManagerIdsMap.get(newVolunteerRole.Chapter_Name__c)});
                else
                    req.setNextApproverIds(new Id[] {userInfo.getUserId()});
            } else {
                req.setNextApproverIds(new Id[] {userInfo.getUserId()});
            }
            req.setProcessDefinitionNameOrId('Volunteer_Role_Approval_Process');
            req.setSkipEntryCriteria(true);
            approvalReqList.add(req);
        }
        if(approvalReqList.size() > 0)
        {
            List<Approval.ProcessResult> resultList = Approval.process(approvalReqList);
            
            for(Approval.ProcessResult result: resultList )
            {        
                System.debug('Submitted for approval successfully: '+result.isSuccess());      
            }
            
        }
        /* if(statusPendingList.size() > 0 ){
UpdateVolunteerRegisterdCount(statusPendingList ,null);
}*/
    }
    /*CreateCaseTeamMembers() is used to add the volunteers to case team member when the approver approve the 
volunteer opportunity record.*/ 
    Public Static Void CreateCaseTeamMembers(List<Volunteer_Opportunity__c> recordsForCreatingCaseTeams)
    {
        List<Volunteer_Opportunity__c> VolunteerRoleList = new List<Volunteer_Opportunity__c>();
        Set<String> roleName = new Set<String>();
        Set<Id> dbVolunteerSet = new Set<Id>();
        Map<Id,Set<CaseTeamMember>> updateCaseMemberCount = new Map<Id,Set<CaseTeamMember>>();
        Map<String,CaseTeamRole > teamMemberRoleMap = new Map<String,CaseTeamRole>();
        Map<Id,User> volunteerContactMap = new Map<Id,User>();
        Set<Id> volunteerSet = new Set<Id>();
        Set<Id> VoluteerNameSet = new Set<Id>();
        Set<Id> wishAssignedSet = new Set<Id>();
        CaseTeamRole caseRoleID = [SELECT id,Name from CaseTeamRole WHERE Name =: 'Wish Granter' Limit 1];
        Set<Id> wishIds = new Set<Id>();
        Map<Id,Set<String>> wishMembersMap = new Map<Id,Set<String>>();
        Map<Id,Id> volunteerUserMap = new Map<Id, Id>();
        Map<Id,Set<Id>> wishUserMap = new Map<Id,Set<Id>>(); //Used to hold wish related contact and user for contact access to volunteers
        Map<Id,Id> wishRelatedContactMap = new Map<Id,Id>();
        Constant_AC  constant = new Constant_AC();
        List<Contact> updateContactList = new List<Contact>();
        List<CaseTeamMember> CaseTeamMemberList = new List<CaseTeamMember>();
        Set<Id> parentWishIdSet = new Set<Id>();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        Id volunteerTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.volunteerTaskRT).getRecordTypeId();
        Map<Id, Id> volunteerMap = new map<Id, Id>();
        for(Volunteer_Opportunity__c newVolunteerRole : recordsForCreatingCaseTeams)
        {
            roleName.add(newVolunteerRole.Role__c);
            VoluteerNameSet.add(newVolunteerRole.Volunteer_Name__c);
            wishIds.add(newVolunteerRole.wish__c);
            parentWishIdSet.add(newVolunteerRole.wish__c);
            if(newVolunteerRole.Wish__c != null && newVolunteerRole.Role__c == 'Wish Granter') {
                if(!volunteerMap.containsKey(newVolunteerRole.Wish__c)) {
                    volunteerMap.put(newVolunteerRole.Wish__c, newVolunteerRole.Volunteer_Name__c);
                }
            }
            if(wishUserMap.containsKey(newVolunteerRole.wish__c)) {
                wishUserMap.get(newVolunteerRole.wish__c).add(newVolunteerRole.Volunteer_Name__c);
            } else {
                wishUserMap.put(newVolunteerRole.wish__c, new Set<Id>{newVolunteerRole.Volunteer_Name__c});
            }
            if(newVolunteerRole.Migrated_Record__c == false)
            {   
                Contact updateContact = new Contact();
                updateContact.id = newVolunteerRole.Volunteer_Name__c;
                updateContact.Date_of_last_engagement__c  = Date.Today();
                updateContactList.add(updateContact);
            }  
        }
        
        for(Case getRelatedContact : [SELECT Id, ContactId FROM Case WHERE Id IN : wishUserMap.keySet()]) {
            wishRelatedContactMap.put(getRelatedContact.Id, getRelatedContact.ContactId);
        }
        for(User contactUser : [SELECT Id, ContactId FROM User WHERE ContactId IN : VoluteerNameSet]) {
            volunteerUserMap.put(contactUser.ContactId, contactUser.Id);
        }
        System.debug('Volunteer User Map>>>: '+volunteerUserMap);
        for(CaseTeamRole  caseTem : [SELECT id,Name from CaseTeamRole]){
            teamMemberRoleMap.put(caseTem.Name,caseTem);
        }
        
        Map<Id, Id> contactUserInfoMap = new Map<Id, Id>();
        
        for(User commmunityUserInfo : [SELECT Id, ContactId FROM User WHERE ContactId != null]) {
            contactUserInfoMap.put(commmunityUserInfo.ContactId, commmunityUserInfo.Id);
        }
        
        Map<Id, CaseTeamMember> caseTeamMemberMap = new Map<Id, CaseTeamMember>();
        List<CaseTeamMember> updateRoleList = new List<CaseTeamMember>();
        for(CaseTeamMember dbcaseTeamMember : [SELECT id,MemberId, ParentId, TeamRole.Name, TeamRole.Id FROM CaseTeamMember WHERE ParentId IN :wishIds]){
            caseTeamMemberMap.put(dbcaseTeamMember.MemberId, dbcaseTeamMember);
            if(wishMembersMap.containsKey(dbcaseTeamMember.parentId))
                wishMembersMap.get(dbcaseTeamMember.parentId).add(dbcaseTeamMember.MemberId);
            else
                wishMembersMap.put(dbcaseTeamMember.parentId,new Set<String>{dbcaseTeamMember.MemberId});
        }
        
        
        Set<Id> userIdset = new Set<Id>();
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
        for(Task checkExistingTaskOwner : [SELECT Id, OwnerId, WhatId, RecordType.Name FROM Task WHERE WhatId IN : volunteerMap.keySet() AND RecordType.Name = 'Volunteer' AND isClosed = false]) {
            userIdset.add(checkExistingTaskOwner.OwnerId);
            if(taskMap.containsKey(checkExistingTaskOwner.WhatId)) {
                taskMap.get(checkExistingTaskOwner.WhatId).add(checkExistingTaskOwner);
            } else {
                taskMap.put(checkExistingTaskOwner.WhatId, new List<Task>{checkExistingTaskOwner});
            }
        }
        Set<Id> internalUserIdSet = new Set<Id>();
        for(User getUserInfo : [SELECT Id, ContactId FROM User WHERE Id IN : userIdset]) {
            if(getUserInfo.ContactId == null) {
                internalUserIdSet.add(getUserInfo.Id);
            }
        }
        List<Task> updateOwnerList = new List<Task>();
        for(Volunteer_Opportunity__c newVolunteerRole : recordsForCreatingCaseTeams)
        {
            if(newVolunteerRole.Role__c == 'Wish Granter' || newVolunteerRole.Role__c == 'Wish Granter Mentor') {
                if(taskMap.containsKey(newVolunteerRole.Wish__c)) {
                    for(Task checkOwner : taskMap.get(newVolunteerRole.Wish__c)) {
                        if(internalUserIdSet.contains(checkOwner.OwnerId)) {
                            if(contactUserInfoMap.containsKey(newVolunteerRole.Volunteer_Name__c)) {
                                checkOwner.OwnerId = contactUserInfoMap.get(newVolunteerRole.Volunteer_Name__c);
                                updateOwnerList.add(checkOwner);
                            }
                        }
                    }
                }
                
            }
            
            if(newVolunteerRole.Volunteer_Name__c != null && newVolunteerRole.wish__c != null){
                
                if(!wishMembersMap.containsKey(newVolunteerRole.wish__c) || (wishMembersMap.containsKey(newVolunteerRole.wish__c) && volunteerUserMap.containsKey(newVolunteerRole.Volunteer_Name__c)))
                {
                    
                    CaseTeamMember newCaseTeamMembers = new CaseTeamMember();
                    newCaseTeamMembers.ParentId = newVolunteerRole.Wish__c;
                    newCaseTeamMembers.MemberId = newVolunteerRole.Volunteer_Name__c;
                    if(volunteerUserMap.containsKey(newVolunteerRole.Volunteer_Name__c)) {
                        newCaseTeamMembers.MemberId = volunteerUserMap.get(newVolunteerRole.Volunteer_Name__c);
                        wishAssignedSet.add(newCaseTeamMembers.MemberId);
                    }
                    System.debug('Volunteer Role: '+newVolunteerRole.Role__c);
                    System.debug('Wish Member Map: '+wishMembersMap);
                    System.debug('Volunteer User Map: '+volunteerUserMap);
                    System.debug('wishMembersMap.get(newVolunteerRole.wish__c) '+wishMembersMap.get(newVolunteerRole.wish__c));
                    If(teamMemberRoleMap.containsKey(newVolunteerRole.Role__c) && !wishMembersMap.get(newVolunteerRole.wish__c).contains(volunteerUserMap.get(newVolunteerRole.Volunteer_Name__c))){
                        newCaseTeamMembers.TeamRoleId = teamMemberRoleMap.get(newVolunteerRole.Role__c).id;
                        CaseTeamMemberList.add(newCaseTeamMembers);
                    }
                    else if(teamMemberRoleMap.containsKey(newVolunteerRole.Role__c) && wishMembersMap.get(newVolunteerRole.wish__c).contains(volunteerUserMap.get(newVolunteerRole.Volunteer_Name__c)) && (newVolunteerRole.Role__c == 'Wish Granter' || newVolunteerRole.Role__c == 'Wish Granter Mentor')) {
                        newCaseTeamMembers.TeamRoleId = teamMemberRoleMap.get(newVolunteerRole.Role__c).id;
                        newCaseTeamMembers.Id = caseTeamMemberMap.get(volunteerUserMap.get(newVolunteerRole.Volunteer_Name__c)).Id;
                        CaseTeamMemberList.add(newCaseTeamMembers);
                    } 
                    else {
                        //newCaseTeamMembers.TeamRoleId = caseRoleID.id;
                    }
                    
                    if(newVolunteerRole.Role__c == 'Wish Granter' || newVolunteerRole.Role__c == 'Wish Granter Mentor') {
                        if(updateCaseMemberCount.containsKey(newVolunteerRole.Wish__c)){
                            updateCaseMemberCount.get(newVolunteerRole.Wish__c).add(newCaseTeamMembers);
                        }
                        else {
                            updateCaseMemberCount.put(newVolunteerRole.Wish__c, new Set<CaseTeamMember>{newCaseTeamMembers});
                        }
                    }
                    
                } else {
                    
                    
                }
            }
            
            
            if(caseTeamMemberMap.size() > 0 && contactUserInfoMap.containsKey(newVolunteerRole.Volunteer_Name__c) && caseTeamMemberMap.containsKey(contactUserInfoMap.get(newVolunteerRole.Volunteer_Name__c))) {
                if(caseTeamMemberMap.get(contactUserInfoMap.get(newVolunteerRole.Volunteer_Name__c)).TeamRole.Name.contains('Inactive')) {
                    if(teamMemberRoleMap.containsKey(caseTeamMemberMap.get(contactUserInfoMap.get(newVolunteerRole.Volunteer_Name__c)).TeamRole.Name.remove(' (Inactive)'))) {
                        CaseTeamMember updateInfo = new CaseTeamMember();
                        updateInfo.TeamRoleId = teamMemberRoleMap.get(caseTeamMemberMap.get(contactUserInfoMap.get(newVolunteerRole.Volunteer_Name__c)).TeamRole.Name.remove(' (Inactive)')).Id; 
                        updateInfo.Id = caseTeamMemberMap.get(contactUserInfoMap.get(newVolunteerRole.Volunteer_Name__c)).Id;
                        updateRoleList.add(updateInfo);
                    }
                }
            }
        }
        
        if(updateOwnerList.size() > 0) {
            update updateOwnerList; 
        }
        List<Task> birthDayTaskList = new List<Task>();
        for(Task birthdayTaskInfo : [SELECT Id, WhatId, Subject, OwnerId FROM Task WHERE Subject = 'Wish Child Birthday Reminder' AND WhatId IN : volunteerMap.keySet() AND isClosed = false AND RecordType.Name = 'Staff']) {
            if(volunteerMap.containsKey(birthdayTaskInfo.WhatId)) {
                if(contactUserInfoMap.containsKey(volunteerMap.get(birthdayTaskInfo.WhatId))) {
                    birthdayTaskInfo.OwnerId = contactUserInfoMap.get(volunteerMap.get(birthdayTaskInfo.WhatId));
                }
            }    
            birthdayTaskInfo.RecordTypeId = volunteerTaskRT;
            birthDayTaskList.add(birthdayTaskInfo);
        }
        if(birthDayTaskList.size() > 0) {
            update birthDayTaskList;
        }
        
        if(updateRoleList.size() > 0) {
            update updateRoleList;
        }
        
        if(updateContactList.size() > 0)
            update updateContactList;
        
        
        if(CaseTeamMemberList.size() > 0)
        {//wishRelatedContactMap, wishUserMap
            upsert CaseTeamMemberList;
            
            
            if(wishUserMap.size() > 0) {
                List<ContactShare> contactToShareList = new List<ContactShare>();
                List<CaseShare> caseShareList= new List<CaseShare>();
                
                for(Id caseId : wishUserMap.keySet()) {
                    if(wishUserMap.containsKey(caseId)) {
                        for(Id userId : wishUserMap.get(caseId)) {
                            ContactShare shareContact = new ContactShare();
                            shareContact.ContactAccessLevel = 'Read';
                            
                            if(wishRelatedContactMap.containsKey(caseId)) {
                                shareContact.ContactId = wishRelatedContactMap.get(caseId);
                            }
                            if(volunteerUserMap.containsKey(userId)) {
                                shareContact.UserOrGroupId = volunteerUserMap.get(userId);
                                contactToShareList.add(shareContact);
                            }
                        }
                    }
                }
                if(contactToShareList.size() > 0) {
                    insert contactToShareList;
                }
                
            }      
        }
        List<Case> updateCaseList = new List<Case>();
        if(updateCaseMemberCount.size() > 0)
        {
            for(Case getCase : [SELECT Id,CaseNumber,Case_Member_Count__c from Case WHERE Id IN :updateCaseMemberCount.keySet()])
            {
                Case updatCase = new Case();
                updatCase.id = getCase.id;
                updatCase.Assigned_Date__c = Date.Today();
                if(getCase.Case_Member_Count__c  == Null){
                    updatCase.Case_Member_Count__c = 0 + ((updateCaseMemberCount.get(getCase.id)).size());
                }
                else{
                    updatCase.Case_Member_Count__c = getCase.Case_Member_Count__c  + ((updateCaseMemberCount.get(getCase.id)).size());
                }
                updateCaseList.add(updatCase);  
            }
        }
        if(updateCaseList.size() > 0) {
            Update updateCaseList;
        }
        
        if(parentWishIdSet.size() > 0) {
            Map<Id, List<CaseTeamMember>> parentCaseTeamMemberMap = new Map<Id, List<CaseteamMember>>();
            Set<Id> subCaseIdSet = new Set<Id>();
            List<Case> subCaseList = new List<Case>();
            for(Case subCaseInfo : [SELECT Id,ParentId FROM Case WHERE ParentId IN : parentWishIdSet AND RecordType.Name != 'Wish']) {
                System.debug('SubCaseId>>>>>'+subCaseInfo.Id);
                subCaseIdSet.add(subCaseInfo.Id);
                subCaseList.add(subCaseInfo);
            }
            List<CaseTeamMember> deleteList = new List<CaseTeamMember>();
            if(subCaseIdSet.size() > 0) {
                for(CaseTeamMember caseTeamInfo : [SELECT Id,ParentId FROM CaseTeamMember WHERE ParentId IN : subCaseIdSet]) {
                    deleteList.add(caseTeamInfo);
                }
            }
            if(deleteList.size() > 0) {
                delete deleteList;
            }
            UpdateCaseTeamMemberForSubCase(parentWishIdSet, subCaseList);
        }
    }
    
    
    public static void UpdateCaseTeamMemberForSubCase(Set<Id> parentWishIdSet, List<Case> subCaseList) {
        System.debug('UpdateCaseTeamMemberForSubCase : parentWishIdSet>>>'+parentWishIdSet+'subCaseList>>>>>'+subCaseList);
        Map<Id, List<CaseTeamMember>> caseTeamMemeberMap = new Map<Id, List<CaseTeamMember>>();
        
        Map<String, Id> caseTeamRoleMap = new Map<String, Id>();
        for(CaseTeamRole caseTeamRole : [SELECT Id, Name FROM CaseTeamRole]) {
            caseTeamRoleMap.put(caseTeamRole.Name, caseTeamRole.Id);
        }
        Set<Id> inactiveUserMap = new Set<Id>();
        for(CaseTeamMember caseTeamInfo : [SELECT Id, MemberId, ParentId, TeamRoleId, TeamRole.Name FROM CaseTeamMember WHERE ParentId IN : parentWishIdSet ]) {
            inactiveUserMap.add(caseTeamInfo.MemberId);
            if(caseTeamMemeberMap.containsKey(caseTeamInfo.ParentId)) {
                caseTeamMemeberMap.get(caseTeamInfo.ParentId).add(caseTeamInfo);
            } else {
                caseTeamMemeberMap.put(caseTeamInfo.ParentId, new List<CaseTeamMember>{caseTeamInfo});
            }
        }
        Set<Id> inactiveMemberSet = new Set<Id>();
        for(User getInActiveUser : [SELECT Id, isActive FROM User WHERE IsActive = false]) {
            inactiveMemberSet.add(getInActiveUser.Id);
        }
        List<CaseTeamMember> newCaseTeamMemberList = new List<CaseTeamMember>();
        for(Case subCase : subCaseList) {
            if(caseTeamMemeberMap.containsKey(subCase.ParentId)) {
                for(CaseTeamMember caseTeam : caseTeamMemeberMap.get(subCase.ParentId)) {
                    System.debug('Contacins>>>'+subCase.Id);
                    if(!inactiveMemberSet.contains(caseTeam.MemberId)) {
                        CaseTeamMember newTeamMember = new CaseTeamMember();
                        newTeamMember.MemberId = caseTeam.MemberId;
                        newTeamMember.ParentId = subCase.Id;
                        newTeamMember.TeamRoleId = caseTeam.TeamRoleId;
                        newCaseTeamMemberList.add(newTeamMember);
                    }
                    
                    //insert newTeamMember;
                }
            }
        }
        if(newCaseTeamMemberList.size() > 0) {
            insert newCaseTeamMemberList;
        }
        if(caseTeamMemeberMap.size() > 0) {
            ChangeTaskOwnerFromInactiveToActive(caseTeamMemeberMap);
        }
    }
    
    public static void ChangeTaskOwnerFromInactiveToActive(Map<Id, List<CaseTeamMember>> caseTeamMemberMap) {
        
        System.debug('caseTeamMemberMap>>>>>>>>'+caseTeamMemberMap);
        Map<Id, Set<Id>> inactiveVolOppMap = new Map<Id, Set<Id>>();
        Set<Id> volOppContact = new Set<Id>();
        Map<Id,Id> vollOpActiveMap = new Map<Id, Id>();
        /*for(Volunteer_Opportunity__c volOppInfo : [SELECT Id, Wish__c, Volunteer_Name__c, Inactive__c FROM Volunteer_Opportunity__c WHERE Wish__C IN : caseTeamMemberMap.keySet() ORDER BY CreatedDate ASC]) {
volOppContact.add(volOppInfo.Volunteer_Name__c);
if(volOppInfo.Inactive__c == true) {
if(inactiveVolOppMap.containsKey(volOppInfo.Wish__C)) {
inactiveVolOppMap.get(volOppInfo.Wish__C).add(volOppInfo.Volunteer_Name__c);
} else {
inactiveVolOppMap.put(volOppInfo.Wish__C, new Set<Id>{volOppInfo.Volunteer_Name__c});
}
} else if(volOppInfo.Inactive__c == false && volOppInfo.Volunteer_Name__c != null) {
if(!vollOpActiveMap.containsKey(volOppInfo.Wish__C)) {
vollOpActiveMap.put(volOppInfo.Wish__C, volOppInfo.Volunteer_Name__c);
}
}

}*/
        
        
        Map<Id,Id> activeVolunteerMap = new Map<Id,Id>();
        for(CaseTeamMember caseTeamInfo : [SELECT Id, TeamRole.Name, ParentId, MemberId FROM CaseTeamMember WHERE (TeamRole.Name = 'Wish Granter' OR TeamRole.Name = 'Wish Granter (Inactive)') AND ParentId IN : caseTeamMemberMap.keySet() ORDER BY CreatedDate ASC]) {
            if(caseTeamInfo.TeamRole.Name == 'Wish Granter') {
                if(!activeVolunteerMap.containsKey(caseTeamInfo.ParentId)) {
                    activeVolunteerMap.put(caseTeamInfo.ParentId, caseTeamInfo.MemberId);
                }
            } else if(caseTeamInfo.TeamRole.Name == 'Wish Granter (Inactive)') {
                if(inactiveVolOppMap.containsKey(caseTeamInfo.ParentId)) {
                    inactiveVolOppMap.get(caseTeamInfo.ParentId).add(caseTeamInfo.MemberId);
                } else {
                    inactiveVolOppMap.put(caseTeamInfo.ParentId, new Set<Id>{caseTeamInfo.MemberId});
                }
            }
            
        }
        
        //if(volOppContact.size() > 0) {
        Map<Id, Id> contactUserMap = new Map<Id, Id>();
        Map<Id,Id> conUserIdMap = new Map<Id, Id>();
        for(User userInfo : [SELECT Id, ContactId FROM User WHERE ContactId IN : volOppContact]) {
            contactUserMap.put(userInfo.Id, userInfo.ContactId);
            conUserIdMap.put(userInfo.ContactId, userInfo.Id);
        }
        
        
        
        List<Task> taskOwnerUpdateList = new List<Task>();
        for(Task getAllTask : [SELECT Id, OwnerId, WhatId FROM Task WHERE WhatId IN : inactiveVolOppMap.keySet() AND isClosed = false]) {
            if(inactiveVolOppMap.containsKey(getAllTask.WhatId)) {
                if(inactiveVolOppMap.get(getAllTask.WhatId).contains(getAllTask.OwnerId)) {
                    if(activeVolunteerMap.containsKey(getAllTask.WhatId)) {
                        getAllTask.OwnerId = activeVolunteerMap.get(getAllTask.WhatId);
                        taskOwnerUpdateList.add(getAllTask);
                    }
                }
            }
        }
        if(taskOwnerUpdateList.size() > 0) {
            update taskOwnerUpdateList;
        }
        //}
        
    }
    
    
    /*This updateVolunteerRegisterdCount() is used to update count of the number of volunteer opportunities that are registered for the corresponding NonWish & Event .*/
    public static void UpdateVolunteerRegisterdCount(List<Volunteer_Opportunity__c> nonWishListtoupdatecount,Set<id> nonWishRegisteredUpdateSet,boolean isdelete){
        RecursiveTriggerHandler.isFirstTime = false;
        system.debug('@@@@@@@ UpdateVolunteerRegisterdCount CALLED  @@@@@@@@@'+nonWishListtoupdatecount);
        Set<Id> chapterRoleIdSet = new Set<Id>();
        Set<Id> NonWishEventIdSet = new Set<Id>();
        Set<String> DescriptionSetId = new Set<String>();
        Map<Id,Integer> volunteercountMap = new Map<Id,Integer>();
        // Map<Id,Volunteer_Opportunity__c> volunteerMap = new Map<Id,Volunteer_Opportunity__c>();
        List<Volunteer_Count__c > updateVolunteerCountList = new List<Volunteer_Count__c>();
        boolean isRegistered = false;
        boolean isPending = false;
        for(Volunteer_Opportunity__c newVolOpp :nonWishListtoupdatecount){
            chapterRoleIdSet .add(newVolOpp.Chapter_Role_Opportunity__c);
            DescriptionSetId.add(newVolOpp.Hidden_VolunteerCount_Desc__c+''+newVolOpp.Date__c+''+newVolOpp.Start_Time__c+''+newVolOpp.End_Time__c);
            system.debug('chapterRoleIdSet '+chapterRoleIdSet);
            NonWishEventIdSet.add(newVolOpp.Non_Wish_Event__c);
            system.debug('NonWishEventIdSet'+NonWishEventIdSet);
            
            system.debug('newVolOpp.HiddenVolunteer_Count_Description__c'+newVolOpp.HiddenVolunteer_Count_Description__c);
            
            if((newVolOpp.Inactive__c == true && newVolOpp.Reason_Inactive__c != Null && newVolOpp.Status__c == 'Approved') || (newVolOpp.Inactive__c == true && newVolOpp.Reason_Inactive__c != Null && newVolOpp.Reason_Inactive__c == 'Not Approved')){
                isdelete = true;
                if(isdelete == true)
                    isRegistered = true;
                System.debug('isRegistered'+isRegistered);
            } 
            if(newVolOpp.Status__c == 'Pending' && isdelete == false) 
                isPending = true;
            
        }
        List<AggregateResult> groupedResults = [SELECT Chapter_Role_Opportunity__c nonwish, Count(Id)aver,Hidden_VolunteerCount_Desc__c FROM Volunteer_Opportunity__c WHERE Non_Wish_Event__c IN: NonWishEventIdSet  AND Volunteer_Name__c  != Null AND (Reason_Inactive__c = Null OR Reason_Inactive__c != Null) AND Chapter_Role_Opportunity__c IN: chapterRoleIdSet AND id IN : nonWishRegisteredUpdateSet GROUP BY Chapter_Role_Opportunity__c,Hidden_VolunteerCount_Desc__c,Date__c,Start_Time__c,End_Time__c];
        System.debug('**groupedResults**'+groupedResults);
        if(!groupedResults.isEmpty()){
            for(AggregateResult arr : groupedResults){
                volunteercountMap.put((ID)arr.get('nonwish'),(integer)arr.get('aver'));
                System.debug('!@volunteercountMap@!'+volunteercountMap);
            }
        }
        if(volunteercountMap.size() > 0){
            for(Volunteer_Count__c dbVolunteerCount : [SELECT Id,Name,Volunteer_Needed__c,Non_Wish_Events__c,Chapter_Role__c,Registered__c,Description__c,Start_Time__c,End_Time__c,Date__c From Volunteer_Count__c  WHERE Chapter_Role__c IN: volunteercountMap.Keyset()]){
                if(NonWishEventIdSet.contains(dbVolunteerCount.Non_Wish_Events__c)){
                    if(DescriptionSetId.contains(dbVolunteerCount.Description__c+''+dbVolunteerCount.Date__c+''+dbVolunteerCount.Start_Time__c+''+dbVolunteerCount.End_Time__c)){
                        if(volunteercountMap.containsKey(dbVolunteerCount.Chapter_Role__c)){
                            dbVolunteerCount.Registered__c  = volunteercountMap.get(dbVolunteerCount.Chapter_Role__c);
                            system.debug('groupedResults'+dbVolunteerCount.Registered__c);
                            if(isPending == true){
                                dbVolunteerCount.Registered__c = dbVolunteerCount.Registered__c + 1;
                                System.debug('dbVolunteerCount.Registered__c'+dbVolunteerCount.Registered__c);
                            }
                            if(dbVolunteerCount.Registered__c > 0 && isRegistered == true)
                                System.debug('dbVolunteerCount.Registered__c'+dbVolunteerCount.Registered__c);
                            dbVolunteerCount.Registered__c = dbVolunteerCount.Registered__c - 1;
                            System.debug('dbVolunteerCount.Registered__c'+dbVolunteerCount.Registered__c);
                            updateVolunteerCountList.add(dbVolunteerCount);
                        }
                    }
                }
            }
            update updateVolunteerCountList;
        }
        else{
            for(Volunteer_Count__c dbVolunteerCount : [SELECT Id,Name,Volunteer_Needed__c,Non_Wish_Events__c,Chapter_Role__c,Registered__c,Description__c,Start_Time__c,End_Time__c,Date__c From Volunteer_Count__c  WHERE Chapter_Role__c IN: chapterRoleIdSet ]){
                if(NonWishEventIdSet.contains(dbVolunteerCount.Non_Wish_Events__c)){
                    if(DescriptionSetId.contains(dbVolunteerCount.Description__c+''+dbVolunteerCount.Date__c+''+dbVolunteerCount.Start_Time__c+''+dbVolunteerCount.End_Time__c)){
                        // dbVolunteerCount.Registered__c  = 0;
                        if(dbVolunteerCount.Registered__c > 0 && isRegistered == true)
                         System.debug('dbVolunteerCount.Registered__c'+dbVolunteerCount.Registered__c);
                        dbVolunteerCount.Registered__c = 0;
                        System.debug('dbVolunteerCount.Registered__c'+dbVolunteerCount.Registered__c);
                        updateVolunteerCountList.add(dbVolunteerCount);
                        System.debug('updateVolunteerCountList'+updateVolunteerCountList);
                    }
                }
            }
        }
        update updateVolunteerCountList;
    }
    
    /*This updatevolunteerNeededCount() is used to update count of the number of volunteer opportunities that are created for the corresponding NonWish & Event.*/
    public static void UpdatevolunteerNeededCount(List<Volunteer_Opportunity__c> nonWishListtoupdatecount){
        Set<Id> chapterRoleIdSet = new Set<Id>();
        Set<Id> NonWishEventIdSet = new Set<Id>();
        set<String> volunteercountDescSet = new Set<String>();
        List<Volunteer_Count__c > volunteercountIdList = new List<Volunteer_Count__c>();
        boolean isRegistered = false;
        Map<Id,Integer> volunteercountMap = new Map<Id,Integer>();
        List<Volunteer_Count__c > updateVolunteerCountList = new List<Volunteer_Count__c>();
        for(Volunteer_Opportunity__c newVolOpp :nonWishListtoupdatecount){
            chapterRoleIdSet .add(newVolOpp.Chapter_Role_Opportunity__c);
            NonWishEventIdSet .add(newVolOpp.Non_Wish_Event__c);
            volunteercountDescSet.add(newVolOpp.Hidden_VolunteerCount_Desc__c+''+newVolOpp.Date__c+''+newVolOpp.Start_Time__c+''+newVolOpp.End_Time__c);
        }
        List<AggregateResult> groupedResults = [SELECT Chapter_Role_Opportunity__c nonwish, Count(Id)aver,Hidden_VolunteerCount_Desc__c   FROM Volunteer_Opportunity__c WHERE Non_Wish_Event__c IN: NonWishEventIdSet AND Reason_Inactive__c = Null AND Chapter_Role_Opportunity__c IN: chapterRoleIdSet GROUP BY Chapter_Role_Opportunity__c,Hidden_VolunteerCount_Desc__c,Date__c,Start_Time__c,End_Time__c];
        if(!groupedResults.isEmpty()){
            for(AggregateResult arr : groupedResults){
                volunteercountMap.put((ID)arr.get('nonwish'),(integer)arr.get('aver'));
            }
        }
        if(volunteercountMap.size() > 0){
            for(Volunteer_Count__c dbVolunteerCount : [SELECT Id,Name,Volunteer_Needed__c,Non_Wish_Events__c,Chapter_Role__c,Registered__c,Description__c,Start_Time__c,End_Time__c,Date__c From Volunteer_Count__c  WHERE Chapter_Role__c IN: volunteercountMap.Keyset()]){
                if(NonWishEventIdSet .contains(dbVolunteerCount.Non_Wish_Events__c)){
                    if(volunteercountMap.containsKey(dbVolunteerCount.Chapter_Role__c)){
                        if(volunteercountDescSet.contains(dbVolunteerCount.Description__c+''+dbVolunteerCount.Date__c+''+dbVolunteerCount.Start_Time__c+''+dbVolunteerCount.End_Time__c)){
                            //dbVolunteerCount.Volunteer_Needed__c = volunteercountMap.get(dbVolunteerCount.Chapter_Role__c);
                            if(dbVolunteerCount.Volunteer_Needed__c > 0)
                                dbVolunteerCount.Volunteer_Needed__c = dbVolunteerCount.Volunteer_Needed__c - 1;
                            updateVolunteerCountList.add(dbVolunteerCount);
                        }
                    }
                }
            }
            update updateVolunteerCountList;
        }
        else{
            for(Volunteer_Count__c dbVolunteerCount : [SELECT Id,Name,Volunteer_Needed__c,Non_Wish_Events__c,Chapter_Role__c,Registered__c,Description__c,Start_Time__c,End_Time__c,Date__c From Volunteer_Count__c  WHERE Chapter_Role__c IN: chapterRoleIdSet ]){
                if(NonWishEventIdSet.contains(dbVolunteerCount.Non_Wish_Events__c)){
                    if(volunteercountDescSet.contains(dbVolunteerCount.Description__c+''+dbVolunteerCount.Date__c+''+dbVolunteerCount.Start_Time__c+''+dbVolunteerCount.End_Time__c)){
                        dbVolunteerCount.Volunteer_Needed__c = 0;
                        updateVolunteerCountList.add(dbVolunteerCount);
                        volunteercountIdList.add(dbVolunteerCount);
                    }
                }
            } 
            update updateVolunteerCountList;
            //delete volunteercountIdList;
        }
    }
    
    /* public static void updateVolunteerWishGrantedCount(List<Volunteer_Opportunity__c> volOpportunities){
Constant_AC  constant = new Constant_AC();
Id volunteerRecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
Set<Id> volContactId = new Set<Id>();
Map<Id,Integer> volunteercountMap = new Map<Id,Integer>();
List<Contact> volunteerContactList = new List<Contact>();
for(Volunteer_Opportunity__c  dbVolOpp : volOpportunities){

volContactId.add(dbVolOpp.Volunteer_Name__c);
}
List<AggregateResult> groupedResults = [SELECT Volunteer_Name__c volCount, Count(Id)aver  FROM Volunteer_Opportunity__c WHERE Volunteer_Name__c  IN: volContactId AND Wish__c != Null AND Wish__r.Status = 'Granted' GROUP BY Volunteer_Name__c ];

if(!groupedResults.isEmpty()){
for(AggregateResult arr : groupedResults){
volunteercountMap.put((ID)arr.get('volCount'),(integer)arr.get('aver'));

}
}

if(volunteercountMap.size() > 0){
for(Contact dbVolunteerContact : [SELECT Id,Number_of_wishes_granted__c,RecordTypeId FROM Contact where Id IN:volunteercountMap.KeySet() AND RecordTypeId =: volunteerRecordTypeId ]){
if(volunteercountMap.containsKey(dbVolunteerContact.Id)){
dbVolunteerContact.Number_of_wishes_granted__c  = volunteercountMap.get(dbVolunteerContact.Id);
volunteerContactList.add(dbVolunteerContact);
}
}
}

else{
for(Contact dbVolunteerContact : [SELECT Id,Number_of_wishes_granted__c FROM Contact where Id IN: volContactId]){
if(volContactId.contains(dbVolunteerContact.Id)){
dbVolunteerContact.Number_of_wishes_granted__c  = 0;
volunteerContactList.add(dbVolunteerContact);
}
}
}
if(volunteerContactList.size() > 0)
update volunteerContactList;
}*/
    
    
    /* public static void updateVolunteerWishAssignedCount(Set<Id> wishIdSet){

Constant_AC  constant = new Constant_AC();
Id volunteerRecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
List<Contact> updateContactList = new List<Contact>();
Map<Id,Integer> volunteercountMap = new Map<Id,Integer>();
Map<Id,Id> sobjectMap = new Map<Id,Id>();
List<AggregateResult> groupedResults = [SELECT Wish__c volCount, Count_Distinct(Wish__r.Id)aver  FROM Volunteer_Opportunity__c WHERE Wish__c  IN: wishIdSet AND Wish__c != Null GROUP BY Wish__c ];
if(!groupedResults.isEmpty()){
for(AggregateResult arr : groupedResults){
volunteercountMap.put((ID)arr.get('volCount'),(integer)arr.get('aver'));

} 
}
for(Volunteer_Opportunity__c  dbVoluOpportunity : [SELECT Id,Wish__c,Volunteer_Name__c From Volunteer_Opportunity__c WHERE Wish__c IN: volunteercountMap.KeySet() AND Status__c = 'Approved']){
sobjectMap.put(dbVoluOpportunity.Volunteer_Name__c,dbVoluOpportunity.Wish__c); 
} 

for(Contact dbVolunteerCon : [SELECT Id,Number_of_wishes_active__c,RecordTypeId FROM Contact where Id IN: sobjectMap.KeySet() AND RecordTypeId =: volunteerRecordTypeId]){
if(sobjectMap.containsKey(dbVolunteerCon.Id)){
Contact newCon = new Contact();
newCon.Id = dbVolunteerCon.Id;
if(volunteercountMap.containsKey(sobjectMap.get(dbVolunteerCon.Id))){
if(dbVolunteerCon.Number_of_wishes_active__c != Null && Integer.valueOf(dbVolunteerCon.Number_of_wishes_active__c) > 0 ){
newCon.Number_of_wishes_active__c =Integer.valueOf(dbVolunteerCon.Number_of_wishes_active__c) + Integer.valueOf(volunteercountMap.get(sobjectMap.get(dbVolunteerCon.Id)));

}else{
newCon.Number_of_wishes_active__c =  Integer.valueOf(volunteercountMap.get(sobjectMap.get(dbVolunteerCon.Id)));
system.debug('@@@@@@@@@@ ELSE IF newCon.Number_of_wishes_active__c @@@@@@@@@@@'+ newCon.Number_of_wishes_active__c);
}
updateContactList.add(newCon);
}
}
}  
if(updateContactList.size() > 0)
update updateContactList;
}*/
    
    public static void CreateNewVolunteerOpportunity(List<Volunteer_Opportunity__c > volunteerOpportunityList,Set<Id> volunteerOppIdSet){
        RecursiveTriggerHandler.isFirstTime = false;
        Constant_AC  constant = new Constant_Ac(); 
        Id nonWishEvents = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.nonWishEventRT).getRecordTypeId();
        Id wishEvents = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        List<Volunteer_Opportunity__c> createNewVolunteerOpportunityList = new List<Volunteer_Opportunity__c>();
        List<Volunteer_Opportunity__c> updateList = new List<Volunteer_Opportunity__c>();
        boolean isPending = false;
        Set<Id> wishIdSet = new Set<Id>();
        Set<Id> parentIdset = new Set<Id>();
        List<CaseTeamMember> removeCaseTeamMemberList = new List<CaseTeamMember>();
        Set<Id> volunteerNamesSet = new Set<Id>();
        Map<Id, String> caseTeamIdMap = new Map<Id, String>();
        Map<String, Id> caseTeamNameMap = new Map<String, Id>();
        Map<Id, Set<Id>> inActiveOwners = new Map<Id, Set<Id>>();
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id,String> wishStatusMap = new Map<Id,String>();
                
        for(Volunteer_Opportunity__c  currRec : [SELECT Id,Wish__c,Wish__r.Status FROM Volunteer_Opportunity__c  WHERE Id IN :volunteerOppIdSet AND Wish__c != Null]){
            wishStatusMap.put(currRec.Wish__C,currRec.Wish__r.Status);
        }
        
        for(CaseTeamRole caseTeamInfo : [Select Id, Name FROM CaseTeamRole]) {
            caseTeamIdMap.put(caseTeamInfo.Id, caseTeamInfo.Name);
            caseTeamNameMap.put(caseTeamInfo.Name, caseTeamInfo.Id);
        }
       
        for(Volunteer_Opportunity__c  processVolOpportunity : volunteerOpportunityList)
        {
            Volunteer_Opportunity__c newVolOpportunity = new Volunteer_Opportunity__c();
            newVolOpportunity.Chapter_Name__c = processVolOpportunity.Chapter_Name__c;
            newVolOpportunity.Chapter_Role_Opportunity__c = processVolOpportunity.Chapter_Role_Opportunity__c;
            newVolOpportunity.Date_Time__c = processVolOpportunity.Date_Time__c;
            newVolOpportunity.Hidden_VolunteerCount_Desc__c = processVolOpportunity.Hidden_VolunteerCount_Desc__c;
            newVolOpportunity.Description__c = processVolOpportunity.Description__c;
            newVolOpportunity.Start_Time__c = processVolOpportunity.Start_Time__c ;
            newVolOpportunity.End_Time__c = processVolOpportunity.End_Time__c;
            newVolOpportunity.Date__c = processVolOpportunity.Date__c;
            newVolOpportunity.Location__c = processVolOpportunity.Location__c;
            newVolOpportunity.HiddenVolunteer_Count_Description__c  = processVolOpportunity.HiddenVolunteer_Count_Description__c ;
            volunteerNamesSet.add(processVolOpportunity.Volunteer_Name__c);
            
            if(processVolOpportunity.Non_Wish_Event__c != null){
                newVolOpportunity.Non_Wish_Event__c = processVolOpportunity.Non_Wish_Event__c;
                newVolOpportunity.RecordTypeId = nonWishEvents;
            }
            newVolOpportunity.Required_Forms_for_Volunteers__c = processVolOpportunity.Required_Forms_for_Volunteers__c;
            newVolOpportunity.Volunteer_Notes__c = processVolOpportunity.Volunteer_Notes__c ;
            if(processVolOpportunity.Wish__c != null && wishStatusMap.get(processVolOpportunity.Wish__C) != 'Closed'){
                contactIdSet.add(processVolOpportunity.Volunteer_Name__c);
                if(inActiveOwners.containsKey(processVolOpportunity.Wish__c)) {
                    inActiveOwners.get(processVolOpportunity.Wish__c).add(processVolOpportunity.Volunteer_Name__c);
                } else {
                    inActiveOwners.put(processVolOpportunity.Wish__c, new Set<Id>{processVolOpportunity.Volunteer_Name__c});
                }
                newVolOpportunity.Wish__c = processVolOpportunity.Wish__c; 
                newVolOpportunity.RecordTypeId = wishEvents ;
                wishIdSet.add(processVolOpportunity.Wish__c );
                parentIdset.add(processVolOpportunity.Wish__c);
            }
            if(processVolOpportunity.Reason_Inactive__c == 'Not Approved'){
                Volunteer_Opportunity__c updateVolOpp = new Volunteer_Opportunity__c();
                updateVolOpp.id = processVolOpportunity.Id;
                updateVolOpp.Inactive__c = true;
                updateList.add(updateVolOpp);
            } 
            createNewVolunteerOpportunityList.add(newVolOpportunity);
        }
        
        Map<Id, Id> contactUserMap = new Map<Id, Id>();
        for(User userInfo : [SELECT Id, ContactId FROM User WHERE ContactId IN : contactIdSet]) {
            contactUserMap.put(userInfo.Id, userInfo.ContactId);
        }
        Map<Id,Id> activeVolunteerMap = new Map<Id,Id>();
        
        for(CaseTeamMember caseTeamInfo : [SELECT Id, TeamRole.Name, ParentId, MemberId FROM CaseTeamMember WHERE (TeamRole.Name = 'Wish Granter' OR TeamRole.Name = 'Wish Granter Mentor') AND ParentId IN : inActiveOwners.keySet() ORDER BY CreatedDate ASC]) {
            if(!activeVolunteerMap.containsKey(caseTeamInfo.ParentId) && !contactUserMap.containsKey(caseTeamInfo.MemberId)) {
                activeVolunteerMap.put(caseTeamInfo.ParentId, caseTeamInfo.MemberId);
            }
        }
        Map<Id, Id> caseOwnerMap = new Map<Id, Id>();
        
        for(Case ownerMap : [SELECT Id, OwnerId FROM Case WHERE Id IN : wishStatusMap.keySet()]) {
            caseOwnerMap.put(ownerMap.Id, ownerMap.OwnerId);
        }
        List<Task> taskOwnerUpdateList = new List<Task>();
        for(Task getAllTask : [SELECT Id, OwnerId, Task_Type__c, WhatId FROM Task WHERE WhatId IN : inActiveOwners.keySet() AND isClosed = false]) {
            if(inActiveOwners.containsKey(getAllTask.WhatId)) {
                if(inActiveOwners.get(getAllTask.WhatId).contains(contactUserMap.get(getAllTask.OwnerId))) {
                    if(activeVolunteerMap.containsKey(getAllTask.WhatId) && getAllTask.Task_Type__c != null) {
                        getAllTask.OwnerId = activeVolunteerMap.get(getAllTask.WhatId);
                        taskOwnerUpdateList.add(getAllTask);
                    } else {
                        getAllTask.OwnerId = caseOwnerMap.get(getAllTask.WhatId);
                        taskOwnerUpdateList.add(getAllTask);
                    }
                }
            }
        }
        if(taskOwnerUpdateList.size() > 0) {
            update taskOwnerUpdateList; 
        }
        Set<Id> userIds = new Set<Id>();
        if(volunteerNamesSet.size() > 0)
        {
            for(User currUser : [SELECT id FROM User WHERE contactId IN :volunteerNamesSet])
            {
                userIds.add(currUser.id); 
            }
        }
        List<Case> subCaseList = new List<Case>();
        Set<Id> subCaseIdSet = new Set<Id>();
        for(Case getChildCaseId : [SELECT Id, ParentId FROM Case WHERE ParentId IN : wishIdSet]) {
            parentIdset.add(getChildCaseId.Id);
            subCaseList.add(getChildCaseId);
            subCaseIdSet.add(getChildCaseId.Id);
        }
        
        List<CaseteamMember> deleteList = new List<CaseTeamMember>();
        if(subCaseIdSet.size() > 0) {
            for(CaseTeamMember caseTeamInfo : [SELECT Id,ParentId FROM CaseTeamMember WHERE ParentId IN : subCaseIdSet]) {
                deleteList.add(caseTeamInfo);
            }
        }
        if(deleteList.size() > 0) {
            delete deleteList;
        }
        Map<Id,String> volunteerOppMap = new Map<Id, String>();
        for(Volunteer_Opportunity__c getActiveVolOpp : [SELECT Id, Volunteer_Name__c, Wish__c, Role__c FROM Volunteer_Opportunity__c WHERE Volunteer_Name__c IN : volunteerNamesSet AND Wish__c != NULL AND Status__c = 'Approved' AND Wish__c IN : wishStatusMap.keySet()]) {
            System.debug('********'+getActiveVolOpp.Role__c);
            if(!volunteerOppIdSet.contains(getActiveVolOpp.Id)) {
                System.debug('&&&&&&&&&&&'+getActiveVolOpp.Role__c);
                volunteerOppMap.put(getActiveVolOpp.Volunteer_Name__c,getActiveVolOpp.Role__c);
            }
        }
        System.debug('volunteerOppMap: '+volunteerOppMap);
        List<Case> updateinactiveList = new List<Case>();
        Set<id> parentCaseId = new Set<id>();
        for(CaseTeamMember dbcaseTeamMember : [SELECT id,MemberId, ParentId, TeamRoleId, TeamRole.Name  FROM CaseTeamMember WHERE ParentId IN : parentIdset AND MemberId IN :userIds]){
            if(caseTeamIdMap.size() > 0 && caseTeamIdMap.containsKey(dbcaseTeamMember.TeamRoleId)) {
                if(contactUserMap.containsKey(dbcaseTeamMember.MemberId)) {
                    if(volunteerOppMap.containsKey(contactUserMap.get(dbcaseTeamMember.MemberId))) {
                        dbcaseTeamMember.TeamRoleId = caseTeamNameMap.get(volunteerOppMap.get(contactUserMap.get(dbcaseTeamMember.MemberId)));
                        removeCaseTeamMemberList.add(dbcaseTeamMember);
                        parentCaseId.add(dbcaseTeamMember.ParentId);
                    } else if(caseTeamNameMap.containsKey(dbcaseTeamMember.TeamRole.Name +' (Inactive)')) {
                        dbcaseTeamMember.TeamRoleId = caseTeamNameMap.get(dbcaseTeamMember.TeamRole.Name +' (Inactive)');
                        removeCaseTeamMemberList.add(dbcaseTeamMember);
                        parentCaseId.add(dbcaseTeamMember.ParentId);
                    }
                }
            }
        }
        if(parentCaseId.size()>0){
            Case parentCase = new Case();
            for(Case newCase : [SELECT id,Hidden_VOinactive__c FROM Case WHERE Id IN : parentCaseId ]){
                ParentCase.id = newCase.id;
                ParentCase.Hidden_VOinactive__c = true;
                //newCase.Hidden_VOinactive__c = true;
                updateinactiveList.add(ParentCase); 
            }
            
        }
        
        
        if(removeCaseTeamMemberList.size() > 0) {
            update removeCaseTeamMemberList;
        }
        if(updateinactiveList.size() > 0){
            update updateinactiveList;
        }
        if(createNewVolunteerOpportunityList.size() > 0)
            insert createNewVolunteerOpportunityList;
        if(updateList.size() > 0) {
            update updateList; 
        }
        
        if(subCaseList.size() > 0 && wishIdSet.size() > 0) {
            UpdateCaseTeamMemberForSubCase(wishIdSet, subCaseList);
        }
        //updateVolunteerRegisterdCount(createNewVolunteerOpportunityList,null);
    }
    
    public void updateUserRoleId(Set<Id> updateUserSet,Set<Id> volcontactIds){
        String roleIdinVolOpp;
        String roleInUser;
        Set<Id> volConId = new Set<Id>();
        List<User> dbVolConList = new List<User>();
        for(Volunteer_Opportunity__c  dbOpportunity : [SELECT Id,Volunteer_Name__c ,Non_Wish_Event__c,Chapter_Role_Opportunity__c,Chapter_Role_Opportunity__r.Role_Name__c FROM Volunteer_Opportunity__c WHERE Id IN:updateUserSet]){
            volConId.add(dbOpportunity.Volunteer_Name__c);
            system.debug('@@@@@@@@ volConId @@@@@@@@@'+volConId);
            roleIdinVolOpp = dbOpportunity.Chapter_Role_Opportunity__r.Role_Name__c+String.Valueof(dbOpportunity.Non_Wish_Event__c);
            system.debug('@@@@@@@@ roleIdinVolOpp @@@@@@@@@'+roleIdinVolOpp);
        }
        
        for(User dbVolUser : [SELECT Id,ContactId,Hidden_Role_Name_Id__c FROM User WHERE ContactId IN: volcontactIds ]){
            if(dbVolUser.Hidden_Role_Name_Id__c != Null  && dbVolUser.Hidden_Role_Name_Id__c != ''){
                system.debug('@@@@@@@@ roleInUser @@@@@@@@@'+dbVolUser);
                roleInUser = dbVolUser.Hidden_Role_Name_Id__c ;
                system.debug('@@@@@@@@ roleInUser @@@@@@@@@'+roleInUser);
                if(roleInUser.contains(roleIdinVolOpp)){
                    system.debug('@@@@@@@@ roleInUser IF @@@@@@@@@'+roleInUser);
                    roleInUser.remove(roleIdinVolOpp);
                    string s2 = roleInUser.remove(roleIdinVolOpp);
                    dbVolUser.Hidden_Role_Name_Id__c  = s2;
                    system.debug('@@@@@@@@ s2 @@@@@@@@@'+s2); 
                    dbVolConList.add(dbVolUser);
                }
            }
        }
        
        if(dbVolConList.size() > 0) 
            update  dbVolConList;
    }
    /***************** Number Of Assignment ***********/
    public static void Updatecontacts(Set <ID> volunteerOppName){
        List<Contact> conList=new List<Contact>();
        for(Contact  Con:[SELECT Id,Number_of_Assignments__c,Name,(select id,Volunteer_Name__c from Volunteer_Opportunities__r where Volunteer_Name__c IN:volunteerOppName) FROM Contact  WHERE ID IN:volunteerOppName]){
            Contact cont=new Contact();
            cont.Number_of_Assignments__c=Con.Volunteer_Opportunities__r.size();
            cont.id=Con.Id;
            conList.add(cont);
        }
        update conList;
    }
    
    public static void ActiveWishCount(set<Id> volunteerIdsSet){
        set<string> parentWishIdsSet = new set<string>();
        set<Id> volunteerNameSet = new set<Id>();
        string key;
        list<Contact> updateActiveWishCount = new list<Contact>();
        Map<Id,Integer> volunteerWithCount = new Map<id,Integer>();
        for(Volunteer_Opportunity__c currVolOpp : [SELECT ID,Wish__c,Wish__r.Status,Volunteer_Name__c,Status__c FROM Volunteer_Opportunity__c WHERE 
                                                   Status__c = 'Approved' AND (Wish__r.Status != 'Granted' AND Volunteer_Name__c IN: volunteerIdsSet AND Wish__r.Status != 'Completed')]){
                                                       key = currVolOpp.Wish__c + '_' + currVolOpp.Volunteer_Name__c;
                                                       system.debug('Inside if parentWishIdsSet**'+parentWishIdsSet);
                                                       
                                                       if(!parentWishIdsSet.contains(key)){
                                                           parentWishIdsSet.add(key);
                                                           system.debug('Inside if volunteerNameSet**'+volunteerNameSet);
                                                           
                                                           if(volunteerNameSet.contains(currVolOpp.Volunteer_Name__c)){
                                                               system.debug('Inside if volunteerNameSet**'+volunteerWithCount);
                                                               volunteerWithCount.put(currVolOpp.Volunteer_Name__c,volunteerWithCount.get(currVolOpp.Volunteer_Name__c)+1);
                                                           }
                                                           else{
                                                               system.debug('Inside else**'+currVolOpp.Volunteer_Name__c);
                                                               volunteerWithCount.put(currVolOpp.Volunteer_Name__c,1);
                                                               volunteerNameSet.add(currVolOpp.Volunteer_Name__c);
                                                           }
                                                       }
                                                   }
        system.debug('volunteerWithCount**'+ volunteerWithCount);
        
        for(Contact volunteerContact : [SELECT ID,Number_of_wishes_active__c From Contact WHERE ID IN: volunteerIdsSet]){
            if(volunteerWithCount.containsKey(volunteerContact.Id)){
                volunteerContact.Number_of_wishes_active__c = volunteerWithCount.get(volunteerContact.Id);
                updateActiveWishCount.add(volunteerContact);
                
            }
            
        }
        if(updateActiveWishCount.size() > 0){
            Update updateActiveWishCount;
        }
    }
    public static void CreateVolunteerOpportunityRecord(List<Volunteer_Opportunity__c> rejectedVolunteerOpportunitiesList, Set<Id> wishIds)
    {
        RecursiveTriggerHandler.isFirstTime = false;
        List<Volunteer_Opportunity__c> updateList = new List<Volunteer_Opportunity__c>();
        List<Volunteer_Opportunity__c> newVolOppList = new List<Volunteer_Opportunity__c>();
        List<Volunteer_Count__c > updateVolunteerCountList = new List<Volunteer_Count__c>();
        boolean isRegistered = false;
        Map<Id,Case> openCases;
        if(wishIds.size() > 0)
            openCases = new Map<Id,Case>([SELECT id FROM Case WHERE Id IN :wishIds AND isClosed=false]);
        
        for(Volunteer_Opportunity__c newVolOpp : rejectedVolunteerOpportunitiesList) 
        {
            Volunteer_Opportunity__c newOpp = new Volunteer_Opportunity__c();
            if(openCases.containsKey(newVolOpp.wish__c) || newVolOpp.Non_Wish_Event__c != Null)
            {  
                newOpp.Wish__c = newVolOpp.Wish__c;
                newOpp.Chapter_Role_Opportunity__c = newVolOpp.Chapter_Role_Opportunity__c;
                newOpp.Chapter_Name__c = newVolOpp.Chapter_Name__c;
                newOpp.RecordTypeId = newVolOpp.RecordTypeId;
                if(newVolOpp.Wish__c != Null)
                    newOpp.Wish__c = newVolOpp.Wish__c;
                if(newVolOpp.Non_Wish_Event__c != Null){
                    newOpp.Non_Wish_Event__c  = newVolOpp.Non_Wish_Event__c;
                    newOpp.HiddenVolunteer_Count_Description__c  = newVolOpp.HiddenVolunteer_Count_Description__c ;
                    newOpp.Hidden_VolunteerCount_Desc__c = newVolOpp.Hidden_VolunteerCount_Desc__c; 
                }
                newVolOppList.add(newOpp);
                Volunteer_Opportunity__c updateVolOpp = new Volunteer_Opportunity__c();
                updateVolOpp.id = newVolOpp.Id;
                updateVolOpp.Inactive__c = true;
                updateVolOpp.Reason_Inactive__c = 'Not Approved';
                updateList.add(updateVolOpp);
                if(newVolOpp.Status__c == 'Rejected'){
                    // UpdateVolunteerRegisterdCount(newVolOppList,null);
                }
            }
        }
        
        if(newVolOppList.size() > 0) {
            insert newVolOppList;
        }
        if(updateList.size() > 0) {
            update updateList;
        }
        if(updateVolunteerCountList.size() > 0){
            update updateVolunteerCountList;       
        }
    }
    public static void shareolunteerOpportunityRecord(List<Volunteer_Opportunity__c> volOpporunityRec){
        Set<Id> volunteerContactIdSet = new Set<Id>();
        Map<Id,Id> volunteerUserMap = new Map<Id,Id>();
        List<Volunteer_Opportunity__Share> volOpportunitySharingList = new  List<Volunteer_Opportunity__Share>();
        for(Volunteer_Opportunity__c processVolOpportunityRec : volOpporunityRec){
            volunteerContactIdSet.add(processVolOpportunityRec.Volunteer_Name__c);
        }
        
        for(User dbActiveVolunteerUser : [SELECT Id,ContactId from User WHERE contactId IN:volunteerContactIdSet]){
            volunteerUserMap.put(dbActiveVolunteerUser.ContactId,dbActiveVolunteerUser.Id);
        }
        
        for(Volunteer_Opportunity__c processVolOpportunityRec : volOpporunityRec){
            if(volunteerUserMap.containsKey(processVolOpportunityRec.Volunteer_Name__c)){
                Volunteer_Opportunity__Share newVolOppShareRec = new Volunteer_Opportunity__Share();
                newVolOppShareRec.ParentId = processVolOpportunityRec.Id;
                newVolOppShareRec.AccessLevel ='Edit';
                newVolOppShareRec.rowcause=Schema.Volunteer_Opportunity__Share.RowCause.Grant_Edit_Access_to_assigned_Volunteer__C;
                newVolOppShareRec.UserOrGroupId = volunteerUserMap.get(processVolOpportunityRec.Volunteer_Name__c);
                volOpportunitySharingList.add(newVolOppShareRec);
            }
        }
        if(volOpportunitySharingList.size() > 0)
            insert volOpportunitySharingList;
    }
    
    public static void updateCase(Set<Id> caseIdSet,Set<Id> voluOppIdSet){
        RecursiveTriggerHandler.isFirstTime = false;
        List<Case> updateCaseList = new List<Case>();
        Case myParentCase = new Case(); 
        for (Case record : [SELECT id FROM Case WHERE Id IN : caseIdSet]){
            
            myParentCase.id = record.id;
            //myParentCase.Hidden_VOinactive__c = true;
            
        }
        for(User dbUser: [SELECT Id,Name,ContactId FROM User WHERE ContactId IN:voluOppIdSet]){
            if(voluOppIdSet.contains(dbUser.ContactId)){
                
                myParentCase.InActiveWishGranter__c = dbUser.Name;
            }
        }
        updateCaseList.add(myParentCase);
        if(updateCaseList.size() > 0)
            update updateCaseList ;
    }
}