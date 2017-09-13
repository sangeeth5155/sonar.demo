/*****************************************************************************************************************
Author      : MST Solutions
Date        : 11/28/2016
Description : Used to transer open activities task for "Wish Granter" & "Wish Mentor"
*******************************************************************************************************************/
public class VolunteerTaskTransfer_AC {
    
    public Id assignerId {get;set;}
    public Task currentTask;
    public string communityBaseUrl {get;set;}
    
    public VolunteerTaskTransfer_AC(ApexPages.StandardController controller) {
        this.currentTask = (Task)controller.getRecord();
        communityBaseUrl = '';
    }
    //Used to get the assigner list from parent case
    public List<SelectOption> getAssigners() {
        System.debug(currentTask.Id);
        List<Task> taskInfoList = [SELECT Id, OwnerId, WhatId FROM Task WHERE Id =: currentTask.Id];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Please Select',true));
        if(taskInfoList.size() > 0) {
            Set<Id> caseTeamMemberIdSet = new Set<Id>();
            Map<Id,String> userInfoMap = new Map<Id, String>();
            for(CaseTeamMember caseTeamMem : [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE (TeamRole.Name = 'Wish Granter Mentor'OR TeamRole.Name = 'Wish Granter') AND ParentId =: taskInfoList[0].WhatId]) {
                if(caseTeamMem.MemberId != taskInfoList[0].OwnerId) {
                    caseTeamMemberIdSet.add(caseTeamMem.MemberId);
                }
            }
            if(caseTeamMemberIdSet.size() > 0) {
                for(User userInfo : [SELECT Id, Name FROM User WHERE Id IN : caseTeamMemberIdSet]) {
                    userInfoMap.put(userInfo.Id, userInfo.Name);
                }
                
                for(Id userId : caseTeamMemberIdSet) {
                    if(userInfoMap.containsKey(userId) ) {
                        options.add(new SelectOption(userId,userInfoMap.get(userId)));
                    }
                }
            }
        }
        return options;
    }
    
    //Used to transfer task
    public void transferTask() {
        Task updateOwner = new Task();
        updateOwner.Id = currentTask.Id;
        updateOwner.OwnerId = assignerId;
        update updateOwner;
        communityBaseUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/VolunteerActivities_VF';
    }
    
}