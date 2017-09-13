@isTest
public class ClassOffering_AT_Test{
// Start Time greater than End Time.
 public static testMethod void createClassOffering(){
 
       Class_Offering__c currOffering = new Class_Offering__c();
       currOffering.Date__c = Date.Today()+3;
       currOffering.Start_Time__c = '9:30 AM';
       currOffering.end_time__c = '9:00 AM';
       Database.SaveResult result = Database.insert(currOffering,false);
       //System.assertEquals('End Time should be greater than start time',result.getErrors()[0].getMessage());
 }
 // Entered the Invalid start time.
 public static testMethod void createClassOfferingSameTime(){
 
       Class_Offering__c currOffering = new Class_Offering__c();
       currOffering.Date__c = Date.Today()+3;
       currOffering.Start_Time__c = '7:00 PM';
       currOffering.end_time__c = '10:00 AM';
       Database.SaveResult result = Database.insert(currOffering,false);
       //System.assertEquals('Please enter valid Start and End Time',result.getErrors()[0].getMessage());
 }
 // Start Time is blank.
 public static testMethod void startTimeBlank(){
 
       Class_Offering__c currOffering = new Class_Offering__c();
       currOffering.Date__c = Date.Today()+3;
       currOffering.end_time__c = '10:00 AM';
       Database.SaveResult result = Database.insert(currOffering,false);
       System.assertEquals('Please Enter Start Time',result.getErrors()[0].getMessage());
 }
 
 public static testmethod void  createClassOfferingNationalStaffasOwner(){
    Chapter_Vs_Role__c arizonaChap = OrientationandTrainingUtil.createArizonaChapter();
        Chapter_Vs_Role__c alabamaChap = OrientationandTrainingUtil.createAlabamaChapter();
        Insert alabamaChap;
        Insert arizonaChap;
        
    User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
    User nationalStaff;
    System.RunAs(currUser)
    {   
        nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id);
    }
    
    System.runAs(nationalStaff) {
         Chapter_Role__c newChapterRole = OrientationandTrainingUtil.createChapter(OrientationandTrainingUtil.createchapterAccount().Id,OrientationandTrainingUtil.createRole().Id);
         Chapter_Role_O_T__c  newChapterOT = OrientationandTrainingUtil.createChapterOandT(newChapterRole.Id,OrientationandTrainingUtil.CreateVolunteerOrientationRecord().Id);
         Class_Offering__c  newClassOff = OrientationandTrainingUtil.createClassOffering(newChapterOT.Id);
     }
 }
}