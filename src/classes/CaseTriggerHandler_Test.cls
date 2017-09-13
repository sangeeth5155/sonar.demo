/************************************************************************************
Author : Mst Solutions
Description : This class is used to increase the code coverage for CaseTrigger_AT and CaseTriggerHandler
*************************************************************************************/
@isTest
public class CaseTriggerHandler_Test {
 
     Static testmethod void UpdateStatusasCompleted()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Absent_Parent_Form__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
        //System.assertEquals('Please enter the received date for the following forms - Absent Parent Form.',result.getErrors()[0].getMessage());



     }
     Static testmethod void UpdateStatusasCompleted1()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Child_s_Medical_Summary_Form__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
       // System.assertEquals('Please enter the received date for the following forms - Child’s Medical Summary Form.',result.getErrors()[0].getMessage());
     }
     
     Static testmethod void UpdateStatusasCompleted2()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Communication_Profile__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
       // System.assertEquals('Please enter the received date for the following forms - Communication Profile.',result.getErrors()[0].getMessage());
     }
     Static testmethod void UpdateStatusasCompleted3()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Entertainment_Sports_Wish_LOU__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
       // System.assertEquals('Please enter the received date for the following forms - Entertainment & Sports .',result.getErrors()[0].getMessage());
     }
     Static testmethod void UpdateStatusasCompleted4()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Guardianship_Document__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
        //System.assertEquals('Please enter the received date for the following forms - Guardianship Document.',result.getErrors()[0].getMessage());
     }
     Static testmethod void UpdateStatusasCompleted5()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Liability_Release_and_Authorization__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
       // System.assertEquals('Please enter the received date for the following forms - Liability Release and Authorization.',result.getErrors()[0].getMessage());
     }
    Static testmethod void UpdateStatusasCompleted6()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Passports__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
       // System.assertEquals('Please enter the received date for the following forms - Passports.',result.getErrors()[0].getMessage());
     }
     Static testmethod void UpdateStatusasCompleted7()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Single_Parent_Form__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
       // System.assertEquals('Please enter the received date for the following forms - Single Parent Form.',result.getErrors()[0].getMessage());
     }
     Static testmethod void UpdateStatusasCompleted8()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Visas__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
       // System.assertEquals('Please enter the received date for the following forms - Visas.',result.getErrors()[0].getMessage());
     }
      Static testmethod void UpdateStatusasCompleted9()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Wish_Child_Form__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
        //System.assertEquals('Please enter the received date for the following forms - Wish Child Form.',result.getErrors()[0].getMessage());
     }
     Static testmethod void UpdateStatusasCompleted10()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Wish_Family_Form__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
        //System.assertEquals('Please enter the received date for the following forms - Wish Family Form.',result.getErrors()[0].getMessage());
     }
     
     Static testmethod void UpdateStatusasCompleted11()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Wish_Information_Form__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
       // System.assertEquals('Please enter the received date for the following forms - Wish Information Form.',result.getErrors()[0].getMessage());
     }
     Static testmethod void UpdateStatusasCompleted12()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        
        Wish_Expense__c currExpense = new Wish_Expense__c();
        currExpense.Case__c = parentCase.id;
        currExpense.Budget_Approval_Status__c = 'Submitted';
        currExpense.Projected_Approval_Status__c = 'Submitted';
        currExpense.Projected_Cash__c = 0;
        currExpense.Projected_In_Kind__c = 0;
        currExpense.Actual_In_Kind__c =0;
        currExpense.FE_Posted_Cash__c =0;
        currExpense.FE_Posted_In_Kind__c =0;
        currExpense.Actual_Cash__c =0;
        
        insert currExpense;
        
        
        Constant_AC constant = new Constant_AC();
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        anticipationCase.Wish_Safety_Authorization_Part_B_Form__c = true;
        insert anticipationCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        parentCase.Status = 'Completed';
        database.saveResult result = Database.update(parentCase,false);
        //System.assertEquals('There should be value on Date - Wish Safety Authorization Part B Form when wish status is Completed.',result.getErrors()[0].getMessage());
     }
     
      Static testmethod void UpdateAnticipationDate()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Constant_AC constant = new Constant_AC();
        chapterAccount.Volunteer_Manager__c = userinfo.getUserId();
        update ChapterAccount;
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithAnticipatedStartDate(wishChild.Id);
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Id taskPlanningRecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.staffTaskRT).getRecordTypeId();
        Chapter_Action_Track__c newTrack = OrientationandTrainingUtil.createChapterActionTrack(); 
        newTrack.Chapter_Name__c = chapterAccount.Id;
        newTrack.Task_name__c= 'Test';
        insert newTrack;
        Task newTask = new Task();
        newTask.Subject = 'Test';
        newTask.ActivityDate = Date.Today();
        newTask.Priority = '4';
        newTask.RecordTypeid = taskPlanningRecordTypeId;
        newTask.WhatId = parentCase.id;
        insert newTask;
        parentCase.Anticipated_Start_Date__c = Date.Today().addDays(-10);
        update parentCase;
     }
     
      Static testmethod void UpdateAnticipationDateasNull()
     {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Constant_AC constant = new Constant_AC();
        chapterAccount.Volunteer_Manager__c = userinfo.getUserId();
        update ChapterAccount;
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithAnticipatedStartDate(wishChild.Id);
        Chapter_Action_Track__c newTrack = OrientationandTrainingUtil.createChapterActionTrack(); 
        newTrack.Task_name__c = 'Test';
         newTrack.Chapter_Name__c = chapterAccount.Id;
        insert newTrack;
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Id taskPlanningRecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.staffTaskRT).getRecordTypeId();
        Task newTask = new Task();
        newTask.Subject = 'Test';
        newTask.ActivityDate = Date.Today();
        newTask.Priority = '4';
        newTask.RecordTypeid = taskPlanningRecordTypeId;
        newTask.WhatId = parentCase.id;
        insert newTask;
        parentCase.Anticipated_Start_Date__c = Null;
        update parentCase;
     }

    Static testmethod void grantPermissionOnCase() {
        UserSetting__c settings = new UserSetting__c();
        settings.Name = 'Update Abandoned Wishes';
        settings.Abandon_the_Granted_case__c = true;
        settings.All_Closed_Cases_except_Abandoned__c = true;
        settings.Edit_Abandoned_Cases__c = true;
        settings.SetupOwnerId = userinfo.getUserid();
        insert settings;
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.ContactId = wishChild.id;
        ParentCase.Status = 'Granted';
        insert parentCase;
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        
        Volunteer_Opportunity__c volOpp = new Volunteer_Opportunity__c();
        volOpp.Wish__c = parentCase.Id;
        volOpp.Migrated_Record__c = true;
        volOpp.Volunteer_Name__c = volunterCon.Id;
        insert volOpp;
        
        Volunteer_Opportunity__c updateVolOpp = new Volunteer_Opportunity__c();
        updateVolOpp.Id = volOpp.Id;
        updateVolOpp.Status__c = 'Approved';
        update updateVolOpp;
        
        
        parentCase.Status = 'Granted';
        update parentCase;
    }
    
    Static testmethod void changeOwner() {
        UserSetting__c settings = new UserSetting__c();
        settings.Name = 'Update Abandoned Wishes';
        settings.Abandon_the_Granted_case__c = true;
        settings.All_Closed_Cases_except_Abandoned__c = true;
        settings.Edit_Abandoned_Cases__c = true;
        settings.SetupOwnerId = userinfo.getUserid();
        insert settings;
        Constant_AC  constant = new Constant_Ac();    
        Id wishDeterminationRT = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.ContactId = wishChild.Id;
        parentCase.Diagnosis_Verification_Receive_Date__c = Date.today();
        insert parentCase;
        List<CaseTeamRole> caseTeamRole = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];
        
        CaseTeamMember caseTeamMem = new CaseTeamMember();
        caseTeamMem.ParentId = parentCase.Id;
        caseTeamMem.TeamRoleId = caseTeamRole[0].Id;
        caseTeamMem.MemberId = volunterUser.Id;
        insert caseTeamMem;
        Case childCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        childCase.RecordTypeId = wishDeterminationRT;
        childCase.ParentId = parentCase.Id;
        insert childCase;
        Case newChildUpdate = new Case();
        newChildUpdate.Id = childCase.Id;
        //newChildUpdate.OwnerId = volunterUser.Id;
        newChildUpdate.Diagnosis_Verification_Receive_Date__c = Date.today();
        update newChildUpdate;
    }

    //Eligibility Review Case Creation
    Static testmethod void EligibilityReviewCase() {
        Case parentCase = OrientationandTrainingUtil.createEligibilityReviewCase();
    }
    
    //Create Sub Cases
    Static testmethod void CreateSubCases() {
        
        UserSetting__c settings = new UserSetting__c();
        settings.Name = 'Update Abandoned Wishes';
        settings.Abandon_the_Granted_case__c = true;
        settings.All_Closed_Cases_except_Abandoned__c = true;
        settings.Edit_Abandoned_Cases__c = true;
        settings.SetupOwnerId = userinfo.getUserid();
        insert settings;
        
        Constant_AC  constant = new Constant_Ac();    
        Id wishDeterminationRT = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.ContactId = wishChild.Id;
        parentCase.Diagnosis_Verification_Receive_Date__c = Date.today();
        parentCase.Status = 'Ready to Assign';
        parentCase.Sub_Status__c = 'Assign in Portal';
        parentCase.Case_Member_Count__c = 2;
        insert parentCase;
        
        Task wishGrantingNewTask = new Task(Subject = 'Wish concept approval', Status = 'New', WhoId = wishChild.Id, WhatId = parentCase.Id);
        insert wishGrantingNewTask;
        Case childCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        childCase.RecordTypeId = wishDeterminationRT;
        childCase.ParentId = parentCase.Id;
        childCase.Diagnosis_Verification_Receive_Date__c = Date.today();
        insert childCase;
        Case newCase = new Case();
        newCase.id = parentCase.Id;
        newCase.Status = 'Wish Determined';
        newCase.Sub_Status__c = 'Within Policy';
        newCase.Wish_Type__c = 'Disneyland';
        
        update newCase;
        
       
               
    }
    
    //Volunteer Opportunity Creation
    Static testmethod void VolunteerOppCreation() {
        RecursiveTriggerHandler.isFirstTime = true;
        Role__c newWishGranter = new Role__c();
        newWishGranter.Name = 'Wish Granter';
        insert newWishGranter;
        Regions__c newRegion = new Regions__c();
        newRegion.Name = 'Default';
        insert newRegion;
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Chapter_Role__c newRole = new Chapter_Role__c();
        newRole.Chapter_Name__c = chapterAccount.Id;
        newRole.Role_Name__c = newWishGranter.Id;
        insert newRole;
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        wishChild.Region_Code__c = newRegion.Id;
        wishChild.county__c = 'Karur';
        update wishChild;
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.ContactId = wishChild.Id;
        parentCase.AccountId = chapterAccount.Id;
        parentCase.Status = 'Qualified';
        insert parentCase;
        Case updateParentCase = new Case();
        updateParentCase.Id = parentCase.Id;
        updateParentCase.Status = 'Ready to Assign';
        updateParentCase.Sub_Status__c = 'Assign in Portal';
        update updateParentCase;
    }
    
    //Presentation Task
    Static testmethod void PresentationTask() {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.ContactId = wishChild.Id;
        parentCase.AccountId = chapterAccount.Id;
        parentCase.Status = 'Qualified';
        insert parentCase;
        Case updateParentCase = new Case();
        updateParentCase.Id = parentCase.Id;
        updateParentCase.End_Date__c = Date.today()+10;
        update updateParentCase;
    }
    
    //Medical Summary Task
    Static testmethod void MedicalSummaryTask() {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.ContactId = wishChild.Id;
        parentCase.AccountId = chapterAccount.Id;
        parentCase.Start_Date__c = System.today();
        parentCase.Status = 'Qualified';
        insert parentCase;
        Case updateParentCase = new Case();
        updateParentCase.Id = parentCase.Id;
        updateParentCase.Start_Date__c = null;
        updateParentCase.Wish_Type__c = 'Cruise - Celebrity/Royal';
        update updateParentCase;
    }
    
    //Abondend Case
    Static testmethod void WishAbondend()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.ContactId = wishChild.Id;
        parentCase.AccountId = chapterAccount.Id;
        parentCase.Start_Date__c = System.today();
        parentCase.Status = 'Qualified';
        insert parentCase;
        Case updateParentCase = new Case();
        updateParentCase.Id = parentCase.Id;
        updateParentCase.Sub_Status__c = 'Abandoned';
        updateParentCase.Status = 'Closed';
        update updateParentCase;
       
    }
    
    Static testmethod void WishReopenCase()
    {
        Constant_AC  constant = new Constant_Ac();   
        Chapter_Action_Track__c newChapterActtrack =  OrientationandTrainingUtil.createChapterActionTrack();
        
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        
        newChapterActtrack.RecordtypeId  = Schema.Sobjecttype.Chapter_Action_Track__c.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        newChapterActtrack.Chapter_Name__c = chapterAccount.Id;
        Insert newChapterActtrack;
        
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.ContactId = wishChild.Id;
        parentCase.AccountId = chapterAccount.Id;
        parentCase.Start_Date__c = System.today();
        parentCase.Status = 'Qualified';
        insert parentCase;
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        volunterCon.Number_of_wishes_active__c = 0;
        update volunterCon;
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
         CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
         
       Case wishDeter = OrientationandTrainingUtil.createWishDeterminationCase(wishChild.Id,parentCase.Id);
       Test.StartTest();
         Case updateParentCase = new Case();
        updateParentCase.Id = parentCase.Id;
        updateParentCase.Sub_Status__c = 'Abandoned';
        updateParentCase.Status = 'Closed';
        update updateParentCase;
         updateParentCase.Status = 'Ready to Interview';
        //Update updateParentCase;
        Test.StopTest();
       /* parentCase.Case_Member_Count__c = 1;
        Update parentCase;
        parentCase.Case_Member_Count__c = 2;
        Update parentCase;*/
        
        
    }
     
 }