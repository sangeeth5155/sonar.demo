@isTest
Public class UpdateWishAssignmentBatchTest_AC
{

    static testmethod void CreateVolunteerOpportunity()
    {
        String CRON_EXP = '0 0 1 * * ? *';
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        chapterAccount.Alert_for_Unassigned_Wishes__c  = 0;
        update chapterAccount;
        
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Case parentCase = OrientationandTrainingUtil.ParentCasetoAddCaseMember(wishChild.Id);
        parentCase.ChapterName__c = chapterAccount.id;
        update parentCase;
        Role__c  roleName = OrientationandTrainingUtil.createRole();
      
        Role__c newRole = new Role__c();
        newRole.Name = 'Wish Granter';
        newRole.isWishRole__c = true;
        insert newRole;
       
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,newRole.id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        nonWishEvent.Event_Date__c = Date.Today().addDays(-5);
        update nonWishEvent;
        Constant_AC constant = new Constant_AC();
        Id wishVolunteerOpportunityRecordTypeId = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        Volunteer_Opportunity__c newOpp = new Volunteer_Opportunity__c();
        newOpp.Volunteer_Name__c = volunteerContact.id;
        newOpp.Non_Wish_Event__c = nonWishEvent.id;
        newOpp.Chapter_Role_Opportunity__c = chapterRole.id;
        newOpp.wish__c = parentCase.id;
        newOpp.recordTypeId = wishVolunteerOpportunityRecordTypeId;
        insert newOpp;
        
         Test.startTest();
          
            String jobId = System.schedule('lastWishAssignment',CRON_EXP, new UpdateWishAssignmentBatchSchedule_AC());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
        
        
    
    
    }


}