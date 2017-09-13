/*****************************************************************************
Author : MST Solutions
CreateDate : 14/11/2016
Description : WishChildForm_AC_Test is used to increase the code coverage for WishChildForm_AC.
******************************************************************************/
@isTest
public class WishChildForm_AC_Test{
    
    /* This CalltheConstructor Method is used to cover the codecoverage for constructor.*/
    static testMethod void CalltheConstructorMethod(){ 
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Wish_Child_Form__c wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        wishChildFormIns.Emergency_Relationship__c = 'Employee';
        wishChildFormIns.Emergency_First_Name__c = 'TestEmployee';
        wishChildFormIns.Emergency_Last_Name__c = 'TestLastEmployee';
        wishChildFormIns.Emergency_Mobilephone__c = '9600467559';
        Insert  wishChildFormIns;
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishChildForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        WishChildFormUtil util = new WishChildFormUtil();
        wishChildIns.SaveandwishFamilyExit();
        wishChildIns.SaveandwishChildExit();
        wishChildIns.exitWithOutSave();
        wishChildIns.WishInfoWithSave();
        wishChildIns.SavewithExit();
        wishChildIns.WishInfoSave();
        wishChildIns.forceDownloadPDF();
        wishChildIns.confirmSignNow();
        wishChildIns.withOutSavetoChild();
        wishChildIns.ExitwithApprovalError();
        wishChildIns.WCFNext();
        wishChildIns.WFFNext();
        wishChildIns.BackToWCF();
        wishChildIns.addFamily();
        wishChildIns.addDriver();
        wishChildIns.addParticipants();
        wishChildIns.BackToWFF();
        wishChildIns.cancelfunction();
        wishChildIns.SaveandRedirectChildForm();
        wishChildIns.SaveAndRedirectFamilyForm();
        wishChildIns.SaveAndRedirectInformationForm();
        wishChildIns.SaveFromInformationToChildForm();
        wishChildIns.DisplayApprovalProcess();
        wishChildIns.getRaceEthnicity();
        wishChildIns.getDoesParticipantReqWheelchair();
        wishChildIns.getWillYourFamilyBringWheelChair();
        wishChildIns.getWheelChairColapsable();
        wishChildIns.getwheelChairPower();
        wishChildIns.getparticipantRequireOxygan();
        wishChildIns.getparticipantHaveSpecialRestrictaion();
        wishChildIns.getparticipantHaveSpecialallergies();
        wishChildIns.getmedicationRequireRefeigeration();
        wishChildIns.getcurrentlyReceiveNursingCare();
        wishChildIns.getanyOtherMedicalSupplies();
        wishChildIns.withOutNavigate();
        wishChildIns.RetrunToWish(); 
        wishChildIns.getTempName();
        wishChildIns.getCurrentOwnWheelChairList();
        wishChildIns.getCurrentWCCollapsibleList();
        wishChildIns.getCurrentWCPowerList();
        wishChildIns.getCurrentOxygenNamesList();
        wishChildIns.getCurrrentDietaryNameList();
        wishChildIns.getCurrentOxygenNamesList();
        wishChildIns.getCurrrentDietaryNameList();
        wishChildIns.getCurrentNursingCareList();
        wishChildIns.getCurrentMedicationList();
        wishChildIns.getCurrentAllergyNamesList();
        wishChildIns.getCurrentOtherNeedsList();
        wishChildIns.WCFtoWIF();
        wishChildIns.WCFtoWFF();
        wishChildIns.WishInfotoWishChild();
        wishChildIns.WishInfotoWishFamily();
        wishChildIns.NavigatetoWishChildForm();
        wishChildIns.NavigatetoWishFamily();
        wishChildIns.cancel();
        wishChildIns.withOutSavefromWCFtoWIF();
        wishChildIns.withOutSaveWCCF();
        wishChildIns.CheckSameasParent();
        wishChildIns.WishFamilytoWishInfo();
        util.getMonths();
        wishChildIns.CancelFunction();
        util.getYear();
        util.getWishChildFields();
        util.getRelationships();
        wishChildIns.generatePDF();
        util.getStates();
        wishChildIns.submitforApproval();
        Test.startTest();
        wishChildIns.saveContact();
        Test.StopTest();
        System.AssertEquals(wish.Id,wishChildFormIns.Case__c);
    }   
    
    /* This DocusignSignNow Method is used to cover the codecoverage SubmitAndSign() when Envelop_Id__c  &  Hidden_SignerMap_Key_1__c  are NOT NULL.*/
    static testMethod void DocusignSignNow1(){ 
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Wish_Child_Form__c wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        wishChildFormIns.SignerMapKeyPair__c = 'test eerwe - 1#Gmother mother - 2';
        wishChildFormIns.Envelop_Id__c = '9c674881-53f1-4871-b5f7-a6a64f067f39';
        wishchildFormIns.Hidden_SignerMap_Key_1__c = 'test eerwe - 1#Gmother mother - 2';
        wishChildFormIns.Hidden_Envelop_Id_1__c = 'Test'; 
        Insert  wishChildFormIns;
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishChildForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        wishChildIns.SignNowmultiEmail();
        Test.StartTest();
        wishChildIns.SubmitAndSign();
        Test.StopTest();
        System.AssertEquals(wish.Id,wishChildFormIns.Case__c);
    }
    
