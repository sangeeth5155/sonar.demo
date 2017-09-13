global class wishFollowUpTaskAlert_AC implements Database.Batchable<sObject> {
    
    Constant_AC  constant = new Constant_Ac();    
    public Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
    public Set<Id> userIdsSet = new Set<Id>();
    public Set<Id> communityUserIdSet = new Set<Id>();
    public Set<Id> parentCaseIds = new Set<Id>();
    public List<Task> newTaskList = new List<Task>();
    Map<Id, Id> wishOwnerMap = new Map<Id,Id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    System.debug('>>>>>>>>>>');
        Date reqDateCalc = System.Today().addDays(16);
        String query = 'SELECT Id, RecordTypeId, Status, OwnerId FROM Case  WHERE Status != \'completed\' AND RecordTypeId =: parentWishRecordTypeId AND End_Date__c != NULL AND End_Date__c =: reqDateCalc';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> caseList) {
        
        System.debug('Process List >>>>>caseList>>>>>>'+caseList);
        for(Case getCaseId : caseList) {
            parentCaseIds.add(getCaseId.Id);
            wishOwnerMap.put(getCaseId.Id, getCaseId.OwnerId);
        }
        
        System.debug('parentCaseIds>>>>'+parentCaseIds);
        for(CaseTeamMember caseMember : [SELECT Id, MemberId, ParentId, TeamRole.Name FROM CaseTeamMember WHERE ParentId IN : parentCaseIds AND TeamRole.Name = 'Wish Granter']) {
            userIdsSet.add(caseMember.MemberId);
        }
        
        System.debug('>>>>>communityUserIdSet>>>'+userIdsSet);
        
        for(User communityUser : [SELECT Id, ContactId FROM User WHERE ContactId != null AND Id IN :userIdsSet]) {
            communityUserIdSet.add(communityUser.Id);
        }
        
        Map<Id,Id> openTaskMap = new Map<Id,Id>();
        for(Task openTask : [SELECT Id, OwnerId, WhatId FROM Task WHERE WhatId IN : parentCaseIds AND isClosed = false AND Subject != 'Volunteer wish follow-up activities not complete']) {
            if(communityUserIdSet.contains(openTask.OwnerId)) {
                openTaskMap.put(openTask.WhatId, openTask.OwnerId);
            }
        }
        
        System.debug('>>>>>openTaskMap>>>'+openTaskMap);
        
        for(Id parentId : parentCaseIds) {
            if(openTaskMap.containsKey(parentId)) {
                System.debug('Create Task>>>>>>>>>>>>');
                Task followUpTaskAlert = new Task();
                followUpTaskAlert.Subject = 'Volunteer wish follow-up activities not complete';
                followUpTaskAlert.OwnerId = openTaskMap.get(parentId);
                followUpTaskAlert.ActivityDate = System.today() + 1;
                followUpTaskAlert.WhatId = parentId;
                followUpTaskAlert.OwnerId = wishOwnerMap.get(parentId);
                newTaskList.add(followUpTaskAlert);
            }
        }
        
        if(newTaskList.size() > 0) {
            insert newTaskList;
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}