/****************************************************************************
Description : This controller used to upload the wish child photo to the 
attachment and get public site image url from S-drive then update the contact
filed.
*****************************************************************************/
public without sharing class AttachmentUploadController {
    public Id recId{get;set;}
    public string name;
    public boolean onComplete{get;set;}
    public list<Contact> contactList{get;set;}
    public boolean refreshPage{get;set;}
    public String imgUrl{get;set;}
    public AttachmentUploadController(ApexPages.StandardController controller) {
        onComplete  =   false;
        refreshPage = false;
        recId = ApexPages.currentPage().getParameters().get('id');
        contactList = new List<Contact>();
        contactList = [SELECT ID,Wish_Child_Photo__c FROM Contact WHERE ID =: recId];
        system.debug('@@@@@@@@@@ contactList' + contactList);
    }
    
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
 //This method used to upload the image to the attachment   
    public void upload() {     
        if(attachment.Body != null && attachment.Name != null) {
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = recId ; // the record the file is attached to
            insert attachment;
            name = attachment.Name;
            onComplete  =   True;
            attachment = new Attachment();
        }
        
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose a file to upload'));
        }
    }
 //This method used to get the image url from S-drive and update the contact's wish child photo filed   
    public pagereference updateWishChildPhoto(){
        onComplete  =   False;
        list<cg__ContactFile__c> newCon = new list<cg__ContactFile__c >();
        newCon = [select id,cg__Contact__c,cg__File_Name__c,File_Path__c from cg__ContactFile__c where cg__File_Name__c =: name and cg__Contact__c =: recId limit 1];
        Contact currentCon = new Contact();
        currentCon.id = recId;
        imgUrl   =   '';
        if(newCon.size() > 0){
            imgUrl  =   newCon[0].File_Path__c;
            currentCon.Wish_Child_Photo__c = '<img alt="User-added image" src="'+imgUrl+'"></img>';
            update currentCon; 
        }
                system.debug('###### currentCon.Wish_Child_Photo__c' + currentCon.Wish_Child_Photo__c);   
        refreshPage = true;
        return null;      
    }    
}