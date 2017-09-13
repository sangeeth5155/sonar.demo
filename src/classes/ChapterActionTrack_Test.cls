/************************************************************************************
Created Date :  8/8/2016
Author : Mst Solutions
Description : Unit Test for Chapter_Action_Track__c and ChapterActionTrackHandler
*************************************************************************************/
@isTest
public class ChapterActionTrack_Test {
  /*  
    //Used to create chapter and chapter action record
    @testSetup static void setup(){  
        Account newchapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Chapter_Action_Track__c newAction = OrientationandTrainingUtil.createChapterActionTrack();
        newAction.Chapter_Name__c = newchapterAccount.Id;
        newAction.Sort_Order__c = 1;
        insert newAction;
    }
    
    // Used to test validation if recurring frequency set to null
    @isTest static void updateChapterAction(){ 
        Chapter_Action_Track__c chapterAction =  [SELECT Id, Wish_type__c, Sort_Order__c, Recurring_Frequency__c, Recurring__c, Due_Date__c, Chapter_Name__c, Case_Type_Stage__c FROM Chapter_Action_Track__c];
        chapterAction.Sort_Order__c = 3;
        chapterAction.Recurring__c = true;
        chapterAction.Recurring_Frequency__c = null;
        chapterAction.Wish_type__c = 'Disney';
        chapterAction.Case_Type_Stage__c = 'Wish Planning & Anticipation';
        Database.saveResult result = Database.update(chapterAction,false);
        System.assertEquals('Recurring Frequency cannot be blank for Recurring Task',result.getErrors()[0].getMessage());
      
    }
    
    // Used to test validation if sort order set to null
    @isTest static void sortOrderAsNull(){ 
        Chapter_Action_Track__c chapterAction =  [SELECT Id, Wish_type__c, Sort_Order__c, Recurring_Frequency__c, Recurring__c, Due_Date__c, Chapter_Name__c, Case_Type_Stage__c FROM Chapter_Action_Track__c];
        chapterAction.Recurring__c = true;
        chapterAction.Sort_Order__c = null;
        chapterAction.Recurring_Frequency__c = 10;
        chapterAction.Wish_type__c = 'Disney';
        chapterAction.Case_Type_Stage__c = 'Wish Planning & Anticipation';
        Database.saveResult result = Database.update(chapterAction,false);
        System.assertEquals('Please Enter Sort Order',result.getErrors()[0].getMessage());
    }
    
    // Used to test validation if sort order set to zero
    @isTest static void sortOrderSizeCheck(){ 
        Chapter_Action_Track__c chapterAction =  [SELECT Id, Wish_type__c, Sort_Order__c, Recurring_Frequency__c, Recurring__c, Due_Date__c, Chapter_Name__c, Case_Type_Stage__c FROM Chapter_Action_Track__c];
        chapterAction.Recurring__c = true;
        chapterAction.Sort_Order__c = 0;
        chapterAction.Recurring_Frequency__c = 10;
        chapterAction.Wish_type__c = 'Disney';
        chapterAction.Case_Type_Stage__c = 'Wish Planning & Anticipation';
        Database.saveResult result = Database.update(chapterAction,false);
        System.assertEquals('Please Enter Sort Order greater than 0',result.getErrors()[0].getMessage());
        
    }
    
    // Used to test validation if wish stage set to null
    @isTest static void wishStageCheck(){ 
        Chapter_Action_Track__c chapterAction =  [SELECT Id, Wish_type__c, Sort_Order__c, Recurring_Frequency__c, Recurring__c, Due_Date__c, Chapter_Name__c, Case_Type_Stage__c FROM Chapter_Action_Track__c];
        chapterAction.Recurring__c = true;
        chapterAction.Sort_Order__c = 0;
        chapterAction.Recurring_Frequency__c = 10;
        chapterAction.Wish_type__c = 'Disney';
        chapterAction.Case_Type_Stage__c = null;
        Database.saveResult result = Database.update(chapterAction,false);
        System.assertEquals('Please Choose Wish Stage',result.getErrors()[0].getMessage());
    }
    
    // Used to test validation if role set to null
    @isTest static void roleNullCheck(){ 
        Chapter_Action_Track__c chapterAction =  [SELECT Id, Wish_type__c, Sort_Order__c, Recurring_Frequency__c, Recurring__c, Due_Date__c, Chapter_Name__c, Case_Type_Stage__c FROM Chapter_Action_Track__c];
        chapterAction.Recurring__c = true;
        chapterAction.Sort_Order__c = 0;
        chapterAction.Recurring_Frequency__c = 10;
        chapterAction.Wish_type__c = 'Disney';
        chapterAction.Case_Type_Stage__c = 'Wish Planning & Anticipation';
        chapterAction.Assigned_To__c=null;
        Database.saveResult result = Database.update(chapterAction,false);
        System.assertEquals('Please Choose Role',result.getErrors()[0].getMessage());
    }
    
    // Used to test duplicate record creation
    @isTest static void dupCheck(){ 
        Account chapterAccount = [SELECT Id FROM Account LIMIT 1];
        Chapter_Action_Track__c newAction = OrientationandTrainingUtil.createChapterActionTrack();
        newAction.Chapter_Name__c = chapterAccount.Id;
        newAction.Sort_Order__c = 2;
        insert newAction;
        Chapter_Action_Track__c updateSortOrder = [SELECT Id, Sort_Order__c FROM Chapter_Action_Track__c WHERE Sort_Order__c = 2 LIMIT 1];
        updateSortOrder.Sort_Order__c = 1;
        Database.SaveResult result = Database.update(updateSortOrder,false);
        System.assertEquals('Duplicate Exists',result.getErrors()[0].getMessage());
    }
    
    */
    
    
    //Used to create a user with Arizona Chapter Role.
    @testsetup
    private static void createUser(){
        User arizonaUser = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='Arizona - Chapter'].Id);
    }
    
    //Used to Create a Chapter Action Track record with Alabama chapter.
   static testmethod void  createCATOtherChapter(){           
        Account newchapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Chapter_Action_Track__c newAction = OrientationandTrainingUtil.createChapterActionTrack();
        newAction.Chapter_Name__c = newchapterAccount.Id;
        newAction.Sort_Order__c = 1;
        
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
               insert newAction;  
            }
            catch(Exception ex){
               //System.assert(ex.getmessage().contains('You have no access to create broadcast records for other chapters')); 
            }
        }
        
    }
    //Update a user role as the National staff.
     static testmethod void updateUser(){
        User nationalStaff = [SELECT Id,UserRole.Name FROM USER WHERE UserRole.Name='Arizona - Chapter' AND isActive = true LIMIT 1];        
         nationalStaff.UserRoleId=[select Id from UserRole where Name='National Staff'].Id;
         Update nationalStaff;
          system.assertEquals([SELECT UserRole.Name FROM User WHERE Id =:nationalStaff.Id].UserRole.Name,'National Staff');
          
     }
     
     //Used to create a Chapter Action Track record with owner as a National staff role.
     static testmethod void createCATNationalstaff(){
        
        Chapter_Vs_Role__c arizonaChap = OrientationandTrainingUtil.createArizonaChapter();
        Chapter_Vs_Role__c alabamaChap = OrientationandTrainingUtil.createAlabamaChapter();
        Insert alabamaChap;
        Insert arizonaChap;
         
        Account newchapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Chapter_Action_Track__c newAction = OrientationandTrainingUtil.createChapterActionTrack();
        newAction.Chapter_Name__c = newchapterAccount.Id;
        newAction.Sort_Order__c = 1;
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1]; 
         User nationalStaff;
         System.RunAs(currUser)
         {     
             nationalStaff = [SELECT Id,UserRole.Name FROM USER WHERE UserRole.Name='Arizona - Chapter' AND isActive = true LIMIT 1];        
             nationalStaff.UserRoleId=[select Id from UserRole where Name='National Staff'].Id;
             Update nationalStaff;
         }
                 
        System.runAs(nationalStaff) {
           newAction.OwnerId=nationalStaff.id;
           Insert newAction;
          
           
        }
         
    }
}