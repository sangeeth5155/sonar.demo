/*********************************************************
Test class for batch_CaseTeamMemberUpdate
********************************************************/

@isTest
Public class batch_CaseTeamMemberUpdateTest
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
        CaseTeamRole wishGranter= [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' limit 1];  
        User currUser = [Select id from User WHERE isActive=True limit 1]; 
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,currUser.id,wishGranter.id);
     
        Case updateParentCase = new Case();
        updateParentCase.Id = parentCase.Id;
        updateParentCase.Sub_Status__c = 'Abandoned';
        updateParentCase.Status = 'Closed';
        
        update updateParentCase;
        
        Test.startTest();
          DataBase.executeBatch(new batch_CaseTeamMemberUpdate() );
       Test.stopTest();
  
  }


}