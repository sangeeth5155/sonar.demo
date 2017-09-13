@isTest
public class batch_VolunteerRoleUpdate_Test{
   static testmethod void testVolunteerRoleUpdate() {
       Id chapterAccountId = orientationandTrainingUtil.CreateAlabamaAccount();
       Role__c role=orientationandTrainingUtil.createRole();
       Contact volumnteerContact=orientationandTrainingUtil.createVolunteerContact(chapterAccountId);
       Chapter_Role__c chapterRole=orientationandTrainingUtil.createChapter(chapterAccountId ,role.id);
           
       Orientation_Training__c orientationT=orientationandTrainingUtil.CreateVolunteerOrientationRecord();
       Chapter_Role_O_T__c chatpterROT=orientationandTrainingUtil.createChapterOandT(chapterRole.Id,orientationT.Id);
       Class_Offering__c classOfferinf= orientationandTrainingUtil.createClassOffering(chatpterROT.Id);
       
      Volunteer_Roles__c vRole=orientationandTrainingUtil.createVolRole(volumnteerContact.Id,chapterRole.Id); 
      vRole.Migrated_Record__c = True;
      update vRole;
     
       Volunteer_Orientation_Training__c newVolunteerOreTrain= new Volunteer_Orientation_Training__c ();
       newVolunteerOreTrain.Volunteer__c=volumnteerContact.Id;
       newVolunteerOreTrain.Class_Offering__c=classOfferinf.Id;
       newVolunteerOreTrain.Volunteer_Attendance__c='Completed';
      Insert newVolunteerOreTrain;
        
       Test.StartTest();
         Database.executeBatch(new batch_VolunteerRoleUpdate(),25);
                Test.StopTest();
   } 
   
    static testmethod void testVolunteerRoleUpdate1() {
       Id chapterAccountId = orientationandTrainingUtil.CreateAlabamaAccount();
       Role__c role=orientationandTrainingUtil.createRole();
       Contact volumnteerContact=orientationandTrainingUtil.createVolunteerContact(chapterAccountId);
       Chapter_Role__c chapterRole=orientationandTrainingUtil.createChapter(chapterAccountId ,role.id);
           
       Orientation_Training__c orientationT=orientationandTrainingUtil.CreateVolunteerOrientationRecord();
       Chapter_Role_O_T__c chatpterROT=orientationandTrainingUtil.createChapterOandT(chapterRole.Id,orientationT.Id);
       Class_Offering__c classOfferinf= orientationandTrainingUtil.createClassOffering(chatpterROT.Id);
       
      Volunteer_Roles__c vRole=orientationandTrainingUtil.createVolRole(volumnteerContact.Id,chapterRole.Id); 
      vRole.Migrated_Record__c = True;
      update vRole;
     
      
        
       Test.StartTest();
         Database.executeBatch(new batch_VolunteerRoleUpdate(),25);
                Test.StopTest();
   } 
}