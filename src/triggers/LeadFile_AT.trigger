/*****************************************************************************************************************
Author      : MST Solutions
Date        : 10/25/2016
Description : This trigger is used to generate file path for the attachment that inserted under lead record to SDrive
*******************************************************************************************************************/
trigger LeadFile_AT on Lead_File__c (after insert,after update) {
    set<Id> leadFileIdsSet = new set<id>();
    //Used to generate file path for new Lead File record
    if(Trigger.isAfter && Trigger.isInsert) {
        AWSFilePath_AC.generateLeadFilePath(trigger.newMap.keySet());
    }
    
    
}