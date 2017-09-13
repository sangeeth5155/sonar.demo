@isTest
public class CaseCommentTrigger_AT_Test {
    
    public testmethod static void createCase(){
        test.startTest();
        String userId = UserInfo.getUserId();
        Constant_AC  constant = new Constant_AC();
        Id partARecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(constant.partARecordTypeId).getRecordTypeId();
        Case currnetCase = new Case();
        currnetCase.Status = 'Qualified';
        currnetCase.Origin = 'Email';
        currnetCase.MAC_Email__c = 'Test@gmail.com';
        currnetCase.RecordTypeId = partARecordTypeId;
        insert currnetCase;
        
        CaseComment newCaseComment =  new CaseComment();
        newCaseComment.ParentId = currnetCase.Id;
        newCaseComment.CommentBody = 'Test comment';
        insert newCaseComment;
        test.stopTest();
        
        
    }
    
}