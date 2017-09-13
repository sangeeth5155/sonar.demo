@isTest(seeAllData=False)
public class batch_UpdatAffiliationStatus_Test{
    //Used to create volunteer account, contact and affilation with status active for volunteer user.
    static testmethod void affiliationUpdateWithActive(){
        String CRON_EXP = '0 0 1 * * ? *';
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.id);
        volunteerContact.Migrated_Record__c = True;
        update volunteerContact;
       
        
        Group alabamaGroup = new Group();
        alabamaGroup.Name = 'Make-A-Wish Alabama';
        alabamaGroup.DeveloperName = 'ABC';
        insert alabamaGroup;
        
        Background_check__c createBackCheck = OrientationandTrainingUtil.createBackgroundCheckFasleRec(volunteerContact.id);
        Conflict_Of_Interest__c createCOI = OrientationandTrainingUtil.createCOI(volunteerContact.id);
        
        npe5__Affiliation__c neworgAffiliation = new npe5__Affiliation__c ();
        neworgAffiliation.npe5__Contact__c  = volunteerContact.id;
        neworgAffiliation.npe5__Organization__c = TestClassUtil.createVolunteerAccount().Id;
        neworgAffiliation.npe5__Primary__c = true;
        neworgAffiliation.npe5__Status__c = 'Prospective';
        neworgAffiliation.Constituent_code__c = 'Volunteer';
        neworgAffiliation.Hidden_Status_Updated__c = false;
        //newOrgAffiliation.Migrated_Record__c = True;
        insert neworgAffiliation;
       
        
       
        Test.startTest();
          
            Database.executeBatch(new batch_UpdatAffiliationStatus());
        Test.stopTest();       
    }
}