/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 5/23/2016
Description : This TimeSheetTrigger_AT_Test is used to calculate the total hours spent by volunteer to close the wish and 
Non-wish & Event.
*******************************************************************************************************************/
@isTest
public class TimeSheetTrigger_AT_Test {
       
       /*Create Wish volunteer Opportunity time sheet*/
      public testmethod static void InsertWishTimeSheet(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Contact volunteerConOne = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> updateWishVolOppList = new List<Volunteer_Opportunity__c>();
        List<Volunteer_Opportunity__c> wishVolunteerOpportunityList =OrientationandTrainingUtil.NewWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,parentCase.id,2);
        wishVolunteerOpportunityList[0].Volunteer_Name__c = volunteerCon.Id;
        wishVolunteerOpportunityList[1].Volunteer_Name__c = volunteerConOne.Id;
        update wishVolunteerOpportunityList;
        OrientationandTrainingUtil.crateWishTimeSheet(updateWishVolOppList);
        OrientationandTrainingUtil.crateWishTimeSheet(updateWishVolOppList);
        List<Time_sheet__c> updateTimeSheetList = new List<Time_sheet__c>();
        List<Time_sheet__c> timeSheetList = [SELECT Id,Volunteer_Opportunity__c,Volunteer_Opportunity__r.Wish__c,Hours_spent__c  FROM Time_sheet__c WHERE Volunteer_Opportunity__r.Wish__c =: parentCase.Id];
        for(Time_sheet__c processTimeSheetRec : timeSheetList){
            Time_sheet__c  updateSheet = new Time_sheet__c ();
            updateSheet.Id = processTimeSheetRec.id;
            updateSheet.Hours_spent__c = 10.30;
            updateTimeSheetList.add(updateSheet);
        }
        
        update updateTimeSheetList;
        
        delete updateTimeSheetList;
      }
      
      /*Create Non Wish Volunteer Opportunity time sheet*/
       public testmethod static void InsertNonWishTimeSheet(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Non_Wish_Events__c nonWishEventId = OrientationandTrainingUtil.CreateEvent(chapterAccount.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> nonWishVolunteerOpportunityList =OrientationandTrainingUtil.NewnonWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,nonWishEventId.id,1);
        nonWishVolunteerOpportunityList[0].Volunteer_Name__c = volunteerCon.Id;
        update nonWishVolunteerOpportunityList;
        OrientationandTrainingUtil.crateNonWishTimeSheet(nonWishVolunteerOpportunityList,1);
        OrientationandTrainingUtil.crateNonWishTimeSheet(nonWishVolunteerOpportunityList,1);
       
        List<Time_sheet__c> updateTimeSheetList = new List<Time_sheet__c>();
        List<Time_sheet__c> timeSheetList = [SELECT Id,Volunteer_Opportunity__c,Volunteer_Opportunity__r.Non_Wish_Event__c,Hours_spent__c  FROM Time_sheet__c WHERE Volunteer_Opportunity__r.Wish__c =: nonWishEventId.Id];
        for(Time_sheet__c processTimeSheetRec : timeSheetList){
            Time_sheet__c  updateSheet = new Time_sheet__c ();
            updateSheet.Id = processTimeSheetRec.id;
            updateSheet.Hours_spent__c = 10.30;
            updateTimeSheetList.add(updateSheet);
        }
        
        update updateTimeSheetList;
        
        delete updateTimeSheetList;
      }
    public testmethod static void updateNonWishTimeSheet(){
          Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Non_Wish_Events__c nonWishEventId = OrientationandTrainingUtil.CreateEvent(chapterAccount.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> nonWishVolunteerOpportunityList =OrientationandTrainingUtil.NewnonWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,nonWishEventId.id,1);
        //Time_sheet__c newTimeSheet = OrientationandTrainingUtil.updateWishTimeSheet(nonWishVolunteerOpportunityList[0].Id);
        //newTimeSheet.Hours_spent__c = 11.50;
        //update newTimeSheet;
        //set<id>timeSheetIdsSet = new set<id>();
        //timeSheetIdsSet.add(newTimeSheet.id);
        //TimeSheetTriggerHandler.findRecentTimeSheetDate(timeSheetIdsSet);
    }
    
    public testmethod static void deleteNonWishTimeSheet(){
          Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Non_Wish_Events__c nonWishEventId = OrientationandTrainingUtil.CreateEvent(chapterAccount.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> nonWishVolunteerOpportunityList =OrientationandTrainingUtil.NewnonWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,nonWishEventId.id,1);
        //Time_sheet__c newTimeSheet = OrientationandTrainingUtil.updateWishTimeSheet(nonWishVolunteerOpportunityList[0].Id);
        //delete newTimeSheet;
    }
    
     
   }