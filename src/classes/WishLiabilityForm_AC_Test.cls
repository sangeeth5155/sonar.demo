/*****************************************************************************
Author : MST Solutions
CreateDate : 14/11/2016
Description : WishLiabilityForm_AC_Test is used to increase the code coverage for WishLiabilityForm_AC.
******************************************************************************/
@isTest
public class WishLiabilityForm_AC_Test {
    
    /*This method is used to cover the code coverage of Constructor method*/
    public static testMethod void CalltheConstructorMethod(){ 
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        List<Contact> WishFamilyContactList = OrientationandTrainingUtil.CreateWishFamilyList(3);
        insert WishFamilyContactList;
        List<npe4__Relationship__c> npe4RelationShipList = OrientationandTrainingUtil.relationshipChildList(WishFamilyContactList,wishChild.Id,3);
        insert npe4RelationShipList;
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        wish.Hidden_Email_List__c = 'MAWAFirstName MAWALastName1,MAWAFirstName MAWALastName2';
        wish.Hidden_Name_List__c = 'kesavkumar@mstsolutions.com,kanagaraj@mstsolutions.com';
        update wish;
        Wish_Child_Form__c childForm  = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        insert childForm; 
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishLiabilityForm_VF;
        pageRef.getParameters().put('id',String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishLiabilityForm_AC wishLiabilityIns = new WishLiabilityForm_AC(sc);
        system.AssertEquals(wishChild.Id,wish.ContactId);
        
    }
    
    
    /*This method is used to cover the code coverage of Constructor else condition method*/
    public static testMethod void CalltheConstructorMethodError(){ 
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        /*Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        Contact WishFamilyContact = OrientationandTrainingUtil.CreateWishFamily();
        
        npe4__Relationship__c npe4RelationShip = OrientationandTrainingUtil.CreateRelationshipRec(wishChild.Id,WishFamilyContact.Id);
        
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        wish.Hidden_Email_List__c = 'MAWAFirstName MAWALastName1,MAWAFirstName MAWALastName2';
        wish.Hidden_Name_List__c = 'kesavkumar@mstsolutions.com,kanagaraj@mstsolutions.com';
        update wish;
        Wish_Child_Form__c childForm  = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        childForm.Case__c=wish.Id;
        insert childForm; 
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishLiabilityForm_VF;
        pageRef.getParameters().put('id',String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishLiabilityForm_AC wishLiabilityIns = new WishLiabilityForm_AC(sc);
        system.AssertEquals(wishChild.Id,wish.ContactId);
    }
    
    /*This method is used to cover the code coverage of multiEmail() and CallOuttoDocusign() method.*/
    public static testMethod void SendDocusigntoEmail(){ 
        
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        List<Contact> WishFamilyContactList = OrientationandTrainingUtil.CreateWishFamilyList(3);
        insert WishFamilyContactList;
        List<npe4__Relationship__c> npe4RelationShipList = OrientationandTrainingUtil.relationshipChildList(WishFamilyContactList,wishChild.Id,3);
        insert npe4RelationShipList;
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        
        Wish_Child_Form__c childForm  = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        childForm.Hidden_Email_List__c = 'MAWAFirstName MAWALastName1,MAWAFirstName MAWALastName2';
        childForm.Hidden_Name_List__c = '';
        insert childForm; 
        
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishLiabilityForm_VF;
        pageRef.getParameters().put('id',String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishLiabilityForm_AC wishLiabilityIns = new WishLiabilityForm_AC(sc);
        wishLiabilityIns.isFirstParentSendEmail = false;
        wishLiabilityIns.displayError = true;
        wishLiabilityIns.isFirstParent = false;
        wishLiabilityIns.multiEmail();
        wishLiabilityIns.cancel();
        wishLiabilityIns.ReturnToWish();
        wishLiabilityIns.ReturnToLiabilityForm();
        List<String>  emailList = new List<String>{'MAWAFirstName MAWALastName0','MAWAFirstName MAWALastName1','MAWAFirstName MAWALastName2'};
            wishLiabilityIns.emailList = emailList;
        wishLiabilityIns.sendpdftoEmail();
        wishLiabilityIns.displayError = true;
        wishLiabilityIns.SignNowdisplayError = true;
        
        Map<String,String> sendEmailMap = new Map<String,String>();
        sendEmailMap.put('MAWAFirstName MAWALastName0', 'vennila@mstsolutions.com');
        sendEmailMap.put('MAWAFirstName MAWALastName1', 'kesavkumar@mstsolutions.com');
        sendEmailMap.put('MAWAFirstName MAWALastName2', 'kanagaraj@mstsolutions.com');
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        WishLiabilityForm_AC.CallOuttoDocusign(sendEmailMap,wish.Id);
        wishLiabilityIns.redirect();
        wishLiabilityIns.SignNowdisplayError = true;
        Test.StopTest();
        system.AssertEquals(wishChild.Id,wish.ContactId);
    }
    
    /*This method is used to cover the code coverage of multiEmail() else condition.*/
    public  static testMethod void SendDocusigntoEmailError(){ 
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        List<Contact> WishFamilyContactList = OrientationandTrainingUtil.CreateWishFamilyList(3);
        insert WishFamilyContactList;
        List<npe4__Relationship__c> npe4RelationShipList = OrientationandTrainingUtil.relationshipChildList(WishFamilyContactList,wishChild.Id,3);
        insert npe4RelationShipList;
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Wish_Child_Form__c childForm  = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        childForm.Hidden_Email_List__c = 'MAWAFirstName MAWALastName1,MAWAFirstName MAWALastName2'+','+childForm.Hidden_Email_List__c;
        childForm.Hidden_Name_List__c = 'kesavkumar@mstsolutions.com,kanagaraj@mstsolutions.com'+','+childForm.Hidden_Name_List__c;
        insert childForm; 
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishLiabilityForm_VF;
        pageRef.getParameters().put('id',String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishLiabilityForm_AC wishLiabilityIns = new WishLiabilityForm_AC(sc);
        wishLiabilityIns.multiEmail();
        wishLiabilityIns.cancel();
        wishLiabilityIns.returnToLiabilityForm();
        wishLiabilityIns.returnToWish();
        wishLiabilityIns.displayMessage();
        wishLiabilityIns.displayError = true;
        wishLiabilityIns.SignNowdisplayError = true;
        Map<String,String> sendEmailMap = new Map<String,String>();
        sendEmailMap.put('MAWAFirstName MAWALastName0', 'vennila@mstsolutions.com');
        sendEmailMap.put('MAWAFirstName MAWALastName1', 'kesavkumar@mstsolutions.com');
        sendEmailMap.put('MAWAFirstName MAWALastName2', 'kanagaraj@mstsolutions.com');
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        WishLiabilityForm_AC.CallOuttoDocusign(sendEmailMap,wish.Id);
        wishLiabilityIns.redirect();
        Test.StopTest();
        system.AssertEquals(wishChild.Id,wish.ContactId);
    }
    
    /*This method is used to cover the code coverage of SubmitAndSign() method when Hidden_Liability_Envelop_Id_1__c,Hidden_Liability_Envelop_Id_2__c & Hidden_Liability_SignerMap_Key_1__c are NOT NULL .*/
    public static testMethod void SignDocusignNow1(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        List<Contact> WishFamilyContactList = OrientationandTrainingUtil.CreateWishFamilyList(3);
        insert WishFamilyContactList;
        List<npe4__Relationship__c> npe4RelationShipList = OrientationandTrainingUtil.relationshipChildList(WishFamilyContactList,wishChild.Id,3);
        insert npe4RelationShipList;
        Case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        Wish_Child_Form__c childForm  = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        childForm.Hidden_Liability_Envelop_Id_2__c = 'Test';
        childForm.Hidden_Liability_SignerMap_Key_2__c ='Test-Test#Test-Test';
        childForm.Hidden_Liability_Envelop_Id_1__c='';
        childForm.Hidden_Liability_SignerMap_Key_1__c='Test-Test#Test-Test';
        childForm.Wish_Liability_Envolep__c='Test';
        childForm.LiabilitySignerMapKeyPair__c='Test-Test#Test-Test';
        insert childForm;  
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishLiabilityForm_VF;
        pageRef.getParameters().put('id',String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishLiabilityForm_AC wishLiabilityIns = new WishLiabilityForm_AC(sc);
        wishLiabilityIns.displayError = true;
        wishLiabilityIns.SignNowdisplayError = true;
        wishLiabilityIns.displaypopwindow = false;
        wishLiabilityIns.SingerName = 'Kanagaraj Arjunan';
        wishLiabilityIns.multiEmail();
        wishLiabilityIns.cancel();
        wishLiabilityIns.ReturnToLiabilityForm();
        wishLiabilityIns.ReturnToWish();
        wishLiabilityIns.SignNowmultiEmail();
        
        Map<String,String> sendEmailMap = new Map<String,String>();
        sendEmailMap.put('MAWAFirstName MAWALastName0', 'vennila@mstsolutions.com');
        sendEmailMap.put('MAWAFirstName MAWALastName1', 'kesavkumar@mstsolutions.com');
        sendEmailMap.put('MAWAFirstName MAWALastName2', 'kanagaraj@mstsolutions.com');
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();
        wishLiabilityIns.DisplayMessage();
        wishLiabilityIns.SubmitAndSign();
        Test.StopTest();
        system.AssertEquals(wishChild.Id,wish.ContactId);
    }
    
    /*This method is used to cover the code coverage of SubmitAndSign() method when wishLiabilityIns.displaypopwindow = false .*/
    public static testMethod void SignDocusignNow4(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        List<Contact> WishFamilyContactList = OrientationandTrainingUtil.CreateWishFamilyList(3);
        insert WishFamilyContactList;
        List<npe4__Relationship__c> npe4RelationShipList = OrientationandTrainingUtil.relationshipChildList(WishFamilyContactList,wishChild.Id,3);
        insert npe4RelationShipList;
        Case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Wish_Child_Form__c childForm  = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        childForm.Hidden_Wish_Fmaily_Contact_Name__c = 'Test#Test';
        childForm.Hidden_Liability_Envelop_Id_2__c = '';
        childForm.Hidden_Liability_SignerMap_Key_2__c ='';
        childForm.Hidden_Liability_Envelop_Id_1__c='';
        childForm.Wish_Liability_Envolep__c='';
        childForm.LiabilitySignerMapKeyPair__c='';
        childForm.Hidden_Liability_SignerMap_Key_1__c='';
        insert childForm;  
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishLiabilityForm_VF;
        pageRef.getParameters().put('id',String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishLiabilityForm_AC wishLiabilityIns = new WishLiabilityForm_AC(sc);
        wishLiabilityIns.multiEmail();
        wishLiabilityIns.cancel();
        wishLiabilityIns.ReturnToLiabilityForm();
        wishLiabilityIns.ReturnToWish();
        wishLiabilityIns.SignNowmultiEmail();
        wishLiabilityIns.DisplayMessage();
        Map<String,String> sendEmailMap = new Map<String,String>();
        sendEmailMap.put('MAWAFirstName MAWALastName0', 'vennila@mstsolutions.com');
        sendEmailMap.put('MAWAFirstName MAWALastName1', 'kesavkumar@mstsolutions.com');
        sendEmailMap.put('MAWAFirstName MAWALastName2', 'kanagaraj@mstsolutions.com');
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();
        wishLiabilityIns.displaypopwindow = false;
        wishLiabilityIns.isFirstParent = true;
        wishLiabilityIns.SingerName = 'Madhumitha';
        wishLiabilityIns.Name = 'Madhumitha';
        wishLiabilityIns.SubmitAndSign();
        
        Test.StopTest();
        system.AssertEquals(wishChild.Id,wish.ContactId);
    }
     
    
 
    
}