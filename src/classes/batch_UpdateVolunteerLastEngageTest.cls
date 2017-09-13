@isTest
Public class batch_UpdateVolunteerLastEngageTest
{

    static testmethod void CreateVolunteerOpportunity()
    {
        String CRON_EXP = '0 0 1 * * ? *';
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Case parentCase = OrientationandTrainingUtil.ParentCasetoAddCaseMember(wishChild.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        nonWishEvent.Event_Date__c = Date.Today().addDays(-5);
        update nonWishEvent;
        
        Volunteer_Opportunity__c newOpp = new Volunteer_Opportunity__c();
        newOpp.Volunteer_Name__c = volunteerContact.id;
        newOpp.Non_Wish_Event__c = nonWishEvent.id;
        newOpp.wish__c = parentCase.id;
        insert newOpp;
        
         Test.startTest();
          
            String jobId = System.schedule('lastEngagementBatch',CRON_EXP, new batch_UpdateLastEngageSchedule_AC());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
        
        
    
    
    }


}