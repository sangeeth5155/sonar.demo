/*****************************************************************************************************************
Created By : MST Solutions
Created Date : 1/23/2017
Description : This test class used to perform unit testing for the DV Medical Summary Attachment
*******************************************************************************************************************/
@isTest
public class DVMedicalSummaryAttachment_AC_Test {
    
    @testSetup
    public static void setUpData(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
        newLead.unique_wish_identifier__c = '059-17-12367';
        Lead_File__c newLeadFile = OrientationandTrainingUtil.createLeadFileRecord(newLead.Id);
        try{
            insert newLead;
        }Catch(exception ex){
            System.debug('Exception'+ex.getMessage());
        }
    }
    
    //Attachment for Diagnosis Verification
    public static testMethod void GetAttachment() {
        Lead newLead = [SELECT ID FROM Lead];        
        List<Lead_File__c> leadFile = [SELECT Id FROM Lead_File__c];
        Test.startTest();
        PageReference pageRef = Page.DVMedicalSummaryAttachment_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',newLead.Id);
        ApexPages.currentPage().getParameters().put('saved','true');
        DVMedicalSummaryAttachment_AC currDiagnosisVerificationDupe = new DVMedicalSummaryAttachment_AC();
        currDiagnosisVerificationDupe.getAttachments();
        Attachment attach = new Attachment();   	
        attach.Name ='Wish Child Medical Summary';
        Blob bodyBlob = Blob.valueOf('Medical Summary Wish Child');
        attach.body = bodyBlob;
        currDiagnosisVerificationDupe.newAttachment = attach;
        currDiagnosisVerificationDupe.save();
        currDiagnosisVerificationDupe.Refresh();
        currDiagnosisVerificationDupe.attachmentId = leadFile[0].Id;
        currDiagnosisVerificationDupe.RemoveAttachment();
        Test.stopTest();
    }
}