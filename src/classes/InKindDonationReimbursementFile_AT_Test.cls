/*****************************************************************************************************************
Author      : MST Solutions
Date        : 10/26/2016
Description : This class contains test method for InKindDonationReimbursementFile object
*******************************************************************************************************************/
@isTest
public class InKindDonationReimbursementFile_AT_Test{
    static testmethod void createCaseFile() {
        Account voluntterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunterrContct = OrientationandTrainingUtil.createVolunteerContact(voluntterAccount.id);
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        In_Kind_Donation_Reimbursement__c  InkindRec = OrientationandTrainingUtil.CreateInkindRecord(wish.Id);
        In_Kind_Donation_Reimbursement_File__c  newFileRecord = OrientationandTrainingUtil.createInkindDonaReimbFileRecord(InkindRec.Id);
    }
}