    /* This DocusignSignNow Method is used to cover the codecoverage SubmitAndSign() when Hidden_Envelop_Id_2__c &  Hidden_SignerMap_Key_2__c  are NOT NULL.*/
    static testMethod void DocusignSignNow2(){ 
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Wish_Child_Form__c wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        wishChildFormIns.SignerMapKeyPair__c = 'test eerwe - 1#Gmother mother - 2';
        wishChildFormIns.Envelop_Id__c = '9c674881-53f1-4871-b5f7-a6a64f067f39';
        wishchildFormIns.Hidden_SignerMap_Key_2__c = 'test eerwe - 1#Gmother mother - 2';
        wishChildFormIns.Hidden_Envelop_Id_2__c = 'Test'; 
        wishchildFormIns.Hidden_SignerMap_Key_1__c = 'test eerwe - 1#Gmother mother - 2';
        Insert  wishChildFormIns;
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishChildForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        wishChildIns.SignNowmultiEmail();
        Test.StartTest();
        wishChildIns.SubmitAndSign();
        Test.StopTest();
        System.AssertEquals(wish.Id,wishChildFormIns.Case__c);
    }
    
    /* This DocusignSignNow Method is used to cover the codecoverage SubmitAndSign() when Hidden_Envelop_Id_1__c &  Hidden_SignerMap_Key_1__c are NULL.*/
    static testMethod void DocusignSignNow3(){ 
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Wish_Child_Form__c wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        wishChildFormIns.SignerMapKeyPair__c = 'test eerwe - 1#Gmother mother - 2';
        wishChildFormIns.Envelop_Id__c = '9c674881-53f1-4871-b5f7-a6a64f067f39';
        wishChildFormIns.Hidden_Envelop_Id_1__c = ''; 
        wishchildFormIns.Hidden_SignerMap_Key_1__c = '';
        Insert  wishChildFormIns;
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishChildForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        wishChildIns.SignNowmultiEmail();
        Test.StartTest();
        wishChildIns.SubmitAndSign();
        Test.StopTest();
        System.AssertEquals(wish.Id,wishChildFormIns.Case__c);
    }
    
    /* This DocusignSendEmail Method is used to cover the codecoverage sendpdftoEmail() and callouttoDocusing().*/
    static testMethod void DocusignSendEmail(){ 
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Wish_Child_Form__c wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.Id);
        wishChildFormIns.Emergency_Relationship__c = 'Employee';
        wishChildFormIns.Emergency_First_Name__c = 'TestEmployee';
        wishChildFormIns.Emergency_Last_Name__c = 'TestLastEmployee';
        wishChildFormIns.Emergency_Mobilephone__c = '9600467559';
        wishChildFormIns.Wish_Family_Contact__c = '[{"workTelephone":null,"tshirtSize":null,"Street":null,"State":null,"sameParentGuardianFlag":false,"residingWishMedical":null,"relId":null,"relationship":null,"PostalCode":null,"mobileTelephone":null,"MiddleName":null,"medicalNeeds":null,"lastName":null,"isChildParticipants":null,"homeTelephone":null,"firstName":null,"Email":null,"dob":null,"City":null}]';
        Insert  wishChildFormIns;
        wishChildFormIns.Hidden_Wish_Fmaily_Contact_Email__c = 'test eerwe-te@t.com#Gmother mother-test@gmail.com#GFather yesy-test@gmail.com';
        update wishChildFormIns;
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishChildForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        WishChildFormUtil util = new WishChildFormUtil();
        util.emailList.add('Vennila Paramasivam');
        util.emailList.add('Chandru');
        wishChildIns.sendpdftoEmail();
        wishChildIns.SameAsFamily();
        wishChildIns.RemovesameParentGuardian();
        //wishChildIns.removeDriver();
        Map<String,String> sendEmailMap = new Map<String,String>();
        sendEmailMap.put('Vennila Paramasivam','vennila@mstsolutions.com');
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        WishChildForm_AC.callouttoDocusing(sendEmailMap,wish.Id,wishChild.Id);
        Test.StopTest();
        System.AssertEquals(wish.Id,wishChildFormIns.Case__c);
    }
    
    /*This method is to  SignNowmultiEmail()*/
    static testMethod void wishChildisEmpty(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        wish.Hidden_Email_List__c = 'Chandru,Kesav,Mariyappan';
        update wish;
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishChildForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        
    }
}