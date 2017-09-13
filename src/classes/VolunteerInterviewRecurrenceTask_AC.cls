global class VolunteerInterviewRecurrenceTask_AC implements Database.Batchable<sObject> {
    
    Constant_AC  constant = new Constant_Ac();    
    public Id wishDeterminationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
    public Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
    public Id wishGrantRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date checkin  = System.today().addDays(-30);
        String query = 'SELECT Id, CheckedInFamily__c FROM Case WHERE RecordTypeId =: parentWishRecordTypeId AND CheckedInFamily__c != null AND CheckedInFamily__c =: checkin';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> caseList) {
        Map<Id, Id> caseTeamMemberMap = new Map<Id, Id>();
        Set<Id> idForCaseTeamMemberSet = new Set<Id>();
        Map<Id,Case> recurrenceTaskMap = new Map<Id,Case>();
        List<Task> recurrenceCheckinTaskList = new List<Task>();
        List<Case> updateCaseCheckInDateList = new List<Case>();
        for(Case getCaseDetails : caseList) {
            recurrenceTaskMap.put(getCaseDetails.Id, getCaseDetails);
        }
        
        Map<Id, Case> checkWishGrantWish = new Map<Id, Case>([SELECT ParentId FROM Case WHERE RecordTypeId =: wishGrantRecordTypeId AND ParentId IN : recurrenceTaskMap.keySet()]);
        for(Case caseDet : caseList) {
            if(!checkWishGrantWish.containsKey(caseDet.Id)) {
                idForCaseTeamMemberSet.add(caseDet.Id);
                updateCaseCheckInDateList.add(caseDet);
            }
        }
        //Used to get case and its case team members
        for(CaseTeamMember caseTeamMem : [SELECT Id, ParentId, MemberId, TeamRoleId  FROM CaseTeamMember WHERE ParentId IN : idForCaseTeamMemberSet ORDER BY CreatedDate DESC]) {
            if(!caseTeamMemberMap.containsKey(caseTeamMem.ParentId)) {
                caseTeamMemberMap.put(caseTeamMem.ParentId,caseTeamMem.MemberId);
            } 
        }
        for(Id chekinRec : idForCaseTeamMemberSet) {
            Task newSubTask = new Task();
            newSubTask.Subject = 'Check in with the family every 30 days';
            newSubTask.ActivityDate = System.Today() + 30;
            newSubTask.WhatId = chekinRec;
            if(recurrenceTaskMap.containsKey(chekinRec)) {
                newSubTask.WhoId = recurrenceTaskMap.get(chekinRec).ContactId;
            }
            if(caseTeamMemberMap.containsKey(chekinRec)) {
                newSubTask.OwnerId = caseTeamMemberMap.get(chekinRec);
            }
            recurrenceCheckinTaskList.add(newSubTask);
        }
        if(recurrenceCheckinTaskList.size() > 0) {
            insert recurrenceCheckinTaskList;
        }
        
        for(Case updateCheckInDate : updateCaseCheckInDateList){
           updateCheckInDate.CheckedInFamily__c = System.today();
        }
        if(updateCaseCheckInDateList.size() > 0) {
            update updateCaseCheckInDateList;
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}