/*************************************************************************
Author : MST Solutions
CreatedDate :  8/5/2016
Description : Unit Test for AffiliationTriggerHandler and Affiliation_AT.
**************************************************************************/
@isTest
public class Affiliation_AT_Test{
    
    //Used to create volunteer account, contact and affilation with status active for volunteer user.
    static testmethod void affiliationUpdateWithActive(){
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.id);
        Group alabamaGroup = new Group();
        alabamaGroup.Name = 'Make-A-Wish Alabama';
        alabamaGroup.DeveloperName = 'ABC';
        insert alabamaGroup;
        OrientationandTrainingUtil.CreateAffiliation(volunteerContact.Id);
        npe5__Affiliation__c volunteerAffiliation =  [SELECT Id, npe5__Status__c FROM npe5__Affiliation__c LIMIT 1];
        volunteerAffiliation.npe5__Status__c = 'Active';
        update volunteerAffiliation;
        
    }
   
    
    //Used to create volunteer account, contact and affilation with status active for volunteer user and update the volunteer status as inactive.
    static testmethod void affiliationUpdateWithInActive(){
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.id);
        Group alabamaGroup = new Group();
        alabamaGroup.Name = 'Make-A-Wish Alabama';
        alabamaGroup.DeveloperName = 'ABC';
        insert alabamaGroup;
        OrientationandTrainingUtil.CreateAffiliation(volunteerContact.Id);
        npe5__Affiliation__c volunteerAffiliation =  [SELECT Id, npe5__Status__c FROM npe5__Affiliation__c LIMIT 1];
        volunteerAffiliation.npe5__Status__c = 'InActive';
        update volunteerAffiliation;
        
    }
    
    //Assigning volunteer contact to collaboration group when user become active.
    static testmethod void affiliationCreationWithStatusNull(){
       
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.Id);
        User prospectiveVolunteer = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
        
        CollaborationGroup collabGroup = OrientationandTrainingUtil.createCollaborationGroup(volunteerAccount.Name);
        //CollaborationGroupMember groupMem = OrientationandTrainingUtil.createCollabrationGroupMember(collabGroup.Id, prospectiveVolunteer.Id);
        npe5__Affiliation__c affiliationId = OrientationandTrainingUtil.CreateAffiliationwithNullStatus(volunteerAccount.Id,volunteerContact.Id);
      
        npe5__Affiliation__c volunteerAffiliation =  [SELECT Id, npe5__Status__c FROM npe5__Affiliation__c WHERE Id =:affiliationId.Id];
        volunteerAffiliation.npe5__Status__c = 'Active';
        update volunteerAffiliation;
      
    }

    //Remove volunteer from public group when affilaition deleted.
     static testmethod void affiliationDelete(){
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.id);
        Group alabamaGroup = new Group();
        alabamaGroup.Name = 'Make-A-Wish Alabama';
        alabamaGroup.DeveloperName = 'ABC';
        insert alabamaGroup;
        OrientationandTrainingUtil.CreateAffiliation(volunteerContact.Id);
        npe5__Affiliation__c volunteerAffiliation =  [SELECT Id, npe5__Status__c FROM npe5__Affiliation__c LIMIT 1];
        volunteerAffiliation.npe5__Status__c = 'InActive';
        delete volunteerAffiliation;
        
    }
    
    static testmethod void updateConatct(){ 
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.id);
        npe5__Affiliation__c currentAffiliation = OrientationandTrainingUtil.CreateAffiliation(volunteerContact.Id);
        Map<id,npe5__Affiliation__c> affiliationMap = new Map<id,npe5__Affiliation__c>();
        Set<Id> affiliationIds = new Set<Id>();
        affiliationMap.put(currentAffiliation.npe5__Contact__c, currentAffiliation);
        affiliationIds.add(currentAffiliation.npe5__Organization__c);
        AffiliationTriggerHandler.updateContact(affiliationMap,affiliationIds);
        
    }
    
}