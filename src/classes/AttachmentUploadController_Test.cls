/***********************************************************************************************
Description : This test class used to cover the unit testing of the attachmentuploadcontroller 
************************************************************************************************/
@isTest
public class AttachmentUploadController_Test {
    public static testmethod void insertAttachment(){
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Attachment newAttachment = new Attachment();
        newAttachment.Name = 'test';
        newAttachment.Body = blob.valueOf('Hi Welcome to body text');
        newAttachment.ParentId = wishChild.id;
        insert newAttachment;
           
        ApexPages.StandardController sc = new ApexPages.StandardController(wishChild);
        AttachmentUploadController attchUpload = new AttachmentUploadController(sc);
        PageReference pageRef = Page.WishChildPhoto_VF;
        Test.setCurrentPage(pageRef);
        
        attchUpload.upload();
        attchUpload.updateWishChildPhoto();
        
    }
    
}