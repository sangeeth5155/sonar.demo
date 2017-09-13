public class ContactInfo_AC
{
    public Contact con{get;set;}
    public Task tskIns;
    public ContactInfo_AC(ApexPages.StandardController controller){
    
        tskIns = (Task)controller.getRecord();
        Constant_AC  constant = new Constant_AC();
        Id updateContactRT = Schema.SobjectType.Task.getRecordTypeInfosByName().get(constant.updateContactRT).getRecordTypeId();
        Task tsk = [SELECT Id,WhoId,RecordTypeId FROM Task WHERE RecordTypeId =: updateContactRT AND Id =: tskIns.Id];
        con = [SELECT Id,Old_Update_Contact_Values__c  FROM Contact WHERE Id =: tsk.WhoId ];
        
    }
}