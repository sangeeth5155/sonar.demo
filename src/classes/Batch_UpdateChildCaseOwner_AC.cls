/*This class is used to update the owner of the child cases*/
global class Batch_UpdateChildCaseOwner_AC implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Constant_AC  constant = new Constant_Ac();
        Id parentWishRT = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        return Database.getQueryLocator([SELECT Id, OwnerId FROM Case WHERE RecordTypeId =: parentWishRT]);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> parentCase) {
        
        Map<Id, Id> parentCaseOwnerMap = new Map<Id, Id>();
        for(Case parentCaseOwner : parentCase) {
            parentCaseOwnerMap.put(parentCaseOwner.Id, parentCaseOwner.OwnerId);
        }
        
        List<Case> caseOwnerUpdateList = new List<Case>();
        for(Case childCase : [SELECT Id, ParentId, OwnerId FROM Case WHERE ParentId IN : parentCaseOwnerMap.keySet()]) {
            if(parentCaseOwnerMap.containsKey(childCase.ParentId) && childCase.OwnerId != parentCaseOwnerMap.get(childCase.ParentId)) {
                childCase.OwnerId = parentCaseOwnerMap.get(childCase.ParentId);
                caseOwnerUpdateList.add(childCase);
            }
        }
        if(caseOwnerUpdateList.size() > 0) {
            update caseOwnerUpdateList;
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}