/*Contains unit test for Batch_UpdateChildCaseOwner_AC class */
@isTest
public class Batch_UpdateChildCaseOwner_AC_Test {
    
    Static testmethod void CreateCase() {
        Constant_AC  constant = new Constant_Ac();    
        Id wishDeterminationRT = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        parentCase.Start_Date__c = System.today();
        parentCase.Status = 'Qualified';
        insert parentCase;
        Case childCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        childCase.RecordTypeId = wishDeterminationRT;
        childCase.ParentId = parentCase.Id;
        insert childCase;
        Test.startTest();
        Batch_UpdateChildCaseOwner_AC executeCls = new Batch_UpdateChildCaseOwner_AC();
        Database.executeBatch(executeCls);
        Test.stopTest();
    }
}