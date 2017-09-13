@isTest
public class SendEmailToMacTeam_AC_Test {
    
    static testmethod void callSendEmailToMac(){
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
        Contact newContact = OrientationandTrainingUtil.CreateMedicalProfContact();
        Case newDiagnosis = OrientationandTrainingUtil.CreateDiagnosisNewCase();
        dsfs__DocuSign_Status__c newDocusign = OrientationandTrainingUtil.CreateDocusignRecord();
        OrientationandTrainingUtil.CreateAttachmentRecord();
        SendEmailToMacTeam_AC.sendEmailToMac(newContact.id, newLead.id, newDiagnosis.id, 'Local', newDiagnosis.MAC_Email__c);
    }
    
    static testmethod void callSendEmai(){
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
        Contact newContact = OrientationandTrainingUtil.CreateMedicalProfContact();
        Case newDiagnosis = OrientationandTrainingUtil.CreateDiagnosisNewCase();
        dsfs__DocuSign_Status__c newDocusign = OrientationandTrainingUtil.CreateDocusignRecord();
        OrientationandTrainingUtil.CreateAttachmentRecord();
        SendEmailToMacTeam_AC.sendEmailToMac(newContact.id, newLead.id, newDiagnosis.id, 'National', newDiagnosis.MAC_Email__c);
    }
    
    
}