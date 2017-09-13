trigger BackgroundCheckFile_AT on Background_Check_File__c (After insert) {
    List<Id> bcIds = new List<Id>();
    for(Background_Check_File__c bc: Trigger.new){
        bcIds.add(bc.Id);
    }
    AWSFilePath_AC.UpdateBackgroundCheckFilePath(bcIds);
}