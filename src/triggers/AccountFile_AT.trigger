trigger AccountFile_AT on cg__AccountFile__c (After insert) {
    List<Id> accountIds = new List<Id>();
    for(cg__AccountFile__c acc: Trigger.new){
        accountIds.add(acc.Id);
    }
    AWSFilePath_AC.updateAccountFilePath(accountIds);
}