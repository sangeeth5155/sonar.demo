/*************************************************************************
Created by : Vennila Paramasivam
Author : MST Solutions
CreatedDate : 07/25/2016
Description : Unit Test for UpdatAffiliationAsInactiveBatch_AC.
**************************************************************************/
@isTest
public class UpdatAffiliationAsInactiveBatch_Test
{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void UpdateInactiveStatus()
    {
       TestClassUtil.createVolunteerContact();
       TestClassUtil.createVolunteerAccount();
       npe5__Affiliation__c affiliation = TestClassUtil.createorgAffiliation();
       affiliation.npe5__Status__c = 'Active';
       update affiliation;
       
       Background_check__c  createExpiredBC = new Background_check__c();
       createExpiredBC.Volunteer__c = affiliation.npe5__Contact__c;
       createExpiredBC.Status__c= 'Approved';
       createExpiredBC.Date__c = Date.Today().addDays(-5);
       createExpiredBc.Date_Completed__c = Date.Today();
       insert createExpiredBC;
       
       Conflict_Of_Interest__c newCOI = new Conflict_Of_Interest__c();
       newCOI.Volunteer_Contact__c = affiliation.npe5__Contact__c;
       newCOI.Expiration_Date__c = Date.Today().addDays(-5);
       insert newCOI;
       
       // Schedule the test job
          String jobId = System.schedule('UpdatAffiliationAsInactiveSchedule_AC',
                            CRON_EXP, 
                            new UpdatAffiliationAsInactiveSchedule_AC());
             
          // Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
    
          // Verify the expressions are the same
          System.assertEquals(CRON_EXP, 
             ct.CronExpression);
    
          // Verify the job has not run
          System.assertEquals(0, ct.TimesTriggered);
    
          // Verify the next time the job will run
          System.assertEquals('2022-03-15 00:00:00', 
             String.valueOf(ct.NextFireTime));
             
             
          Test.startTest();
            UpdatAffiliationAsInactiveBatch_AC batchAffiliation = new UpdatAffiliationAsInactiveBatch_AC();
            Database.executeBatch(batchAffiliation, 200);
          Test.stopTest();
       
    }
    
  
   static testmethod void UpdateActiveStatus()
    {
       TestClassUtil.createVolunteerContact();
       TestClassUtil.createVolunteerAccount();
       npe5__Affiliation__c affiliation = TestClassUtil.createorgAffiliation();
       affiliation.npe5__Status__c = 'inActive';
       update affiliation;
       
       Background_check__c  createExpiredBC = new Background_check__c();
       createExpiredBC.Volunteer__c = affiliation.npe5__Contact__c;
       createExpiredBC.Status__c= 'Approved';
       createExpiredBC.Date__c = Date.Today().addDays(5);
       createExpiredBc.Date_Completed__c = Date.Today();
       insert createExpiredBC;
       
       Conflict_Of_Interest__c newCOI = new Conflict_Of_Interest__c();
       newCOI.Volunteer_Contact__c = affiliation.npe5__Contact__c;
       newCOI.Expiration_Date__c = Date.Today().addDays(5);
       insert newCOI;
       
       // Schedule the test job
          String jobId = System.schedule('UpdatAffiliationAsInactiveSchedule_AC',
                            CRON_EXP, 
                            new UpdatAffiliationAsInactiveSchedule_AC());
             
          // Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
    
          // Verify the expressions are the same
          System.assertEquals(CRON_EXP, 
             ct.CronExpression);
    
          // Verify the job has not run
          System.assertEquals(0, ct.TimesTriggered);
    
          // Verify the next time the job will run
          System.assertEquals('2022-03-15 00:00:00', 
             String.valueOf(ct.NextFireTime));
             
             
          Test.startTest();
            UpdatAffiliationAsInactiveBatch_AC batchAffiliation = new UpdatAffiliationAsInactiveBatch_AC();
            Database.executeBatch(batchAffiliation, 200);
          Test.stopTest();
       
    }

}