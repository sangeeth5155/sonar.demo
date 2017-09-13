/****************************************
Created by : Vennila Paramasivam
Created Date : 07/24/2016.
Author : Mst Solutions.
Description : Unit Test for DynamicContent_AT Trigger.
****************************************/

@isTest
Public class DynamicContent_ATTest
{
    static testmethod void createDynamicContent()
    {
      Dynamic_Content__c dynamicContent1 = TestClassUtil.createDynamicContent();
      Dynamic_Content__c dynamicContent2 = TestClassUtil.createDynamicContent();
      
      dynamicContent1.Active__c = True;
      Database.SaveResult result = Database.Update(dynamicContent1,false);
      System.assertEquals('Active National Record already exist', result.getErrors()[0].getMessage());
    
    }
    static testmethod void createProspectDynamicContent()
    {
     
      Dynamic_Content__c dynamicContent1 = TestClassUtil.createProspectiveDynamicContent();
      Dynamic_Content__c dynamicContent2 = dynamicContent1.clone();
      insert dynamicContent2;
      dynamicContent1.Active__c = True;
      Database.SaveResult result = Database.Update(dynamicContent1,false);
      System.assertEquals('Active record already exist for this chapter and record type', result.getErrors()[0].getMessage());
    
    }
    //Create a user with Arizona Role.
    @testSetup
    private static void createUser(){
        User arizonaUser = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='Arizona - Chapter'].Id);
    }
    //Create a DynamicContent record with other chapter.
    static testmethod void createOtherChapterDynamicContent(){
    
        Chapter_Vs_Role__c newCR = new Chapter_Vs_Role__c();
        newCR.Chapter_Name__c='Make-A-Wish Arizona';
        newCR.Role_Name__c='Arizona - Chapter'; 
        newCR.Name='Make-A-Wish Arizona';       
        Insert newCR;
        
        Chapter_Vs_Role__c alabamaCR = new Chapter_Vs_Role__c();
        alabamaCR.Chapter_Name__c='Make-A-Wish Alabama';
        alabamaCR.Role_Name__c='Alabama - Chapter'; 
        alabamaCR.Name='Make-A-Wish Alabama';       
        Insert alabamaCR;
                
        User arizonaUser=[SELECT Id FROM USER WHERE UserRole.Name='Arizona - Chapter' AND isActive = true LIMIT 1];
        System.runAs(arizonaUser) {
            try{
               Dynamic_Content__c dynamicContent1 = OrientationandTrainingUtil.ChapterDynamicContent(OrientationandTrainingUtil.createchapterAccount().Id);
            }
            catch(Exception ex){
               System.assert(ex.getmessage().contains('You have no access to create broadcast records for other chapters')); 
            }
        }
        
        
    }

}