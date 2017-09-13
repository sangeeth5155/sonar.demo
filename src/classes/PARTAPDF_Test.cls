/*****************************************************************************************************************
Created By : MST Solutions
Created Date : 11/27/2016
Description : This test class used to perform unit testing for the 'Docusign Page (LeadPartA Output PDF)'. 
*******************************************************************************************************************/

@isTest
public class PARTAPDF_Test {
    
    @testSetup
    public static void setUpData(){
        Condition_Description__c condistionDescription = OrientationandTrainingUtil.createConditionDesCription();
        try{
            insert condistionDescription;            
        }Catch(exception ex){
            System.debug('Exception'+ex.getMessage());
        }
        ICD_Codes__c iCDCode = OrientationandTrainingUtil.createICDCode(condistionDescription.Id);        
        List<Medical_Questions__c> medicalQuestion = OrientationandTrainingUtil.CreateMedicalQuestion(condistionDescription.Id);        
        try{
            insert iCDCode;
            insert medicalQuestion;    
        }Catch(exception ex){
            System.debug('Exception'+ex.getMessage());
        }
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
       // newLead.PD_ICD_Code__c = 'C00';
        newLead.Current_Condition__c = 'Test1;Test2;Test3;';
        newLead.Current_Condition_Label__c = 'Test1;Test2;Test3;';
        newLead.PD_Condition_Description__c = 'Malignant Melanoma';  
        newLead.unique_wish_identifier__c = '123456';
       
        insert newLead;    
        
        Lead_File__c newFile = new Lead_File__c();
        newFile.Parent__c = newLead.Id;
        newFile.Description__c = 'SampleDesc';
        newFile.File_Path__c = 'TestPath';
        newFile.File_Name__c = 'File';
        try{
            insert newFile; 
        }Catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
        }
    }
    
    
    public static testmethod void checkDiadnosisVerificationFormForValidDiagnosisAtPrimaryDiagnosis(){
        Lead newLead = [SELECT ID FROM Lead];        
        Condition_Description__c condistionDescription = [SELECT ID,Name,Code_To_Use__c FROM Condition_Description__c];
        Test.startTest();
        PageReference pageRef = Page.DiagnosisVerification_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('leadId',newLead.Id);
        PARTAPDF partAPDF = new PARTAPDF();
        partAPDF.loadData();
        Test.stopTest();
    }
}