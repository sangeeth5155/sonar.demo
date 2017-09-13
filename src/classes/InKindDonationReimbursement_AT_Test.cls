/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Chandrasekar
Date        : 4/10/2016
Description : This class is used to make sure the unit test and functionality for the InKindDonationReimbursement_AT
****************************************************************************************************/
@isTest
public class InKindDonationReimbursement_AT_Test {
    
    @testSetup static void methodName() {
        User systemAdminUser = OrientationandTrainingUtil.createrSystemAdminUser();
        user currentUserRec = new User();
        currentUserRec.Id = UserInfo.getUserId();
        currentUserRec.ManagerId = systemAdminUser.Id;
        update currentUserRec;
    }
    //this method used to create the inkind record
    static testMethod void InsertInkindRecord(){
        Account voluntterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunterrContct = OrientationandTrainingUtil.createVolunteerContact(voluntterAccount.id);
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        In_Kind_Donation_Reimbursement__c  InkindRec = OrientationandTrainingUtil.CreateInkindRecord(wish.Id);
        User dbUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterrContct.id);
        system.RunAs(dbUser){
            Test.StartTest();
            OrientationandTrainingUtil.CreateReimbursRecord();
            Test.StopTest();
        }
    }
    
    //This method is used to update the inkind record  
    static testMethod void updateInkindRecord(){
        Account voluntterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunterrContct = OrientationandTrainingUtil.createVolunteerContact(voluntterAccount.id);
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        In_Kind_Donation_Reimbursement__c  InkindRec = OrientationandTrainingUtil.CreateInkindRecord(wish.Id);
        User dbUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterrContct.id);
        system.RunAs(dbUser){
            Test.StartTest();
            In_Kind_Donation_Reimbursement__c dbInKindRec = OrientationandTrainingUtil.CreateReimbursRecordwithFalse();
            //dbInKindRec.Make_check_payable_to_me__c = true;
            update dbInKindRec ;
            Test.StopTest();
        }
    }
    
    static testMethod void updateInkindRecordWithCase(){
        Account voluntterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunterrContct = OrientationandTrainingUtil.createVolunteerContact(voluntterAccount.id);
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        In_Kind_Donation_Reimbursement__c  InkindRec = OrientationandTrainingUtil.CreateInkindRecord();
        InkindRec.Wish__c = wish.id;
        update InkindRec;
        User dbUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterrContct.id);
        system.RunAs(dbUser){
            Test.StartTest();
            In_Kind_Donation_Reimbursement__c dbInKindRec = OrientationandTrainingUtil.CreateReimbursRecordwithFalse();
            //dbInKindRec.Make_check_payable_to_me__c = true;
            update dbInKindRec ;
            Test.StopTest();
        }
    }
    
    static testMethod void createInkindRecforNationalStaff(){
        Chapter_Vs_Role__c arizonaChap = OrientationandTrainingUtil.createArizonaChapter();
        Chapter_Vs_Role__c alabamaChap = OrientationandTrainingUtil.createAlabamaChapter();
        Insert alabamaChap;
        Insert arizonaChap;
        
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        User nationalStaff;
        System.RunAs(currUser)
        {   
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id);
        }
        
        System.runAs(nationalStaff) {
            Test.startTest();
            Account voluntterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact volunterrContct = OrientationandTrainingUtil.createVolunteerContact(voluntterAccount.id);
            Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
            Case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
            In_Kind_Donation_Reimbursement__c  InkindRec = OrientationandTrainingUtil.CreateInkindRecord(wish.Id);
            Test.stopTest();
        }
        
    }
    
}