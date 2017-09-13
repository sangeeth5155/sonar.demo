/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : DocusignStatusTrigger_AT_Test is used to increase the code coverage for Application_AC controller.
*****************************************************************************************************/
@isTest
public class DocusignStatusTrigger_AT_Test{
    
    
    
    
    /*This method is used to update the isConfilict status as true when the envelop status is completed.*/
    
    public testmethod static void updateisConfilicttoTrue(){ 
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id); 
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCon(VolunteerContact.Id);
        
        Conflict_Of_Interest__c coi = new Conflict_Of_Interest__c();
        coi.current__c = true;
        coi.Volunteer_Contact__c = VolunteerContact.id;
        insert coi;
        
        
        Conflict_Of_Interest__c conOfInt = new Conflict_Of_Interest__c();
        conOfInt.current__c = true;
        conOfInt.Volunteer_Contact__c = VolunteerContact.id;
        insert conOfInt;
        
        dsfs__DocuSign_Status__c dbdsfs = new dsfs__DocuSign_Status__c ();
        dbdsfs.dsfs__Envelope_Status__c  = 'Completed';
        dbdsfs.Id = dsfs.Id;
        dbdsfs.Docusign_Hidden_Contact__c = VolunteerContact.id;
        dbdsfs.isConflict__c =  true;
        update dbdsfs;
        
        
        
        
    }
    
    /*This method is used to update the isConfilict status as false when the envelop status is completed.*/
    public testmethod static void updateisConfilicttoFalse(){  
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id); 
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCon(VolunteerContact.Id);
        dsfs.dsfs__Contact__c = VolunteerContact.id;
        dsfs.dsfs__Subject__c = 'Diagnosis Verification Form';
        upsert dsfs;
        dsfs__DocuSign_Status__c dbdsfs = new dsfs__DocuSign_Status__c ();
        dbdsfs.dsfs__Envelope_Status__c  = 'Completed';
        dbdsfs.Id = dsfs.Id;
        dbdsfs.Docusign_Hidden_Contact__c  = volunteerContact.id;
        dbdsfs.isConflict__c =  false;
        update dbdsfs;
        
        Conflict_Of_Interest__c coi = new Conflict_Of_Interest__c();
        coi.current__c = true;
        coi.Volunteer_Contact__c = VolunteerContact.id;
        insert coi;
        
    }
    
    /*This method is used to convert the lead when the docusign status is completed.*/
    
    public testmethod static void convertlead(){
        
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
        newLead.unique_wish_identifier__c = '123456';
        insert newLead;
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatus(newLead.Id);
        
        
        Lead updateLead = new Lead();
        updateLead.Status = 'Referred';
        updateLead.RFI_Form_Info_Hidden__c = 'Qualified';
        updateLead.Sub_Status__c = 'Pending Diagnosis Verification';
        updateLead.Id = newLead.Id;
        update updateLead;
        
        dsfs__DocuSign_Status__c dbdsfs = new dsfs__DocuSign_Status__c ();
        dbdsfs.dsfs__Envelope_Status__c  = 'Completed';
        dbdsfs.Id = dsfs.Id;
        dbdsfs.dsfs__Lead__c = newLead.id;
        update dbdsfs;
        
        
        
    }  
    
    public testmethod static void convertleadStatusNotQualified(){
        
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
        newLead.unique_wish_identifier__c = '123456';
        insert newLead;
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatus(newLead.Id);
        
        Lead updateLead = new Lead();
        updateLead.Status = 'Referred';
        updateLead.RFI_Form_Info_Hidden__c = 'Not Qualified';
        updateLead.Sub_Status__c = 'Pending Diagnosis Verification';
        updateLead.Id = newLead.Id;
        update updateLead;
        
        dsfs__DocuSign_Status__c dbdsfs = new dsfs__DocuSign_Status__c ();
        dbdsfs.dsfs__Envelope_Status__c  = 'Completed';
        dbdsfs.Id = dsfs.Id;
        dbdsfs.dsfs__Lead__c = newLead.id;
        update dbdsfs;
        
    } 
    
    public testmethod static void updateDocusignStatus(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact wishChildContact = OrientationandTrainingUtil.CreateWishChild(); 
       
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.CreateDocusignRecord();
        Attachment attch = OrientationandTrainingUtil.CreateAttachmentRecordWishChild( dsfs.id);
        dsfs.dsfs__Subject__c = 'Diagnosis Verification Form';
        dsfs.dsfs__Contact__c = wishChildContact.id;
        update dsfs;
         
    }
}