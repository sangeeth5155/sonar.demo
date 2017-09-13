/* ---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class ChapterRoleTrigger_Test{
   
   //Used to create a Chapter Role record for National Staff as Owner.
    private testmethod static void  createChapterRole(){
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
            Chapter_Role__c newChapRole = new Chapter_Role__c();
            newChapRole.Chapter_Name__c = OrientationandTrainingUtil.createchapterAccount().Id;
            newChapRole.Role_Name__c = OrientationandTrainingUtil.createRole().Id;
            newChapRole.OwnerId= nationalStaff.Id;
            insert newChapRole;
            System.assertEquals('National Staff',[SELECT UserRole.Name FROM User WHERE Id =:nationalStaff.Id].userRole.Name);
            System.assertEquals(nationalStaff.Id,[SELECT OwnerId FROM Chapter_Role__c WHERE Id =:newChapRole.Id].OwnerId);
             
          
         }
    }   
}