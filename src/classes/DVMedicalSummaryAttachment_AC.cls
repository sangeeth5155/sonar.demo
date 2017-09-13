/*****************************************************************************************************************
Author      : MST Solutions
Date        : 01/19/2017
Description : This form is used as IFrame inside the  Diagnosis Verification form to upload medical summary attachment
*******************************************************************************************************************/
public class DVMedicalSummaryAttachment_AC  {
    
    public Id attachmentId {get; set;}
    public Attachment newAttachment {get; set;}
    public Id recId;
    public boolean isSaved{get;set;}
    public boolean isDeleted{get;set;}
    public DVMedicalSummaryAttachment_AC() {
        newAttachment = new Attachment();
        recId = ApexPages.currentPage().getParameters().get('id');
        if(ApexPages.currentPage().getParameters().get('saved') != null && ApexPages.currentPage().getParameters().get('saved') == 'true'){
            isSaved = true;
        }
        if(ApexPages.currentPage().getParameters().get('deleted') != null && ApexPages.currentPage().getParameters().get('deleted') == 'true'){
            isDeleted = true;
        }
    }	
    
    //Used to display medical summary attachment to diagnosis verification form
    public List<Lead_File__c> getAttachments() {
        List<Lead_File__c> attachmentList = [select Id, Parent__c, File_Path__c, Description__c, File_Name__c from Lead_File__c where Parent__c =: recId];
        return attachmentList;
    }
    
    //Used to save new attachment theat attached from diagnosis verification form
    public PageReference save() {
        if (newAttachment.Body!=null) {
            newAttachment.parentId = recId;
            insert newAttachment;
            newAttachment = new Attachment();
        }
        PageReference redirect = new PageReference('/apex/DVMedicalSummaryAttachment_VF?id='+recId+'&saved=true');
        redirect.setRedirect(true);
        return redirect;
    }
    
    //Used to refresh the block
    public void Refresh() {
    }
    
    //Used to delete the attachment from diagnosis verification form
    public PageReference RemoveAttachment() {
        List<Lead_File__c> attachmentToBeDeleted = [SELECT Id FROM Lead_File__c WHERE Id =: attachmentId];
        if(attachmentToBeDeleted.size() > 0) {
            try{
                delete attachmentToBeDeleted;    
            }Catch(Exception ex){
                System.debug('Exception ex'+ex.getMessage());
            }						
            
        }
        PageReference redirect = new PageReference('/apex/DVMedicalSummaryAttachment_VF?id='+recId);
        redirect.setRedirect(true);
        return redirect;
    }
}