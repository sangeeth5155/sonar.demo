@isTest
public class batch_changeVolunOppSatus_Test{
    static testmethod void testchangeVolunOppStatusCompleted() {
        Id chapterId=OrientationandTrainingUtil.createVolunteerAccount().Id;
        Id roleId=OrientationandTrainingUtil.createRole().Id;
        Id eventId=OrientationandTrainingUtil.CreateEventinPastDate(chapterId).Id;
          Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventinPastDate(chapterAccount.Id);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        Volunteer_Opportunity__c volOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);     
        Volunteer_Opportunity__c nonWishvolOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);     
        //Volunteer_Opportunity__c nonWishEvent=OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterId,roleId,eventId);
        String CRON_EXP = '0 0 1 * * ? *';
        Test.StartTest();
        String jobId = System.schedule('batch_changeVolunOppSatus_Test',CRON_EXP, new batch_changeVolunOppSatusSchedule_AC());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        Test.StopTest();
    }
}