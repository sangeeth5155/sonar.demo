/*****************************************************************************************************************
Author      : MST Solutions
Date        : 01/19/2017
Description : This form is used as IFrame inside the  Diagnosis Verification form to upload medical summary attachment
*******************************************************************************************************************/
public class wifAttachment_AC{
    
    public Id attachmentId {get; set;}
    public Attachment newAttachment {get; set;}
    public Id recId;
    public boolean isSaved{get;set;}
    public boolean isDeleted{get;set;}
    
    public wifAttachment_AC() {
        newAttachment = new Attachment();
        recId = ApexPages.currentPage().getParameters().get('id');
        System.debug('+++++++++++++++++recId '+ recId );
        if(ApexPages.currentPage().getParameters().get('saved') != null && ApexPages.currentPage().getParameters().get('saved') == 'true'){
            isSaved = true;
        }
        if(ApexPages.currentPage().getParameters().get('deleted') != null && ApexPages.currentPage().getParameters().get('deleted') == 'true'){
            isDeleted = true;
        }
    }   
    
    //Used to display medical summary attachment to diagnosis verification form
    public List<cg__CaseFile__c> getAttachments() {
        set<Id> folderIdSet = new Set<Id>();
        for(cg__CaseFile__c caseFileFolders: [select Id from cg__CaseFile__c where cg__Case__c =: recId and cg__Content_Type__c = 'Folder' AND (cg__File_Name__c = 'Staff - Private' OR cg__File_Name__c = 'Financials')]){
            folderIdSet.add(caseFileFolders.Id);
        }
        System.debug('+++++++++++++++++folderId'+ folderIdSet + '-RecId' + recId );
        List<cg__CaseFile__c> attachmentList = [select Id, cg__Case__c, File_Path__c, cg__Description__c, cg__File_Name__c from cg__CaseFile__c where cg__Case__c =: recId and cg__Content_Type__c != 'Folder' and cg__Parent_Folder_Id__c NOT IN: folderIdSet];
        return attachmentList;
    }
    
    //Used to save new attachment theat attached from diagnosis verification form
    public PageReference save() {
        if (newAttachment.Body!=null) {
            System.debug('+++++++++++++++++recId2 '+ recId );
            newAttachment.parentId = recId;
            insert newAttachment;
            newAttachment = new Attachment();
        }
        PageReference redirect = new PageReference('/apex/wifAttachment_VF?id='+recId+'&saved=true');
        redirect.setRedirect(true);
        return redirect;
    }
    
    //Used to refresh the block
    public void Refresh() {
    }
    
    //Used to delete the attachment from diagnosis verification form
    public PageReference RemoveAttachment() {
        List<cg__CaseFile__c> attachmentToBeDeleted = [SELECT Id FROM cg__CaseFile__c WHERE Id =: attachmentId];
        if(attachmentToBeDeleted.size() > 0) {
            try{
                delete attachmentToBeDeleted;    
            }Catch(Exception ex){
                System.debug('Exception ex'+ex.getMessage());
            }                       
            
        }
        PageReference redirect = new PageReference('/apex/wifAttachment_VF?id='+recId);
        redirect.setRedirect(true);
        return redirect;
    }
}