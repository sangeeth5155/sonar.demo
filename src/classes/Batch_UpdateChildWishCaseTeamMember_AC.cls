/*This class is used to update the Case Team Member of the child cases*/
global class Batch_UpdateChildWishCaseTeamMember_AC implements Database.Batchable<sObject> {
    Constant_AC  constant = new Constant_Ac();
    Id parentWishRT = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator([SELECT Id, OwnerId FROM Case WHERE RecordTypeId =: parentWishRT]);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> parentCase) {
        Set<Id> parentCaseIdSet = new Set<Id>();
        Map<Id, List<CaseTeamMember>> caseTeamMemberMap = new Map<Id, List<CaseTeamMember>>();
        for(Case caseInfo : parentCase) {
            parentCaseIdSet.add(caseInfo.Id);
        }
        for(CaseTeamMember caseTeamInfo : [SELECT Id, MemberId, TeamRoleId, ParentId FROM CaseTeamMember WHERE ParentId IN : parentCaseIdSet]) {
            if(caseTeamMemberMap.containsKey(caseTeamInfo.ParentId)) {
                caseTeamMemberMap.get(caseTeamInfo.ParentId).add(caseTeamInfo);
            } else {
                caseTeamMemberMap.put(caseTeamInfo.ParentId, new List<CaseTeamMember>{caseTeamInfo});
            }
        }
        Set<Id> childCaseIdSet = new Set<Id>();
        List<Case> childCaseList = new List<Case>();
        for(Case childCaseInfo : [SELECT Id, ParentId, RecordTypeId FROM Case WHERE ParentId IN : parentCaseIdSet AND RecordTypeId !=: parentWishRT]) {
            childCaseIdSet.add(childCaseInfo.Id);
            childCaseList.add(childCaseInfo);
        }
        List<CaseTeamMember> deleteTeamList = new List<CaseTeamMember>();
        for(CaseTeamMember childCaseTeam : [SELECT Id, ParentId, MemberId, TeamRoleId FROM CaseTeamMember WHERE ParentId IN : childCaseIdSet]) {
            deleteTeamList.add(childCaseTeam);
        }
        if(deleteTeamList.size() > 0) {
            delete deleteTeamList; 
        }
        List<CaseTeamMember> newCaseInfoList = new List<CaseTeamMember>();
        for(Case insertChildTeam : childCaseList) {
            if(caseTeamMemberMap.containsKey(insertChildTeam.ParentId)) {
                for(CaseTeamMember caseIn : caseTeamMemberMap.get(insertChildTeam.ParentId)) {
                    CaseTeamMember newTeam = new CaseTeamMember();
                    newTeam.ParentId = insertChildTeam.Id;
                    newTeam.MemberId = caseIn.MemberId;
                    newTeam.TeamRoleId = caseIn.TeamRoleId;
                    newCaseInfoList.add(newTeam);
                }
            }
        }
        if(newCaseInfoList.size() > 0) {
            insert newCaseInfoList;
        }
    }                                     
    global void finish(Database.BatchableContext BC) {
    }
}