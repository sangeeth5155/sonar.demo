/***************************************************************
Description : It will update Case Team Member role of closed wish. (its one time process for migrated record).
****************************************************************/


global class batch_CaseTeamMemberUpdate implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
         return Database.getQueryLocator([SELECT id,Status FROM Case
                                               WHERE Migrated_Record__c = True AND isClosed=True]);
    }
   
    global void execute(Database.BatchableContext BC, List<Case> scope) 
    {
        Set<Id> caseIds = new Set<Id>();
        for(Case currCase : scope)
        {
          caseIds.add(currCase.id);
        }  
        
        List<CaseTeamRole> teamRoleId = [SELECT Id, Name FROM CaseTeamRole WHERE Name = 'Wish Granter (Wish Closed)'];
        List<CaseTeamMember> updateCaseTeamMemberList = new List<CaseTeamMember>();
        
        for(CaseTeamMember currMemb :  [SELECT Id, ParentId, MemberId, TeamRoleId FROM CaseTeamMember WHERE ParentId IN :caseIds AND TeamRole.Name = 'Wish Granter'])
        {
              CaseTeamMember updateMember = new CaseTeamMember();
              updateMember.id = currMemb.id;
              updateMember.TeamRoleId = teamRoleId[0].id;
              updateCaseTeamMemberList.add(updateMember);
        }
        
        if(updateCaseTeamMemberList.size() > 0)
            update updateCaseTeamMemberList;
       
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}