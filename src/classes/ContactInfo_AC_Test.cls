@isTest
public class ContactInfo_AC_Test{
    
    private static testmethod void testContactInfo(){
    Constant_AC  constant = new Constant_AC();
     Id updateContactRT = Schema.SobjectType.Task.getRecordTypeInfosByName().get(constant.updateContactRT).getRecordTypeId();
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        Task openTask = new Task(Subject = 'Test Task', activityDate = system.today(), whoId = con.Id, recordTypeId = updateContactRT );
        insert openTask;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(openTask);
        ContactInfo_AC contactInfo = new ContactInfo_AC(sc);
    }

}