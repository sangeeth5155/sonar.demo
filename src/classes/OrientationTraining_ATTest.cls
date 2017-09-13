/**************************************************************
CreatedBy: Vennila Paramasivam
CreatedDate : 06/27/2016
Author : MST Solutions
Description : This test class written for OrientationTraining_AT trigger.
**************************************************************/
@isTest(seeAllData = false)
Public Class OrientationTraining_ATTest
{

  /* Enter a end time greater than start time **/
   Static testmethod void createOrientation()
   {
       Orientation_Training__c currRec = new Orientation_Training__c();
       currRec.Name = 'Test 1';
       currRec.Start_Time__c = '1:00:PM';
       currRec.end_Time__c = '12:30:PM';
       Database.SaveResult result = Database.insert(currRec, false);
       //System.assertEquals('End Time should be greater than start time',result.getErrors()[0].getMessage());
       
   }
   
   /* Enter a valid start and End Time */
   Static testmethod void createValidOrientation()
   {
       Orientation_Training__c currRec = new Orientation_Training__c();
       currRec.Name = 'Test 2';
       currRec.Start_Time__c = '1:00:PM';
       currRec.end_Time__c = '1:30:PM';
       Database.SaveResult result = Database.insert(currRec, false);
       if (result.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully inserted Orientation. Orientation ID: ' + result.getId());
      }

       
   }
   /* Enter a invalid start and End Time */
   Static testmethod void createInValidOrientation()
   {
       Orientation_Training__c currRec = new Orientation_Training__c();
       currRec.Name = 'Test 3';
       currRec.Start_Time__c = '7:00:PM';
       currRec.end_Time__c = '1:30:PM';
       Database.SaveResult result = Database.insert(currRec, false);
       //System.assertEquals('Please enter valid Start and End Time',result.getErrors()[0].getMessage());
       
   }

}