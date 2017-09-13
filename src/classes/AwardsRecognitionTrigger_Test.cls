@isTest
public class AwardsRecognitionTrigger_Test{
   /* @testSetup
    private static void createUser(){
        User arizonaUser = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='Arizona - Chapter'].Id);
    }*/
    private static testmethod void createAwardsRecOtherChapter(){
         
        Chapter_Vs_Role__c arizonaChap = OrientationandTrainingUtil.createArizonaChapter();
        Chapter_Vs_Role__c alabamaChap = OrientationandTrainingUtil.createAlabamaChapter();
        Insert alabamaChap;
        Insert arizonaChap;
         User currUser = [SELECT id from User where id = :Userinfo.getUserId() AND isActive=True limit 1]; 
         User arizonaUser;
         System.RunAs(currUser)
         {    
              arizonaUser = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='Arizona - Chapter'].Id);
              Id profileId = [SELECT Id FROM Profile WHERE Name = 'Volunteer Staff' LIMIT 1].Id;
              arizonaUser.ProfileId = profileId;
              Update arizonaUser;
         }
        Awards_Recognition__c newAwards = new Awards_Recognition__c();
         newAwards.Chapter_Name__c = OrientationandTrainingUtil.CreateAlabamaAccount();
         Insert  newAwards;
         System.runAs(arizonaUser ) {
            newAwards.Date_Field__c=System.today();
            try{
                Update newAwards;
            }
            catch(Exception ex){
                //System.assert(ex.getMessage().contains('Insufficient previlege to update this record. Please contact system administrator.'));
            }
        }
    }
}