/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 09/12/2016
Description : LeadTrigger_AT_Test is used to increase the code coverage for LeadTrigger_AT and its controller.
*****************************************************************************************************/

@isTest
public class LeadTrigger_AT_Test{    
    
    Constant_AC  constant = new Constant_AC();
    public Id medicalProfessionalRecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
    public Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
    public Id wishFamilyRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
    public Id organizationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.OrganizationRT).getRecordTypeId();
    public Id parentwishRecTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
    
    
    
    public testmethod static void sameAdditionalParent(){
        Id chapterAccount = OrientationandTrainingUtil.CreateAlabamaAccount();
        Condition_Description__c descrip = OrientationandTrainingUtil.createConditionDesCription(); 
        insert descrip;
        Account chapAcc = OrientationandTrainingUtil.MakeAWishAmericaAcc();
        Contact medicalProfessionalCon = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        ICD_Codes__c icdCode = OrientationandTrainingUtil.createICDCode(descrip.Id);
        insert icdCode;
        Lead newLead = OrientationandTrainingUtil.createAdditionalParentLead(chapterAccount);
        insert newLead;
        RecursiveTriggerHandler.isFirstTime = true; 
        System.assertEquals( RecursiveTriggerHandler.isFirstTime,true);
        newLead.SD1_ICD_Code__c = icdCode.Id;
        newLead.SD2_ICD_Code__c = icdCode.Id;
        newLead.SD3_ICD_Code__c = icdCode.Id;
        newLead.SD4_ICD_Code__c = icdCode.Id;
        newLead.Status = 'Referred';
        newLead.ChapterName__c = chapAcc.Id;
        newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        newLead.Treating_Medical_Professional_Contact_Id__c = medicalProfessionalCon.Id;
        newLead.Medical_Professional_ContactId__c =  medicalProfessionalCon.Id;
        newLead.Hidden_Best_Contact_Person_Id__c = medicalProfessionalCon.Id;
        newLead.Relationship_to_child__c = 'Medical Professional'; 
        update newLead;
        
        newLead.Status = 'Qualified';
        Test.startTest();
        update newLead;
        Test.stopTest();
        
        System.assertEquals(newLead.Status,'Qualified');
        System.assertEquals(medicalProfessionalCon.Id,newLead.Treating_Medical_Professional_Contact_Id__c );
    }
    
    
    public testmethod static void updateLeadAsQualified(){
        Id chapterAccount = OrientationandTrainingUtil.CreateAlabamaAccount();
        Condition_Description__c descrip = OrientationandTrainingUtil.createConditionDesCription(); 
        insert descrip;
        Account chapAcc = OrientationandTrainingUtil.MakeAWishAmericaAcc();
        Contact medicalProfessionalCon = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        Contact FamilyContact = OrientationandTrainingUtil.CreateWishFamily();
        ICD_Codes__c icdCode = OrientationandTrainingUtil.createICDCode(descrip.Id);
        insert icdCode;
        Lead newLead = OrientationandTrainingUtil.createSameMedicalLead(chapterAccount);
        newLead.Sibling_Detail__c = 'aa | - | 12';
        insert newLead;
        RecursiveTriggerHandler.isFirstTime = true; 
        System.assertEquals( RecursiveTriggerHandler.isFirstTime,true);
        newLead.SD1_ICD_Code__c = icdCode.Id;
        newLead.SD2_ICD_Code__c = icdCode.Id;
        newLead.SD3_ICD_Code__c = icdCode.Id;
        newLead.SD4_ICD_Code__c = icdCode.Id;
        newLead.Status = 'Referred';
        newLead.ChapterName__c = chapAcc.Id;
        newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        newLead.Wish_Family_ContactId__c = FamilyContact.Id;
        newLead.Medical_Professional_ContactId__c =  medicalProfessionalCon.Id;
        newLead.Hidden_Additional_Parent_Id__c =  FamilyContact.Id;
        newLead.Hidden_Best_Contact_Person_Id__c = medicalProfessionalCon.Id;
        update newLead;
        
        newLead.Status = 'Qualified';
        
        Test.startTest();
        update newLead;
        Test.stopTest();
        System.assertEquals(newLead.Status,'Qualified');
        System.assertEquals(medicalProfessionalCon.Id,newLead.Medical_Professional_ContactId__c);
    }
    
    /*This method is used to increase the code coverage for dupecheckonContact method when the lead status is updated as 'Qualified'. */ 
    public testmethod static void CreateRelationShipRecord(){ 
        RecursiveTriggerHandler.isFirstTime = true;
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        // Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        //       Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();
        Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
        Contact trateProfContact = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        Contact medicalProfContact = OrientationandTrainingUtil.CreateMedicalProfContact();
        Contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
        newLead.Child_Age__c = '4';
        newLead.unique_wish_identifier__c = '123456';
        
        newLead.Relationship_to_child__c = 'Medical Professional';
        
        newLead.Sibling_Detail__c = '- | bbb | 12';
        //newLead.Sub_Status__c ='Pending Diagnosis Verification';
        
        insert newLead;
        RecursiveTriggerHandler.isFirstTime = true; 
        newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        update newLead;
        
        
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatus(newLead.Id); 
        Case partAWish = OrientationandTrainingUtil.CreatePartAWish(newLead.Id);
        newLead.Status = 'Qualified';
        Test.StartTest();
        update newLead;
        Test.StopTest();
        
        
        
        
    }
    
    /*This method is used to increase the code coverage for dupecheckonContact method when the lead status is updated as 'Qualified'. */ 
    public testmethod static void CreateRelationShipRecordwithExisitingContact(){ 
        RecursiveTriggerHandler.isFirstTime = true;
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        // Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        //       Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();
        Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
        Contact trateProfContact = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        Contact medicalProfContact = OrientationandTrainingUtil.CreateMedicalProfContact();
        Contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
        newLead.Child_Age__c = '4';
        newLead.unique_wish_identifier__c = '123456';
        newLead.Treating_Medical_Professional_Contact_Id__c = trateProfContact.Id;
        newLead.Medical_Professional_ContactId__c = medicalProfContact.Id;
        newLead.Relationship_to_child__c = 'Medical Professional';
        newLead.Wish_Family_ContactId__c = wishFamily.Id;
        newLead.Sibling_Detail__c = 'aa | bbb | -';
        //newLead.Is_We_Need_To_Expedite_The_Process__c = 'Yes';
        insert newLead;
        
        newLead.Status = 'Referred';
        newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        RecursiveTriggerHandler.isFirstTime = true; 
        update newLead;
        newLead.Status = 'Qualified';
        Test.StartTest();
        update newLead;
        Test.StopTest();
        
    }
    
    public testmethod static void UpdateStatusAsQualified(){ 
        
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Condition_Description__c descrip = OrientationandTrainingUtil.createConditionDesCription(); 
        insert descrip;
        ICD_Codes__c icdCode = OrientationandTrainingUtil.createICDCode(descrip.Id);
        insert icdCode;
        Lead newLead = OrientationandTrainingUtil.createTestLeadRecwithDupe(chapterAccount.Id); 
        newLead.Sibling_Detail__c = 'aa | bbb | 12 '+'<br/>'+' bb | - | 13' +'<br/>'+' -| cc | 13'+'<br/>'+' dd | dd |-'+'<br/>'+' -| ee |-'+'<br/>'+' -| ee |-'+'<br/>'+' ff| - |-';
        newLead.Child_Age__c = '4';
        newLead.unique_wish_identifier__c = '123456';
        
        insert newLead;
        
        Diagnosis_Verification__c newDV = new Diagnosis_Verification__c();
        newDV.ICD_Code__c = icdCode.Id;
        newDV.Lead__c = newLead.id;
        insert newDV;
        
        newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        RecursiveTriggerHandler.isFirstTime = true; 
        update newLead;
        newLead.Status = 'Qualified';
        Test.startTest();
        update newLead ;
        Test.stopTest();
        
        
    }
    
    
    public testmethod static void UpdateStatusAsQualifiedwithContactId(){ 
        
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        
        Condition_Description__c descrip = OrientationandTrainingUtil.createConditionDesCription(); 
        insert descrip;
        ICD_Codes__c icdCode = OrientationandTrainingUtil.createICDCode(descrip.Id);
        insert icdCode;
        Contact medicalProCon = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        
        Lead newLead = OrientationandTrainingUtil.createTestLeadRecwithDupe(chapterAccount.Id); 
        newLead.Sibling_Detail__c = 'aa | bbb | 12 '+'<br/>'+' bb | - | 13' +'<br/>'+' -| cc | 13'+'<br/>'+' dd | dd |-'+'<br/>'+' -| ee |-'+'<br/>'+' -| ee |-'+'<br/>'+' ff| - |-';
        newLead.Child_Age__c = '4';
        newLead.unique_wish_identifier__c = '123456';
        
        insert newLead;
        Lead_File__c  leadFile = OrientationandTrainingUtil.createLeadFileRecord(newLead.Id);
        Diagnosis_Verification__c newDV = new Diagnosis_Verification__c();
        newDV.ICD_Code__c = icdCode.Id;
        newDV.Lead__c = newLead.id;
        insert newDV;
        
        
        
        newLead.Status = 'Referred';
        newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        RecursiveTriggerHandler.isFirstTime = true; 
        update newLead;
        
        newLead.Status = 'Qualified';
        Test.startTest();
        update newLead ;
        Test.stopTest();
        
        
    }
    
    /*This method is used to increase the code coverage for CreateNewCase method when the lead status is updated as 'Eligibility Review'. */ 
    public testmethod static void UpdateStatusAsEligibilityReview(){ 
        
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
        Account alabamaAccountRec = OrientationandTrainingUtil.AlabamaAccount();
        Office__c  officeRec = OrientationandTrainingUtil.createOffice(alabamaAccountRec .Id);
        Zip_Code__c  zipRec = OrientationandTrainingUtil.createZipcode(officeRec.Id);
        Condition_Description__c  newDesCription = OrientationandTrainingUtil.createConditionDesCription();
        ICD_Codes__c  NewIcdCode = OrientationandTrainingUtil.createICDCode(newDesCription.Id);
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
        newLead.Child_Age__c = '4';
        newLead.unique_wish_identifier__c = '123456';
        // newLead.Sub_Status__c ='Pending Diagnosis Verification';
        insert newLead;
        newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        update newLead;
        
        newLead.Status = 'Eligibility Review';
        newLead.Treating_Medical_Professional_Email__c  = 'testmawa3@gmail.com';
        newLead.Postalcode = '32193';
        newLead.PD_ICD_Code__c  =  NewIcdCode.Id;
        newLead.PD_Condition_Description__c = 'Malignant Melanoma';
        newLead.Medical_Questions__c = 'YES Test Diagnosis';
        newLead.Dup_Check__c = 'Block Lead Dup';
        newLead.unique_wish_identifier__c = '123455';
        Test.startTest();
        update newLead ;
        Test.stopTest();
        
    } 
    
    public testmethod static void UpdateStatusDNQ(){ 
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        User nationalStaff;
        System.RunAs(currUser)
        {   
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id);
        }
        Id chapterAccount = OrientationandTrainingUtil.CreateAlabamaAccount();
        Contact medicalProfessionalCon = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        Contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount);
        newLead.ChapterName__c = OrientationandTrainingUtil.CreateAlabamaAccount();
        newLead.OwnerId =nationalStaff.Id;
        newLead.status = 'Referred';
        Insert newlead;
        //system.assertequals(chapterAccount,[SELECT ChapterName__r.Name FROM lead WHERE Id =: newlead.Id].ChapterName__c);
        system.assertequals('Referred',[SELECT status FROM lead WHERE Id =: newLead.Id].Status);
        newlead.Status = 'DNQ';
        Test.startTest();
        update newlead;
        Test.stopTest();
        system.assertequals('DNQ',[SELECT status FROM lead WHERE Id =: newlead.Id].Status);
        
    }
    
}