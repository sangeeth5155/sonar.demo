/********************************************************
Created by : Vennila Paramasivam
Created Date: 07/24/2016
Description : Unit Test for NonWishEvents_AT
***********************************************************/

@isTest
public class NonWishEvents_ATTest
{

    @TestSetup static void createWishRecord()
    {
      Non_Wish_Events__c  newWish = new Non_Wish_Events__c();
      newWish.Event_Name__c= 'Test 1';
      newWish.Event_Date__c  = Date.Today().addDays(5);
      newWish.Priority__c = '1';
      newWish.chapter__c  = TestClassUtil.createVolunteerAccount().id;
      insert newWish;
    }
    static testmethod void createPastWish()
    {
      Non_Wish_Events__c  newWish = new Non_Wish_Events__c();
      newWish.Event_Name__c= 'Test 1';
      newWish.Event_Date__c  = Date.Today().addDays(-5);
      Database.SaveResult result = Database.Insert(newWish,false);
      //System.assertEquals('Event Date should be greater than Today', result.getErrors()[0].getMessage());
    
    }
    static testmethod void UpdateEventDate()
    {
       Non_Wish_Events__c currWish = [SELECT Id, Event_Date__c FROM Non_Wish_Events__c];
       currWish.Event_Date__c  = Date.Today().addDays(-5);
       Database.SaveResult result = Database.update(currWish,false);
       //System.assertEquals('Event Date should be greater than Today', result.getErrors()[0].getMessage());
        
    }
    static testmethod void UpdatePriority()
    {
       
       Non_Wish_Events__c currWish = [SELECT Id, Event_Date__c,chapter__c FROM Non_Wish_Events__c];
      
       Non_Wish_Events__c  newWish = new Non_Wish_Events__c();
       newWish.Event_Name__c= 'Test 1';
       newWish.Event_Date__c  = Date.Today().addDays(5);
       newWish.Priority__c = '2';
       newWish.chapter__c  = currWish.chapter__c;
       insert newWish;
      
       
       currWish.Priority__c = '2';
       currWish.Event_Date__c  = Date.Today().addDays(5);
       Database.SaveResult result = Database.update(currWish,false);
       System.assertEquals('This Chapter already has event for same priority. Please select some other priority.', result.getErrors()[0].getMessage());
       
    
    }
    
    public static testmethod void createEvenetRecordasNationalStaff(){
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
            Constant_AC  constant = new Constant_Ac();    
            Id EventRecTypeId = Schema.Sobjecttype.Non_Wish_Events__c.getRecordTypeInfosByName().get(constant.events).getRecordTypeId();
            Non_Wish_Events__c newEvent = new Non_Wish_Events__c();
            newEvent.Event_Name__c = 'Send Off';
            newEvent.Event_Date__c = System.Today()+5;
            newEvent.Event_Text__c = 'Sending Wish Child';
            newEvent.RecordTypeId =  EventRecTypeId;
            newEvent.Chapter__c = OrientationandTrainingUtil.createchapterAccount().Id;
            insert newEvent;
       }
    }


}