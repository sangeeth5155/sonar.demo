/*
Created By : MST Solutions
Created Date : Jan - 16 - 2017
Description : This test class used to perform unit testing for the 'Diagnosis Verficiation Form'. 
*/
@isTest
public class DiagnosisVerification_AC_Test {
    @testSetup
    public static void setUpData(){
        Condition_Description__c condistionDescription = OrientationandTrainingUtil.createConditionDesCription();
        
        insert condistionDescription;            
        
        ICD_Codes__c iCDCode = OrientationandTrainingUtil.createICDCode(condistionDescription.Id);        
        List<Medical_Questions__c> medicalQuestion = OrientationandTrainingUtil.CreateMedicalQuestion(condistionDescription.Id);        
        
        insert iCDCode;
        insert medicalQuestion;    
        
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
        newLead.PD_ICD_Code__c = iCDCode.Id;
        newLead.Current_Condition__c = 'Test1;Test2;Test3;';
        newLead.Current_Condition_Label__c = 'Test1;Test2;Test3;';
        newLead.PD_Condition_Description__c = 'Malignant Melanoma';  
        newLead.unique_wish_identifier__c = '059-17-12367';
        
        insert newLead;    
        WishChildWrapper wc = new WishChildWrapper();
        wc.describePatient = 'Yes';
        wc.password = '123456';
        wc.getStateRecognizationPicklistValues();
        wc.getCommunications();
        wc.getHealthCareWorks();
        
        Lead_File__c newFile = new Lead_File__c();
        newFile.Parent__c = newLead.Id;
        newFile.Description__c = 'SampleDesc';
        newFile.File_Path__c = 'TestPath';
        newFile.File_Name__c = 'File';
        
        insert newFile; 
        
    }
    
