/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Chandrasekar
Date        : 11/14/2016
Description : batch_FillWishInterviewDate_Test class used make sure the unit test of the batch_FillWishInterviewDate class.
*****************************************************************************************************/
@isTest
public class batch_FillWishInterviewDate_Test {
    
    static testmethod void testUpdateLeadStatusScheduleClass() {
         String CRON_EXP = '0 0 1 * * ? *';
         Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithoutInterviewDate(wishChild.id);
        list<Case> wishDetermination = new list<Case>();
        wishDetermination.add( OrientationandTrainingUtil.createWishDeterminationCase(wishChild.id,parentCase.Id));
        Test.startTest();
        // Schedule the test job        
        String jobId = System.schedule('batch_FillWishInterviewDate_Test',CRON_EXP, new batch_FillWishInterviewDateSchedule_AC());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    
         
}