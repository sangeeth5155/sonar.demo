public class RelationshipTriggerHandler{
    
    Set<id> relationshipIdSet = new Set<id>();
    List<Case> updateCaseList = new List<Case>();
    Constant_AC  constant = new Constant_Ac();
    String parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
    public void updateApprovedCase(set<Id> wishChildIdSet){
        
        if(wishChildIdSet.size() > 0){
            
            for(Case dbCase : [SELECT Id,ContactId,RecordTypeId,Update_Wish_Child_Form_Info__c FROM Case WHERE ContactId IN: wishChildIdSet AND Update_Wish_Child_Form_Info__c =: True
                                AND RecordTypeId =: parentWishRecordTypeId ]){
                If(wishChildIdSet.contains(dbCase.ContactId)){
                    
                    dbCase.Update_Wish_Child_Form_Info__c  = false;
                    updateCaseList.add(dbCase);
                }
            }
        }
        If(updateCaseList.size() > 0)
        update updateCaseList;
    }
}