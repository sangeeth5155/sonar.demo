@isTest
public class DiagnosisVerficationRemainder_ACTest
{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @TestSetup static void createLead() { 
        Lead currLead = new Lead();
        currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        currLead.Relationship_To_Child__c = 'Self';
        currLead.Referrer_FirstName__c = 'Testingzxzxz';
        currLead.Referrer_Last_Name__c = 'Testing';
        currLead.Referrer_Phone__c= '8220708920';
        currLead.Referrer_Email__c= 'mcavennila@gmail.com';
        currLead.Referrer_City__c= 'karur';
        currLead.unique_wish_identifier__c='059-17-12367';
        currLead.Referrer_Zip__c= '35004';
        currLead.is_Family_Aware_of_Referral__c= 'yes';
        currLead.FirstName= 'Testing1';
        currLead.Child_Middle_Initial__c= 'Testing2';
        currLead.lastName= 'Testing2';
        currLead.Gender__c= 'Male';
        currLead.Child_Age__c= '16';
        currLead.DOB__c=Date.valueOf('2000-09-11');
        currLead.Parent_First_Name__c = 'Testing3';
        currLead.Parent_Last_Name__c = 'Testing3';
        currLead.Street = 'Karur';
        currLead.City= 'Karur';
        currLead.state= 'Arizona';
        currLead.PostalCode= '35004';
        currLead.Email= 'mcavennila@gmail.com';
        currLead.Phone= '8220708920';
        currLead.What_is_the_family_s_primary_spoken_lang__c= 'English';
        currLead.Hospital_Treatment_Facility_Treating__c= 'Malignant Neoplasm';
        currLead.Treating_Medical_Professional_First_Name__c = 'Treaing 1';
        currLead.Treating_Medical_Professional_Last_Name__c= 'Treaing 1';
        currLead.Treating_Medical_Professional_Phone__c = '8220708921';
        currLead.Treating_Medical_Professional_Email__c= 'mcavennila@gmail.com';
        currLead.Any_medical_reason_for_moving_quickly__c= 'yes';
        currLead.PD_Condition_Description__c  = 'c00';
        Condition_Description__c descrip = OrientationandTrainingUtil.createConditionDesCription(); 
        insert descrip;
        ICD_Codes__c icdCode = OrientationandTrainingUtil.createICDCode(descrip.Id);
        insert icdCode;
        currLead.PD_ICD_Code__c = icdCode.Id;
        currLead.RFI_Form_Info_Hidden__c = 'Referred';
        currLead.Company = 'MST';
        currLead.Status = 'Referred';
        currLead.Referred_Date__c = Date.today().addDays(-3);
        insert currLead;
    }
    static testmethod  void createLeadRecords()
    {   
        Lead currLead = [SELECT id from Lead];
        
        // Schedule the test job
        String jobId = System.schedule('testJob',
                                       CRON_EXP, 
                                       new DiagnosisVerficationReminderSchedule_AC());
        
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
        DiagnosisVerficationRemainder_AC batchAffiliation = new DiagnosisVerficationRemainder_AC();
        Database.executeBatch(batchAffiliation, 200);
        Test.stopTest();
        
        
    }
    
    static testmethod  void PartARemainderat7days()
    {
        
       
        Lead currLead = [SELECT id FROM Lead];
        Lead updateLead = new Lead();
        updateLead.id = currLead.id;
        updateLead.Part_A_Sent__c = Date.Today().addDays(-7);
        updateLead.Sub_Status__c = 'Pending Diagnosis Verification';
        updateLead.Referred_Date__c = Date.today();
        updateLead.Dup_Check__c = 'Block Lead Dup';
        update updateLead;
        
        // Schedule the test job
        String jobId = System.schedule('testJob1',
                                       CRON_EXP, 
                                       new DiagnosisVerficationReminderSchedule_AC());
        
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
        DiagnosisVerficationRemainder_AC batchAffiliation = new DiagnosisVerficationRemainder_AC();
        Database.executeBatch(batchAffiliation, 200);
        Test.stopTest();
        
    }
    
    static testmethod  void PartARemainderat14days()
    {
        
       
        Lead currLead = [SELECT id FROM Lead];
        Lead updateLead = new Lead();
        updateLead.id = currLead.id;
        updateLead.Part_A_Sent__c = Date.Today().addDays(-14);
        updateLead.Sub_Status__c = 'Pending Diagnosis Verification';
        updateLead.Referred_Date__c = Date.today();
        updateLead.Dup_Check__c = 'Block Lead Dup';
        update updateLead;
        
        // Schedule the test job
        String jobId = System.schedule('testJob1',
                                       CRON_EXP, 
                                       new DiagnosisVerficationReminderSchedule_AC());
        
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
        DiagnosisVerficationRemainder_AC batchAffiliation = new DiagnosisVerficationRemainder_AC();
        Database.executeBatch(batchAffiliation, 200);
        Test.stopTest();
        
    }
    static testmethod  void PartARemainderat21days()
    {
        
       
        Lead currLead = [SELECT id FROM Lead];
        Lead updateLead = new Lead();
        updateLead.id = currLead.id;
        updateLead.Part_A_Sent__c = Date.Today().addDays(-21);
        updateLead.Sub_Status__c = 'Pending Diagnosis Verification';
        updateLead.Referred_Date__c = Date.today();
        updateLead.Dup_Check__c = 'Block Lead Dup';
        update updateLead;
        
        // Schedule the test job
        String jobId = System.schedule('testJob1',
                                       CRON_EXP, 
                                       new DiagnosisVerficationReminderSchedule_AC());
        
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
        DiagnosisVerficationRemainder_AC batchAffiliation = new DiagnosisVerficationRemainder_AC();
        Database.executeBatch(batchAffiliation, 200);
        Test.stopTest();
        
    }
    
}