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
public class Relationship_AT_Test {
    
    
    // Method to invoke Contact Parent Guardian
    static testMethod void relatedContactParentGuardian()
    {
        /*Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactWishParent =  OrientationandTrainingUtil.CreateWishFamily();
        
        contact contactswish = new contact();
        contactswish.id = contactWishParent.id; 
        contactswish.IsParentGuardian__c = 'ParentGuardian';
        
        update contactswish;         
        npe4__Relationship__c relationShip = OrientationandTrainingUtil.relationshipChild(contactWishChild.id,contactswish.id);
        
        
    }
    
    // Method to invoke Contact Participant Guardian
    static testMethod void relatedContactParticipantGuardian()
    {
       /* Constituent_Code__c  constituntId=OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  constituntParentId=OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactWishParent =  OrientationandTrainingUtil.CreateWishFamily();
        
        contact contactswish = new contact();         
        contactswish.id = contactWishParent.id; 
        contactswish.IsParentGuardian__c = 'Participant';
        update contactswish; 
        npe4__Relationship__c relationShip = OrientationandTrainingUtil.relationshipChild(contactWishChild.id,contactswish.id);
        
    }
    
    // Method to invoke Contact Parent/Legal Guardian
    static testMethod void relatedContactParentOrLegalGuardian()
    {
        /*Constituent_Code__c  constituntId=OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  constituntParentId=OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactWishParent =  OrientationandTrainingUtil.CreateWishFamily();
        
        contact contactswish = new contact();         
        contactswish.id = contactWishChild.id; 
        contactswish.IsParentGuardian__c = 'ParentGuardian';
        contactswish.Parent_Legal_Guardian__c ='Parent/Guardian';
        contactswish.Recipient_Email__c = 'test@gmail.com';
        contactswish.First_Recipient_Name__c = 'test';
        update contactswish; 
        npe4__Relationship__c relationShip = OrientationandTrainingUtil.relationshipChild(contactWishParent.id,contactswish.id);
        
    }
    //This method is used to verify the after update functionlity when upadte parent guardian as true  
    static testMethod void relationshipRecordUpdate()
    {
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChildCon(); 
        Contact contactWishParent =  OrientationandTrainingUtil.CreateWishFamilyForRelationship();
        npe4__Relationship__c relationShip = OrientationandTrainingUtil.relationshipChildWithFalse(contactWishParent.id,contactWishChild.id);
        npe4__Relationship__c newRelation = new npe4__Relationship__c();
        newRelation.Id = relationShip.Id;
        newRelation.Parent_Legal_Guardian__c = True;
        update newRelation;
    }
    
    //This method is used to create test data for medicalprofcontact
    static testMethod void createMedicalProfContact(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChildCon(); 
        Contact contactMedicalProf =  OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c relationShip = OrientationandTrainingUtil.relationshipChildWithFalse(contactMedicalProf.id,contactWishChild.id);
    }
    
}