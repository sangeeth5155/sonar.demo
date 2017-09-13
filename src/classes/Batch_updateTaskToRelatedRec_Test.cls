/* This class is used to increase the code coverage of Batch_updateTaskToRelatedRec class*/
@isTest
public class Batch_updateTaskToRelatedRec_Test{
    
    /* This method is used to create Lead and Task and update the task with the associate lead record */
    
    public testmethod static void CreateLead(){
       // Lead newLead = OrientationandTrainingUtil.createTestLeadRec(OrientationandTrainingUtil.createchapterAccount().Id);
        Lead newLead = new Lead();
        newLead.FirstName = 'moss';
        newLead.LastName = 'Smith Household';
        newLead.Phone = '9600467559';
        newLead.Email = 'testmawa@gmail.com';
        newLead.Street = 'KuttaiKarai Street';
        newLead.StateCode = 'AZ';
        newLead.city = 'Trichy';
        newLead.Postalcode = '6201717';
        newLead.CountryCode = 'US';
        newLead.DOB__c = System.today() - 1435;
        newLead.company = 'MAWA';
        newLead.Status = 'Inquiry';
       // newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        newLead.Gender__c = 'Male';
        newLead.ChapterName__c = OrientationandTrainingUtil.createchapterAccount().Id;
        newLead.Referrer_FirstName__c = 'Sudhar';
        newLead.Referrer_Last_Name__c = 'test';
        newLead.Referrer_Email__c = 'sudhar1@gmail.com';
        newLead.Referrer_Phone__c = '0600467559';
        newLead.Referrer_City__c = 'Trichy';
        newLead.Referrer_Zip__c = '6210';
        newLead.Sibling_Detail__c = 'aa | aaab | 14 bbb | bbbc | 15';
        newLead.PD_Condition_Description__c = 'Test Diagnosis';
        newLead.Parent_First_Name__c = 'MAWAFirstJune';
        newLead.Parent_Last_Name__c = 'MAWALastJune';
        newLead.Medical_Professional_First_Name__c = 'mossJune';
        newLead.Medical_Professional_Last_Name__c = 'hartJune';
        newLead.Medical_Professional_Phone__c = '9600467559';
        newLead.Medical_Professional_Email__c = 'testmawa1s@gmail.com';
        newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC';
        newLead.Treating_Medical_Professional_First_Name__c = 'SteveJune';
        newLead.Treating_Medical_Professional_Last_Name__c = 'Waughone';
        newLead.Treating_Medical_Professional_Phone__c = '9600467578';
        newLead.Treating_Medical_Professional_Email__c = 'testmawa2d@gmail.com';
        newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC';
        newLead.is_Family_Aware_of_Referral__c = 'Yes';
        newLead.Medical_Questions__c = 'Test Diagnosis';
        //newLead.PD_ICD_Code__c  = 'C12.0';
        newLead.Lung_Disease__c = 'Test1;Test2';
        newLead.Angina__c = 'Test1;Test2';
        newLead.Ventilator__c = 'Test1;Test2';
        newLead.Arrhythmia__c = 'Test1;Test2';
        newLead.Heart_Failure__c = 'Test1;Test2';
        newLead.Congenital_Heart_Disease__c = 'Test1;Test2';
        newLead.Chronic_Hepatitis__c = 'Test1;Test2';
        newLead.Convulsive_Disorders__c = 'Test1;Test2';
        newLead.Pulmonary_Hypertension__c = 'Test1;Test2';
        newLead.Strokes__c = 'Test1;Test2';
        newLead.Chronic_Heart_Failure__c = 'Test1;Test2';
        newLead.isSign__c = true;
        //newLead.Communication__c = 'Non-Verbal';
        newLead.Travel_algorithm__c = 'Test1;Test2;';
        Insert newLead;
        Task newTask = new Task(subject ='Lead ET : Online Wish Referral Received');
        Insert newTask;
        system.assertEquals('Smith Household',[SELECT lastName FROM Lead WHERE id =: newLead.Id].LastName);
        
        Test.StartTest();
        Database.executeBatch(new Batch_updateTaskToRelatedRec_AC());
        Test.StopTest();
        
        system.assertEquals(newLead.Id,[SELECT WhoId FROM Task WHERE id =: newTask.Id].WhoId);
    }
 }