/*********************************************
Description : Test Class create ChapterStaffRecordSharing.
**********************************************/
@isTest
Public class ChapterStaffRecordSharing_ACTest
{

       @TestSetup static void createRecords()
       {
          Chapter_Vs_Role__c createRec = new Chapter_Vs_Role__c();
          createRec.Chapter_Name__c = 'Make-A-Wish Alabama';
          createRec.Role_Name__c = 'Alabama - Chapter';
          createRec.Name = 'Make-A-Wish Alabama';
          insert createRec;
       
       }

        static testmethod void createCOI()
        {
          Chapter_Vs_Role__c getRec = [select Chapter_Name__c,Role_Name__c  from Chapter_Vs_Role__c];
          Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
          Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
          Conflict_Of_Interest__c  coiRec = OrientationandTrainingUtil.createCOI(volunteerContact.Id);
        }

}