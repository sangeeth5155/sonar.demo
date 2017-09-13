/***************************************************************************************************
Author      : MST Solutions
Date        : 4/10/2016
Description : This trigger is used to update the Documentation picklist value of the related inkind donation and reimbursement record
****************************************************************************************************/
trigger InKindDonationReimbursementFile_AT on In_Kind_Donation_Reimbursement_File__c (After insert, After delete) {
    if(trigger.isAfter && trigger.isInsert){
        List<Id> drIds = new List<Id>();
        set<string> inkindIdsSet = new set<string>();
        list<In_Kind_Donation_Reimbursement__c> updatedInkindList = new List<In_Kind_Donation_Reimbursement__c>();
        for(In_Kind_Donation_Reimbursement_File__c dr: Trigger.new){
            drIds.add(dr.Id);
            if(dr.Parent__c !=Null)
                inkindIdsSet.add(dr.Parent__c);
        }
        AWSFilePath_AC.UpdateInKindDonReimburFilePath(drIds);
        if(inkindIdsSet.size() >0){
            for(In_Kind_Donation_Reimbursement__c currentInkind :[SELECT Id,Documentation__c FROm In_Kind_Donation_Reimbursement__c WHERE ID IN:inkindIdsSet]){
                currentInkind.Documentation__c = 'Attached';
                updatedInkindList.add(currentInkind);
            }
            if(updatedInkindList.size()>0){
                update updatedInkindList;
            }
        }
    }
    
    /*After delete is used to once the attachment deleted from the inkind record the field is updates as Not-Available*/    
    if(trigger.isAfter && trigger.isDelete){
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
                for(In_Kind_Donation_Reimbursement__c curRecord : [SELECT ID,Documentation__c FROM In_Kind_Donation_Reimbursement__c WHERE ID IN:updateIdsSet]){
                    curRecord.Documentation__c = 'Not Available';
                    updateList.add(curRecord);
                }
                if(updateList.size()>0){
                    update updateList;
                }
            }
        }
    }
}