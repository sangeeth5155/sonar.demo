/************************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 22/10/2016
Description : RelationshipsViewer_AC_Test is used to increase the code coverage for RelationshipsViewer_AC controller.
****************************************************************************************************************************/

@isTest
public class RelationshipsViewer_AC_Test{
    
    /*This EditContacts() is used to edit wish child and wish family contacts.*/
    public testmethod static void EditContacts(){
        /*Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon(); 
        Contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        npe4__Relationship__c relationship = OrientationandTrainingUtil.CreateRelationshipRec(wishChild.Id,wishFamily.Id);
        case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        
        PageReference pageRef = Page.RelationshipsViewer_VF; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('recId', parentCase.Id);
        RelationshipsViewer_AC rlationshipIns = new RelationshipsViewer_AC();
        List<String> Option;
        rlationshipIns.UpdateContactInfo();
        rlationshipIns.getStates();
    }
    
    /*This UpdateWishChild() is used to update wish child  contact.*/
    public testmethod static void UpdateWishChild(){
        List<Contact> wishchildList = new List<Contact>();
      /*  Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon(); 
        Contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        npe4__Relationship__c relationship = OrientationandTrainingUtil.CreateRelationshipRec(wishChild.Id,wishFamily.Id);
        case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        
        PageReference pageRef = Page.RelationshipsViewer_VF; 
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('recId', parentCase.Id);
        RelationshipsViewer_AC rlationshipIns = new RelationshipsViewer_AC();
        
        rlationshipIns.UpdateContactInfo();
        rlationshipIns.getStates();
       
        Contact updateWishChild = new Contact();
        updateWishChild.Id = wishChild.Id;
        updateWishChild.Phone = '8056913402';
        updateWishChild.Email = 'test@gmail.com';
        updateWishChild.MailingStreet = 'North Street';
        updateWishChild.MailingCity = 'Chennai';
        updateWishChild.MailingState = 'Alabama';
        updateWishChild.MailingCountryCode = 'US';
        updateWishChild.MailingPostalCode = '621010';
        wishchildList.add(updateWishChild);
        update wishchildList;  
        
        rlationshipIns.wishChildContactList = wishchildList;
        rlationshipIns.SaveUpdatedContact();
    }
    
    
    /*This UpdateWishChild() is used to update wish child  contact Email.*/
    public testmethod static void UpdateWishChildEmail(){
        List<Contact> wishchildList = new List<Contact>();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon(); 
        Contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        npe4__Relationship__c relationship = OrientationandTrainingUtil.CreateRelationshipRec(wishChild.Id,wishFamily.Id);
        case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        
        PageReference pageRef = Page.RelationshipsViewer_VF; 
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('recId', parentCase.Id);
        RelationshipsViewer_AC rlationshipIns = new RelationshipsViewer_AC();
        
        rlationshipIns.UpdateContactInfo();
        rlationshipIns.getStates();
       
        Contact updateWishChild = new Contact();
        updateWishChild.Id = wishChild.Id;
        wishchildList.add(updateWishChild);
        update wishchildList;  
        
        rlationshipIns.wishChildContactList = wishchildList;
        rlationshipIns.SaveUpdatedContact();
    }
    
    
    /*This UpdateFamily() is used to update wish family contacts.*/
    public testmethod static void UpdateFamily(){
        
        List<Contact> wishFamilyList = new List<Contact>();
        PageReference pageRef = Page.RelationshipsViewer_VF; 
        Test.setCurrentPage(pageRef);
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon(); 
        Contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        
        npe4__Relationship__c relationship = OrientationandTrainingUtil.CreateRelationshipRec(wishChild.Id,wishFamily.Id);
        case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        
        ApexPages.currentPage().getParameters().put('recId', parentCase.Id);
        RelationshipsViewer_AC rlationshipIns = new RelationshipsViewer_AC();
        
        
        rlationshipIns.UpdateContactInfo();
        rlationshipIns.getStates();
        
        Contact updatewishFamily = new Contact();
        updatewishFamily.Id = wishFamily.Id;
        updatewishFamily.Phone = '8056913402';
        updatewishFamily.Email = 'test@gmail.com';
        updatewishFamily.MailingStreet = 'North Street';
        updatewishFamily.MailingCity = 'Chennai';
        updatewishFamily.MailingState = 'Alabama';
        updatewishFamily.MailingCountryCode = 'US';
        updatewishFamily.MailingPostalCode = '621010';
        wishFamilyList .add(updatewishFamily);
        update wishFamilyList;
        
        rlationshipIns.clonedFamilyContactList = wishFamilyList;
        
        
        rlationshipIns.SaveUpdatedContact();
        rlationshipIns.close();
        
    }
}