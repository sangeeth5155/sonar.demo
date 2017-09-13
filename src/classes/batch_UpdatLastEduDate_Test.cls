@isTest(seeAllData=False)
public class batch_UpdatLastEduDate_Test{
    public static testMethod void createVolunteerTraing(){
       Id chapterAccountId = orientationandTrainingUtil.CreateAlabamaAccount();
       Role__c role=orientationandTrainingUtil.createRole();
       Contact volumnteerContact=orientationandTrainingUtil.createVolunteerContact(chapterAccountId);
       Chapter_Role__c chapterRole=orientationandTrainingUtil.createChapter(chapterAccountId ,role.id);
       Volunteer_Roles__c volunteerRole = orientationandTrainingUtil.createVolRole(volumnteerContact.Id,chapterRole.Id);   
       Orientation_Training__c orientationT=orientationandTrainingUtil.CreateVolunteerOrientationRecord();
       Chapter_Role_O_T__c chatpterROT=orientationandTrainingUtil.createChapterOandT(chapterRole.Id,orientationT.Id);
       Class_Offering__c classOfferinf= orientationandTrainingUtil.createClassOffering(chatpterROT.Id);
       
       Volunteer_Orientation_Training__c  createNewTraining = orientationandTrainingUtil.createVolTraining(orientationT.Id,classOfferinf.Id,volumnteerContact.Id,'completed');
       createNewTraining.Migrated_Record__c = True;
       update createNewTraining;
       
       Volunteer_Orientation_Training__c  createNewTraining2 = orientationandTrainingUtil.createVolTraining(orientationT.Id,classOfferinf.Id,volumnteerContact.Id,'completed');
       createNewTraining2.Migrated_Record__c = True;
       update createNewTraining2;
       
       Test.startTest();
          DataBase.executeBatch(new batch_UpdatLastEduDate() );
       Test.stopTest();
    }
    
    public static testMethod void createVolunteerOpportunity(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        volunteerContact.migrated_record__c = True;
        volunteerContact.Date_of_last_engagement__c = Date.Today().addDays(-10);
        update volunteerContact;
        Case parentCase = OrientationandTrainingUtil.ParentCasetoAddCaseMember(wishChild.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        
            List<Volunteer_Opportunity__c> wishVolunteerOpportunityList =OrientationandTrainingUtil.NewWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,parentCase.id,1);
         
            Volunteer_Opportunity__c updateREc = new Volunteer_Opportunity__c();
            updateRec.id = wishVolunteerOpportunityList[0].id;
            updateRec.migrated_record__c = True;
            updateRec.volunteer_Name__c = volunteerContact.id;
            update updateRec;
     
       Test.startTest();
          DataBase.executeBatch(new batch_UpdatLastEduDateforVO() );
       Test.stopTest();
    }
}