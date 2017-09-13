/***************************************************************************************************
Author      : MST Solutions
Description : batch_FillWishPresentationDate_Test class used make sure the unit test of the batch_FillWishPresentationDate class.
*****************************************************************************************************/
@isTest
public class batch_FillWishPresentationDate_Test {
    
    static testmethod void testPresentationDateScheduleClassSendEmail() {
    
         Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
         Constant_AC  constant = new Constant_Ac(); 
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case ParentWish = new Case();
        //date wishPresentationDate = newParentWish.Parent.Anticipated_Start_Date__c.addDays(15);
        ParentWish.RecordTypeId = parentWishRecordTypeId;
        ParentWish.ChapterName__c = OrientationandTrainingUtil.CreateAlabamaAccount();
        ParentWish.Subject = 'Parent Wish';
        ParentWish.Interview_Date_Not_Set__c = true;
        ParentWish.Interview_date__c = System.today();
        ParentWish.Start_Date__c = Date.today();
        ParentWish.Wish_Type__c = 'Disney World';
        ParentWish.ContactId = wishChild.Id;
        ParentWish.Hidden_Wish_Presentation_Not_Set__c = true;
        ParentWish.Presentation_Date__c = null;
        insert ParentWish;
        
        Case newParentWish = new Case();
        //date wishPresentationDate = newParentWish.Parent.Anticipated_Start_Date__c.addDays(15);
        ParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = OrientationandTrainingUtil.CreateAlabamaAccount();
        newParentWish.Subject = 'Parent Wish';
        newParentWish.Interview_Date_Not_Set__c = true;
        newParentWish.Interview_date__c = System.today();
        newParentWish.Start_Date__c = Date.today();
        newParentWish.Wish_Type__c = 'Disney World';
        newParentWish.ContactId = wishChild.Id;
        newParentWish.Hidden_Wish_Presentation_Not_Set__c = true;
        newParentWish.Presentation_Date__c = null;
        insert newParentWish;
        
        Id grantWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
        Case newGrantWish = new Case();
        newGrantWish.RecordTypeId = grantWishRecordTypeId;
        newGrantWish.ChapterName__c = OrientationandTrainingUtil.CreateAlabamaAccount();
        newGrantWish.Subject = 'Wish Grant';
        newGrantWish.ContactId = wishChild.Id;
        newGrantWish.Start_Date__c = Date.today();
        newGrantWish.Parentid = newParentWish.id;
        insert newGrantWish;
        
        Task task = OrientationandTrainingUtil.wishPresentationNotSet(newParentWish.Id);
//        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithAnticipatedStartDate(wishChild.id);
        list<Case> wishGranting = new list<Case>();
        String CRON_EXP = '0 0 1 * * ? *';
      //  wishGranting.add( OrientationandTrainingUtil.createWishGrantCase(wishChild.id,parentCase.Id));
        Test.startTest();
        // Schedule the test job        
        String jobId = System.schedule('batch_FillWishPresentationDate_Test',CRON_EXP, new batch_FillPresentationDateSchedule_AC());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    
         
}