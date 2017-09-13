/*****************************************************************************************************************
Author      : MST Solutions
Date        : 11/14/2016
Created By  : Mariyappan Sivathanu.
Description : 
1.This testClass is used to Relationship_AT for Relationship Contact.
2.Create Record for child wishes.
3.Submits parent wish for approval once the required number of volunteers added to the parent wish team.
4.Add parent wish team members to child wish team.
*****************************************************************************************************************/
@isTest
public class    DocusignRecipientTrigger_AT_Test{


    static testMethod void dsfsStatusRec(){
    
    Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
    
    Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
    Contact contactWishParent =  OrientationandTrainingUtil.CreateWishFamily();    
    Case caseRec = OrientationandTrainingUtil.CreateParentCase(contactWishChild.id);
    
    Wish_Child_Form__c wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(caseRec.Id);
    wishChildFormIns.Participant_Contacts__c = 'Vennila | | karur | Child | 2016-11-01 00:00:00 | asdfasdfdsafasfdsa@12gmail.com | 12 | true | true sathis Kumar | | def | Friend | - | vi@gmail.com | | false | false';
    Insert  wishChildFormIns;
    npe4__Relationship__c  npe4Rec = OrientationandTrainingUtil.relationshipChild(contactWishParent.Id,contactWishChild.Id);
    dsfs__DocuSign_Status__c dsfsStatus = OrientationandTrainingUtil.createDocusignStatuswithCase(caseRec.id);
    dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfsStatus.Id);
    
    dsfs__DocuSign_Recipient_Status__c updateRecipient = new dsfs__DocuSign_Recipient_Status__c();
    updateRecipient.Id =dsfsRecipient.Id;
    updateRecipient.dsfs__Recipient_Status__c = 'Completed';
    update updateRecipient;
     
    system.AssertEquals(updateRecipient.dsfs__Recipient_Status__c,'Completed');
    }

    static testMethod void dsfsStatusRecWithName(){
    
    Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
    
    Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
    Contact contactWishParent =  OrientationandTrainingUtil.CreateWishFamily();    
    Case caseRec = OrientationandTrainingUtil.CreateParentCase(contactWishChild.id);
    case updatecase = new Case();
    updatecase.Hidden_Name_List__c = 'Kesav';
    updatecase.Id = caseRec.Id;
    update updatecase;
    Wish_Child_Form__c wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(updatecase.Id);
    wishChildFormIns.Participant_Contacts__c = 'Vennila | | karur | Child | 2016-11-01 00:00:00 | asdfasdfdsafasfdsa@12gmail.com | 12 | true | true sathis Kumar | | def | Friend | - | vi@gmail.com | | false | false';
    Insert  wishChildFormIns;
    npe4__Relationship__c  npe4Rec = OrientationandTrainingUtil.relationshipChild(contactWishParent.Id,contactWishChild.Id);
    dsfs__DocuSign_Status__c dsfsStatus = OrientationandTrainingUtil.createDocusignStatuswithCase(updatecase.id);
    dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfsStatus.Id);
    
    dsfs__DocuSign_Recipient_Status__c updateRecipient = new dsfs__DocuSign_Recipient_Status__c();
    updateRecipient.Id =dsfsRecipient.Id;
    updateRecipient.dsfs__Recipient_Status__c = 'Completed';
    update updateRecipient;
     
    system.AssertEquals(updateRecipient.dsfs__Recipient_Status__c,'Completed');
    }

}