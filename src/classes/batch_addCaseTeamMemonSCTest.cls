/*********************************************************
Test class for batch_CaseTeamMemberUpdate
********************************************************/

@isTest
Public class batch_addCaseTeamMemonSCTest
{

  static testmethod void CreateRecords()
  {
  
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.ContactId = wishChild.Id;
        parentCase.AccountId = chapterAccount.Id;
        parentCase.Start_Date__c = System.today();
        parentCase.Status = 'Qualified';
        parentCase.Migrated_Record__c = True;
        insert parentCase;
        
        Constant_AC  constant = new Constant_Ac();    
        Id planningWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();
       
        Case newPlanningtWish = new Case();
        newPlanningtWish.RecordTypeId = planningWishRecordTypeId;
        newPlanningtWish.ChapterName__c = chapterAccount.id;
        newPlanningtWish.Subject = 'Wish Planning & Anticipation';
        newPlanningtWish.ParentId = parentCase.id;
        newPlanningtWish.ContactId = wishChild.id;
        newPlanningtWish.migrated_record__c = true;
        insert newPlanningtWish;
        
        System.assertEquals(parentCase.id,newPlanningtWish.parentId);
        CaseTeamRole wishGranter= [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' limit 1];  
        User currUser = [Select id from User WHERE isActive=True limit 1]; 
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,currUser.id,wishGranter.id);
     
       
        
        Test.startTest();
          DataBase.executeBatch(new batch_addCaseTeamMemonSC() );
       Test.stopTest();
  
  }


}