    public static testmethod void checkDiadnosisVerificationFormForValidDiagnosisAtPrimaryDiagnosis(){
        Lead newLead = [SELECT ID FROM Lead];        
        Condition_Description__c condistionDescription = [SELECT ID,Name,Code_To_Use__c FROM Condition_Description__c];
        Test.startTest();
        PageReference pageRef = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupe = new DiagnosisVerification_AC();
        PartAFormWrapper pw = new PartAFormWrapper();
        pw.getchronicHeartFailureList();
        pw.getcongenitalHeartDiseaseList();
        pw.getconvulsiveDisorderList();
        pw.getStrokeValues();
        pw.getPulmonaryHypertensionValues();
        pw.getHepatitisValues();
        pw.getheartFailureList();
        pw.getArrhythmiaList();
        pw.getanginaList();
        pw.getventilatorList();
        pw.getLungDiseaseList();
        pw.age = '23';
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        currDiagnosisVerificationDupe.SubmitSign();
        DiagnosisWrapper dw = new DiagnosisWrapper();
        dw.conditionDescription = 'ss';
        //Setting the Primary Diagnosis
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','PCD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        //Answer for the Question;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'Yes';
        ApexPages.currentPage().getParameters().put('medicalResponse','Yes'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0'); 
        currDiagnosisVerificationDupe.MedicalResponse();
        currDiagnosisVerificationDupe.SaveMedicalInformation();
        List<Diagnosis_Verification__c> diagnosisVerificationLst = [SELECT ID,isEligible__c,(SELECT isEligible__c FROM DiagnosisMedicalQuestions__r) FROM Diagnosis_Verification__c WHERE Lead__c =: newLead.Id ];     
        
        Test.stopTest();
    }
    
    public static testmethod void checkDiadnosisVerificationFormForInValidDiagnosisAtPrimaryDiagnosis(){
        Lead newLead = [SELECT ID FROM Lead];        
        Condition_Description__c condistionDescription = [SELECT ID,Name,Code_To_Use__c FROM Condition_Description__c];
        Test.startTest();
        PageReference pageRef = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupe = new DiagnosisVerification_AC();
        //Setting the Primary Diagnosis
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','PCD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        //Answer for the Question;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'No';
        ApexPages.currentPage().getParameters().put('medicalResponse','No'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0'); 
        currDiagnosisVerificationDupe.MedicalResponse();
        currDiagnosisVerificationDupe.SaveMedicalInformation();
        List<Diagnosis_Verification__c> diagnosisVerificationLst = [SELECT ID,isEligible__c,(SELECT isEligible__c FROM DiagnosisMedicalQuestions__r) FROM Diagnosis_Verification__c WHERE Lead__c =: newLead.Id ];        
        Test.stopTest();
    }
    
    public static testmethod void checkDiadnosisVerificationFormWithSecondaryDiagnosis(){
        Lead newLead = [SELECT ID FROM Lead];
        
        Condition_Description__c condistionDescription = [SELECT ID,Name,Code_To_Use__c FROM Condition_Description__c];
        Test.startTest();
        PageReference pageRef = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupe = new DiagnosisVerification_AC();
        //Setting the Primary Diagnosis
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','PCD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        //Answer for the Question;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'No';
        ApexPages.currentPage().getParameters().put('medicalResponse','No'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0'); 
        currDiagnosisVerificationDupe.MedicalResponse();
        currDiagnosisVerificationDupe.addDiagnosisVerification();
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[1].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[1].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','ICD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','1');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'Yes';
        ApexPages.currentPage().getParameters().put('medicalResponse','Yes'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','1'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0');            
        currDiagnosisVerificationDupe.MedicalResponse();
        ApexPages.currentPage().getParameters().put('medicalResponse','No'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','1'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0');
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'No';
        currDiagnosisVerificationDupe.changeWishStatus();
        currDiagnosisVerificationDupe.SaveMedicalInformation();
        List<Diagnosis_Verification__c> diagnosisVerificationLst = [SELECT ID,isEligible__c,(SELECT isEligible__c FROM DiagnosisMedicalQuestions__r) FROM Diagnosis_Verification__c WHERE Lead__c =: newLead.Id ];        
        Test.stopTest();
    }
    
    public static testmethod void checkDiadnosisVerificationFormRemoveDiagnosisFunction(){
        Lead newLead = [SELECT ID FROM Lead];       
        Condition_Description__c condistionDescription = [SELECT ID,Name,Code_To_Use__c FROM Condition_Description__c];
        Test.startTest();
        PageReference pageRef = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupe = new DiagnosisVerification_AC();
        //Setting the Primary Diagnosis
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','PCD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        //Answer for the Question;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'No';
        ApexPages.currentPage().getParameters().put('medicalResponse','No'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0'); 
        currDiagnosisVerificationDupe.MedicalResponse();
        currDiagnosisVerificationDupe.addDiagnosisVerification();
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[1].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[1].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','ICD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','1');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'Yes';
        ApexPages.currentPage().getParameters().put('medicalResponse','Yes'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','1'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0');            
        currDiagnosisVerificationDupe.MedicalResponse();
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','1');
        currDiagnosisVerificationDupe.RemoveDiagnosisBlock();
        currDiagnosisVerificationDupe.SaveMedicalInformation();
        List<Diagnosis_Verification__c> diagnosisVerificationLst = [SELECT ID,isEligible__c,(SELECT isEligible__c FROM DiagnosisMedicalQuestions__r) FROM Diagnosis_Verification__c WHERE Lead__c =: newLead.Id ];        
        Test.stopTest();
    }
    
    public static testmethod void checkDiadnosisVerificationFormWithDiagnosisVerficationData(){
        Lead newLead = [SELECT ID FROM Lead];
        newLead.Increased_probability_of_premature_death__c = true;
        Condition_Description__c condistionDescription = [SELECT ID,Name,Code_To_Use__c FROM Condition_Description__c];
        Test.startTest();
        PageReference pageRef = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupe = new DiagnosisVerification_AC();
        //Setting the Primary Diagnosis
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','PCD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        //Answer for the Question;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'No';
        ApexPages.currentPage().getParameters().put('medicalResponse','No'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0'); 
        currDiagnosisVerificationDupe.MedicalResponse();
        currDiagnosisVerificationDupe.addDiagnosisVerification();
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[1].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[1].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','ICD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','1');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'Yes';
        ApexPages.currentPage().getParameters().put('medicalResponse','Yes'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','1'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0');            
        currDiagnosisVerificationDupe.MedicalResponse();        
        currDiagnosisVerificationDupe.SaveMedicalInformation();
        List<Diagnosis_Verification__c> diagnosisVerificationLst = [SELECT ID,isEligible__c,(SELECT isEligible__c FROM DiagnosisMedicalQuestions__r) FROM Diagnosis_Verification__c WHERE Lead__c =: newLead.Id ];        
        PageReference pageRefUpdate = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRefUpdate);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupeUpdated = new DiagnosisVerification_AC();
        List<Condition_Description__c> conditionDescriptionLst = DiagnosisVerification_AC.searchCondition('Mali');
        List<ICD_Codes__c> iCDCodeLst = DiagnosisVerification_AC.searchDiagnosis('C43.30');
        Test.stopTest();
    }
    
    public static testmethod void checkDiadnosisVerificationFormWithDiagnosisVerficationDataandMedicalQuestion(){
        Lead newLead = [SELECT ID FROM Lead];
        newLead.Increased_probability_of_premature_death__c = true;
        Condition_Description__c condistionDescription = [SELECT ID,Name,Code_To_Use__c FROM Condition_Description__c];
        Test.startTest();
        PageReference pageRef = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupe = new DiagnosisVerification_AC();
        //Setting the Primary Diagnosis
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','PCD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        //Answer for the Question;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'No';
        ApexPages.currentPage().getParameters().put('medicalResponse','No'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0'); 
        currDiagnosisVerificationDupe.MedicalResponse();
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[1].epilepsySelectedPickVal = 'No';
        ApexPages.currentPage().getParameters().put('medicalResponse','No'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','1'); 
        currDiagnosisVerificationDupe.MedicalResponse();
        currDiagnosisVerificationDupe.SaveMedicalInformation();
        currDiagnosisVerificationDupe.deleteLeadFile();
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0');
        List<Diagnosis_Verification__c> diagnosisVerificationLst = [SELECT ID,isEligible__c,(SELECT isEligible__c FROM DiagnosisMedicalQuestions__r) FROM Diagnosis_Verification__c WHERE Lead__c =: newLead.Id ];                        
        PageReference pageRefUpdate = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRefUpdate);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupeUpdated = new DiagnosisVerification_AC();
        Test.stopTest();
    }
    
    
    public static testmethod void checkDiadnosisVerificationFormWithDiagnosisVerficationDataandWithoutMedicalQuestion(){
        List<Medical_Questions__c> medicalQuestion = [SELECT Id FROM Medical_Questions__c];
        medicalQuestion.clear();
        Lead newLead = [SELECT ID FROM Lead];
        newLead.Increased_probability_of_premature_death__c = true;
        Condition_Description__c condistionDescription = [SELECT ID,Name,Code_To_Use__c FROM Condition_Description__c];
        Test.startTest();
        PageReference pageRef = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupe = new DiagnosisVerification_AC();
        //Setting the Primary Diagnosis
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].conditionDescription = condistionDescription.Name;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].iCDCode = condistionDescription.Code_To_Use__c;
        ApexPages.currentPage().getParameters().put('icdOrPcd','PCD');
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0');
        currDiagnosisVerificationDupe.WishChildEligibilityCheck();
        //Answer for the Question;
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[0].selectedPickVal = 'No';
        ApexPages.currentPage().getParameters().put('medicalResponse','No'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','0'); 
        currDiagnosisVerificationDupe.MedicalResponse();
        currDiagnosisVerificationDupe.diagnosisVerificationWrapperLst[0].medicalWrapperList[1].epilepsySelectedPickVal = 'No';
        ApexPages.currentPage().getParameters().put('medicalResponse','No'); //Used to hold the Medical Question response 
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0'); // Used to hold the Diagnosis block number
        ApexPages.currentPage().getParameters().put('questionNumber','1'); 
        currDiagnosisVerificationDupe.MedicalResponse();
        currDiagnosisVerificationDupe.SaveMedicalInformation();
        currDiagnosisVerificationDupe.deleteLeadFile();
        ApexPages.currentPage().getParameters().put('diagnosisBlockNum','0');
        currDiagnosisVerificationDupe.ResetDiagnosis();
        currDiagnosisVerificationDupe.changePatientValue();
        currDiagnosisVerificationDupe.submit();
        List<Diagnosis_Verification__c> diagnosisVerificationLst = [SELECT ID,isEligible__c,(SELECT isEligible__c FROM DiagnosisMedicalQuestions__r) FROM Diagnosis_Verification__c WHERE Lead__c =: newLead.Id ];        
        PageReference pageRefUpdate = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRefUpdate);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        DiagnosisVerification_AC currDiagnosisVerificationDupeUpdated = new DiagnosisVerification_AC();
        TravelAlgorithmWrapper pw = new TravelAlgorithmWrapper();
        pw.getchronicHeartFailureList();
        pw.getcongenitalHeartDiseaseList();
        pw.getconvulsiveDisorderList();
        pw.getStrokeValues();
        pw.getPulmonaryHypertensionValues();
        pw.getHepatitisValues();
        pw.getheartFailureList();
        pw.getArrhythmiaList();
        pw.getanginaList();
        pw.getventilatorList();
        pw.getLungDiseaseList();
        Test.stopTest();
    }
    
    
}