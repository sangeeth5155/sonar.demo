public class AccountTriggerHandler {
    // This method is used to update garntingcase devstaffemail field whenever cpateraccount devstaffemail filed is changed
    public static void updateGrantingCaseDevStaffEmai(map<id,string> chapterEmailmap){
        
        Constant_AC constant = new Constant_Ac();
        String wishGrantRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
        String parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        list<Case> upadteCaseList = new list<Case>();
        
        for(Case grantingCase :[SELECT ID,RecordTypeId,ParentId,Parent.ChapterName__c,Dev_Staff_Email__c FROM Case WHERE Parent.ChapterName__c IN: chapterEmailmap.keySet() AND RecordTypeId =: wishGrantRecordTypeId AND isClosed = false]){
            if(chapterEmailmap.containsKey(grantingCase.Parent.ChapterName__c)){
                grantingCase.Dev_Staff_Email__c = chapterEmailmap.get(grantingCase.Parent.ChapterName__c);
                upadteCaseList.add(grantingCase);
            }
        }
        
        if(upadteCaseList.size() > 0){
            update upadteCaseList;
        }
    }
}