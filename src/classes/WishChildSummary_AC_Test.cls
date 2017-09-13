/*****************************************************************************
Author : MST Solutions
CreateDate : 03/25/2016
Description : WishChildSummary_AC_Test is used to increase the code coverage for WishChildSummary_AC.
******************************************************************************/

@isTest
public class WishChildSummary_AC_Test {
    
   public static testMethod void createParentCase(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRec(contactWishChild.Id,contactMedicalProfessChild.Id);
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
       
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseId);
        PageReference pageRef = Page.WishChildSummary_VF;
        pageRef.getParameters().put('id',String.valueOf(caseId.Id));
        Test.setCurrentPage(pageRef);
        WishChildSummary_AC wishClear = new WishChildSummary_AC(sc);
        wishClear.getMedicalProContact();
        wishClear.SendtoDocuSign();
        wishClear.DisplayMessage();
        wishCLear.DisplayErrorMessage();
        wishClear.displayEmail();
        wishClear.cancel();
        
    }
    
    public static testMethod void createParentCaseWithRush(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRec(contactWishChild.Id,contactMedicalProfessChild.Id);
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
        
        case updatecase = new case();
        updatecase.Rush__c = true;
        updatecase.Id = caseId.Id;
        updatecase.Rush_Explanation__c = 'test';
        updatecase.Rush_Timeframe__c = '0-31';
        updatecase.IsRushWishClearence_ChildSummary__c = true;
        update updatecase;
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(updatecase);
        PageReference pageRef = Page.WishChildSummary_VF;
        pageRef.getParameters().put('id',String.valueOf(updatecase.Id));
        Test.setCurrentPage(pageRef);
        WishChildSummary_AC wishClear = new WishChildSummary_AC(sc);
        wishClear.getMedicalProContact();
        wishClear.SendtoDocuSign();
        wishClear.DisplayMessage();
        wishCLear.DisplayErrorMessage();
        wishClear.displayEmail();
        wishClear.cancel();
        wishClear.ReturnToWish();
        wishClear.ReturnToWishClearanceForm();
        
        
    }
    
    public static testMethod void createParentCaseWithAirTravel(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRec(contactWishChild.Id,contactMedicalProfessChild.Id);
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
        
        case updatecase = new case();
        updatecase.wish_involves_air_travel__c = 'Yes' ;
        updatecase.Id = caseId.Id;
        updatecase.Description = 'test';
        updatecase.Wish_Clearance_Sent_Date__c = system.today();
        updatecase.Rush__c =true;
        updatecase.Rush_Explanation__c ='test';
        updatecase.Rush_Timeframe__c ='ASAP';
        update updatecase;
        
        case newCase = new case();
        newCase.IsRushWishClearence_ChildSummary__c = true;
        newCase.Id = caseId.id;
        update newCase;
        
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPAges.StandardController sc = new ApexPages.StandardController(updatecase);
        PageReference pageRef = Page.WishChildSummary_VF;
        pageRef.getParameters().put('id',String.valueOf(updatecase.Id));
        Test.setCurrentPage(pageRef);
        WishChildSummary_AC wishClear = new WishChildSummary_AC(sc);
        wishClear.getMedicalProContact();
        wishClear.SendtoDocuSign();
        wishClear.DisplayMessage();
        wishCLear.DisplayErrorMessage();
        wishClear.displayEmail();
        wishClear.cancel();
        wishClear.ReturnToWish();
        wishClear.ReturnToWishClearanceForm();
        
        
    }
       
    public static testMethod void createParentCaseWithTravel(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRec(contactWishChild.Id,contactMedicalProfessChild.Id);
        Case caseId = OrientationandTrainingUtil.CreateParentCaseWithTravel(contactWishChild.Id);
  
        case updatecase = new case();
        updatecase.Id = caseId.Id;
        updatecase.wish_involves_air_travel__c = caseId.wish_involves_air_travel__c;
        updatecase.Description = 'test';
        updatecase.Emergency_Number__c = Null;
        updatecase.Appropriate_Comments__c = Null;
        updatecase.Please_Explain__c = Null;
        updatecase.Date_of_last_visit_treatment__c = Null;
        updatecase.Rush__c =true;
        updatecase.Rush_Explanation__c ='test';
        updatecase.Rush_Timeframe__c ='ASAP';
        updatecase.Comments__c = Null;
        updatecase.Comment_1__c = Null;
        updatecase.Comment_2__c = Null;
        updatecase.Wish_Clearance_Sent_Date__c = system.today();
        updatecase.Wish_Clearance_Sent_Date__c = system.today();
        update updatecase;
        
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPAges.StandardController sc = new ApexPages.StandardController(caseId);
        PageReference pageRef = Page.WishChildSummary_VF;
        pageRef.getParameters().put('id',String.valueOf(caseId.Id));
        Test.setCurrentPage(pageRef);
        WishChildSummary_AC wishClear = new WishChildSummary_AC(sc);
        wishClear.medicalProfContactName = contactMedicalProfessChild.Name;
        wishClear.email = contactMedicalProfessChild.Email;
        wishClear.getMedicalProContact();
        wishClear.displayEmail();
        wishClear.SendtoDocuSign();
        Test.StartTest();
        boolean isRush = false;
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator());
        WishChildSummary_AC.CallouttoDocusign(caseId.id,contactMedicalProfessChild.Name,contactMedicalProfessChild.Email);
        System.assertEquals(wishClear.medicalProfContactName,contactMedicalProfessChild.Name);
        Test.StopTest();
    }

}