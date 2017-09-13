/*****************************************************************************
Author : MST Solutions
CreateDate : 05/5/2017
Description : UpdateWishFamily_AT_Test is used to increase the code coverage for UpdateWishFamily_AT.
******************************************************************************/
@isTest
public class UpdateWishFamily_AT_Test{
    
    public static testmethod void createWishPaperWork(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
        Wish_Child_Form__c wishChildForm = new Wish_Child_Form__c();
        wishChildForm.Case__c = caseId.id;
        wishChildForm.RelatedContact__c = contactWishChild.id;
        wishChildForm.Participant_require_a_wheelchair__c = 'No';
        wishChildForm.Will_your_family_bring_wheelchair__c = 'No';
        wishChildForm.Is_the_wheelchair_collapsible__c = 'No';
        wishChildForm.Is_the_wheelchair_power__c = 'No';
        wishChildForm.Participant_require_oxygen_how_often__c  ='No';
        wishChildForm.Participant_dietary_restrictions__c = 'No';
        wishChildForm.Participant_have_allergies_to_food__c = 'No';
        wishChildForm.Medication_require_refrigeration__c = 'No';
        wishChildForm.Wish_child_receive_nursing_care__c = 'No';
        wishChildForm.Participant_require_medical_supplies__c = 'No';
        insert wishChildForm;
        Wish_Child_Form__c updatewishChildForm = new Wish_Child_Form__c();
        updatewishChildForm.id = wishChildForm.id;
        updatewishChildForm.Requested_Participant_Name_forWheelchair__c ='';
        updatewishChildForm.Bringing_Own_Wheel_Chair__c ='';
        update wishChildForm ;
        
        
    }
    
    public static testmethod void updateWishPaperWork(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
        Wish_Child_Form__c wishChildForm = new Wish_Child_Form__c();
        wishChildForm.Case__c = caseId.id;
        wishChildForm.RelatedContact__c = 'Test1';
        insert wishChildForm;
        
        Wish_Child_Form__c updatewishChildForm = new Wish_Child_Form__c();
        updatewishChildForm.id = wishChildForm.id;
        updatewishChildForm.Wish_Family_Contact__c = 'Test';
        updatewishChildForm.RelatedContact__c = contactWishChild.id;
        update updatewishChildForm;
        
        Contact cont = new Contact();
        cont.id = updatewishChildForm.RelatedContact__c;
        cont.RelatedContacts__c = updatewishChildForm.id;
        update cont;
        
    }
    
}