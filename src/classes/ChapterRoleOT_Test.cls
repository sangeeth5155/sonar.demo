@isTest
Public class ChapterRoleOT_Test{
    //Create a chapterroleO&T record owner as National staff
    private static testmethod void createChapterRoleOT(){
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
            Chapter_Role__c newChapterRole =OrientationandTrainingUtil.createChapter(OrientationandTrainingUtil.createchapterAccount().Id,OrientationandTrainingUtil.createRole().Id);
            OrientationandTrainingUtil.createChapterOandT(newChapterRole.Id,OrientationandTrainingUtil.CreateVolunteerOrientationRecord().Id);
            
        }
    }
}