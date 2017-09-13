/****************************************************************************
Description : When User clicks [Create New Wish] button on Parent Wish, It will create new wish for the child and assign two 
Wish granters from the current wish and also it will create a task for Volunteer Manager for  reviewing previous case.
*****************************************************************************/

global class CreateNewWish_AC 
{
    webservice static String CreateCase(Id caseId)
    {
     
        Case currCase = [SELECT id,Subject,Description,Priority,AccountId,RecordTypeId,ChapterName__r.Volunteer_Manager__c,ContactId,ContactMobile,
                         ContactPhone,Type,Birthdate__c,ChapterName__c
                        FROM Case WHERE Id = :caseId];
                        
        Map<Id,Case> newCaseMap = new Map<Id,Case>();        
        Case newCase = new Case();
        newCase = currCase.clone();
        newCase.Status = 'Ready to Assign';
        newCase.Sub_Status__c = 'Non-Viewable';
        newCase.RecordTypeId = currCase.RecordTypeId;
        if(currCase.ChapterName__c!= Null && currCase.ChapterName__r.Volunteer_Manager__c != Null)
           newCase.OwnerId = currCase.ChapterName__r.Volunteer_Manager__c;
        insert newCase;
        
        Task newTask = new Task();
        newTask.WhatId = newCase.id;
        if(currCase.ChapterName__r.Volunteer_Manager__c != Null)
           newTask.ownerId = currCase.ChapterName__r.Volunteer_Manager__c;
        newTask.Subject = 'Review previous wish, confirm and reassign volunteers';
        newTask.ActivityDate = Date.Today().addDays(1);
        newTask.Priority = 'High';
        insert newTask;
        
        if(newCase.id != Null)
        {
          newCaseMap.put(newCase.id,newCase);
          
          Set<Id> accountIds = new Set<Id>();
          accountIds.add(currCase.ChapterName__c);
          CaseTriggerHandler.createVolunteerOpportunity(newCaseMap,accountIds);
        }
        
        
        
     /*   List<CaseTeamMember> newCaseTeamList = new List<CaseTeamMember>();
        for(CaseTeamMember currTeam :  [SELECT Id, MemberId, TeamRoleId, ParentId FROM CaseTeamMember WHERE TeamRole.name = 'Wish Granter' limit 2])
        {
            CaseTeamMember currCaseTeam = currTeam.clone();
            currCaseTeam.ParentId = newCase.id;
            newCaseTeamList.add(currCaseTeam);
            
        }    
        
        if(newCaseTeamList.size() > 0)
        {
            insert newCaseTeamList; 
        } */
        
        
      
        
        if(newCase.id != null)
            return newCase.id;
        else
            return null;
    
    }


}