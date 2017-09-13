/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Chandrasekar
Date        : 4/10/2016
Description : This class is used to make sure the unit test and functionality for the InKindDonationReimbursement_AT
****************************************************************************************************/
@isTest
public class InKindReimbursementApproval_AC_Test {
    //This method used to create a inkind type record for inkinddonorobject
    static testMethod void callInkindApprovalMethods(){
        In_Kind_Donation_Reimbursement__c inKind = OrientationandTrainingUtil.CreateInkindRecord();
        InKindReimbursementApproval.submitApproval(inKind.id);
    }
    
     static testMethod void callInkindApprovalWithoutAttachment(){
        In_Kind_Donation_Reimbursement__c inKind = OrientationandTrainingUtil.CreateInkindRecordWithOutAttachment();
        InKindReimbursementApproval.submitApproval(inKind.id);
    }
    
    //This method used to create a reimbursement type record for inkinddonorobject
    static testMethod void callReimbursementApprovalMethods(){
        In_Kind_Donation_Reimbursement__c reimbursement = OrientationandTrainingUtil.CreateReimbursRecord();
        InKindReimbursementApproval.submitReimbursementApproval(reimbursement.id);
    }
    
    static testMethod void callReimbursementApprovalWithoutAttachment(){
        In_Kind_Donation_Reimbursement__c reimbursement = OrientationandTrainingUtil.CreateReimbursRecordWithOutAttachment();
        InKindReimbursementApproval.submitReimbursementApproval(reimbursement.id);
    }
}