global class batch_addCaseTeamMemonSC implements Database.Batchable<sObject> 
{

    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
         return Database.getQueryLocator([SELECT id FROM Case
                                               WHERE Migrated_Record__c = True AND RecordType.Name = 'Wish']);
    }
   
    global void execute(Database.BatchableContext BC, List<Case> scope) 
    {
        Set<Id> caseIds = new Set<Id>();
        Set<String> caseMemIds = new Set<String>();
        for(Case currCase : scope)
        {
          caseIds.add(currCase.id);
        }  
        
        Map<id,List<CaseTeamMember>> caseTeamMemMap = new Map<id,List<CaseTeamMember>>();
        for(CaseTeamMember currMemb :  [SELECT Id, ParentId, MemberId, TeamRoleId FROM CaseTeamMember WHERE ParentId IN :caseIds])
        {
             if(caseTeamMemMap.containsKey(currMemb.ParentId))
                caseTeamMemMap.get(currMemb.ParentId).add(currMemb);
             else
                caseTeamMemMap.put(currMemb.ParentId,new List<CaseTeamMember>{currMemb});
        }
        
         Set<Id> subCaseIds = new Set<Id>();
        
         for(Case currSubCase : [SELECT id,ParentId FROM Case WHERE ParentId IN :caseIds AND RecordType.Name != 'Wish' AND Migrated_Record__c = True])
         {
         
            subCaseIds.add(currSubCase.id);
         }
         
          for(CaseTeamMember currMemb :  [SELECT Id, ParentId, MemberId, TeamRoleId FROM CaseTeamMember WHERE ParentId IN :subCaseIds])
          {
          
             caseMemIds.add(currMemb.ParentId+'-'+currMemb.MemberId);
          }
         
         
        List<CaseTeamMember> caseTeamMemberList = new List<CaseTeamMember>();
        
        for(Case currSubCase : [SELECT id,ParentId FROM Case WHERE ParentId IN :caseIds AND RecordType.Name != 'Wish' AND Migrated_Record__c = True])
        {
              if(caseTeamMemMap.containsKey(currSubCase.parentId))
              {
                   for(CaseTeamMember  getTeam : caseTeamMemMap.get(currSubCase.parentId) )
                   {
                       if(!caseMemIds.Contains(currSubCase.id+'-'+getTeam.MemberId))
                       {
                           CaseTeamMember currTeam = new CaseTeamMember();
                           currTeam.parentId = currSubCase.id;
                           currTeam.MemberId =  getTeam.MemberId;
                           currTeam.teamRoleId = getTeam.TeamRoleId;
                           caseTeamMemberList.add(currTeam); 
                       }                      
                   }
              }
        }
        
        if(caseTeamMemberList.size() > 0 && !Test.isRunningTest())
         insert caseTeamMemberList;
        
     
    }   
    
    global void finish(Database.BatchableContext BC) 
    {
    }

}