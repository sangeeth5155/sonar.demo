/*--*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Chandrasekar Nallusamy
Date        : 7/18/2016
Description : This test class used for unit test and code coverage
*******************************************************************************************************************/
@isTest
public class VolunteerRole_AT_Test{
    
    // Update Volunteer Role.
    static testmethod void createRecords()
    {
        
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        Role__c currRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
        Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
        currVolRole.Status__c = 'Pending Training';
        update currVolRole;
        
        
        
    }
// Update volunteer role status as Out of Compliance and Trained   
    static testmethod void updateVolunteerROle()
    {
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        Role__c currRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
        Volunteer_Opportunity__c newVlOpp = new Volunteer_Opportunity__c();
        newVlOpp.Chapter_Name__c = acc.id;
        newVlOpp.Chapter_Role_Opportunity__c = currChapRole.id;
        newVlOpp.Volunteer_Name__c = con.id;
        insert newVlOpp;
        Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
        Volunteer_Roles__c newVolunteerRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
        currVolRole.Status__c = 'Out of Compliance';
        update currVolRole;
        newVolunteerRole.Status__c = 'Out of Compliance';
        currVolRole.Status__c = 'Trained';
         update currVolRole;
        update newVolunteerRole;
    }
}