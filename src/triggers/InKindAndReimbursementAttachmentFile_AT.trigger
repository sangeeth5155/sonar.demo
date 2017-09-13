/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Chandrasekar
Date        : 4/10/2016
Description : This trigger is used to update the attachment picklist value of the related inkind donation and reimbursement record
****************************************************************************************************/
trigger InKindAndReimbursementAttachmentFile_AT on In_Kind_Donation_Reimbursement_File__c (after insert,after delete) {
  /*  //After insert trigger is used to update the attchment field vale as attached once attachment added in inkindrecord
    if(trigger.isAfter && trigger.isInsert){
        set<string> inkindIdsSet = new set<string>();
        list<In_Kind_Donation_Reimbursement__c> updatedInkindList = new List<In_Kind_Donation_Reimbursement__c>();
        for(In_Kind_Donation_Reimbursement_File__c currentRec : trigger.new){
            if(currentRec.Parent__c !=Null)
                inkindIdsSet.add(currentRec.Parent__c);
        }
        if(inkindIdsSet.size() >0){
            for(In_Kind_Donation_Reimbursement__c currentInkind :[SELECT Id,Attachments__c FROm In_Kind_Donation_Reimbursement__c WHERE ID IN:inkindIdsSet]){
                currentInkind.Attachments__c = 'Yes- Attached';
                currentInkind.Is_Attached__c = True;
                updatedInkindList.add(currentInkind);
            }
            if(updatedInkindList.size()>0){
                update updatedInkindList;
            }
        }
    }*/
    /*After delete is used to once the attachment deleted from the inkind record the field is updates as Not-Available*/    
   /* if(trigger.isAfter && trigger.isDelete){
        set<string> inkindIdsSet = new set<string>();
        list<In_Kind_Donation_Reimbursement__c> updateList = new list<In_Kind_Donation_Reimbursement__c>();
        for(In_Kind_Donation_Reimbursement_File__c deleteRecord : trigger.old){
            if(deleteRecord.Parent__c != Null){
                inkindIdsSet.add(deleteRecord.Parent__c);
                system.debug('Parent Id !!!!!!!!!!!' + inkindIdsSet);
            }
        }
        
        if(inkindIdsSet.size()>0){
            Set<string> AttachmentExistParentsSet = new Set<string>();
            for(In_Kind_Donation_Reimbursement_File__c checkChild : [SELECT Id, Parent__c FROM In_Kind_Donation_Reimbursement_File__c WHERE Parent__c IN :inkindIdsSet]) {
                AttachmentExistParentsSet.add(checkChild.Parent__c);
            }
            list<string> updateIdsSet = new list<string>();
            for(String s : inkindIdsSet) {
                if(!AttachmentExistParentsSet.contains(s)) {
                    updateIdsSet.add(s);
                }            
            }
            if(updateIdsSet.size()>0){
                for(In_Kind_Donation_Reimbursement__c curRecord : [SELECT ID,Attachments__c FROM In_Kind_Donation_Reimbursement__c WHERE ID IN:updateIdsSet]){
                    curRecord.Attachments__c = 'No- Not Available';
                    curRecord.Is_Attached__c = False;
                    updateList.add(curRecord);
                }
                if(updateList.size()>0){
                    update updateList;
                }
            }
        }
    }*/
}