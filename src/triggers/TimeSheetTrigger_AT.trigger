/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 5/23/2016
Description : This TimeSheetTrigger_AT is used to calculate the total hours spent by volunteers to close the wish and 
              Non-wish & Event.
*******************************************************************************************************************/
Trigger TimeSheetTrigger_AT on Time_sheet__c (before insert,before update, After insert,After update,After delete) {
    List<Time_sheet__c> timeSheetList = new List<Time_sheet__c>();
    Set<Id> timeSheetIds = new Set<Id>();
    
    if(Trigger.isBefore && Trigger.isInsert)
    {   
        Set<Id> volunteerIdSet = new Set<Id>();
        
       
        
        for(Time_sheet__c  newTimeSheetEntry : Trigger.new)
        {
         if(newTimeSheetEntry.Volunteer_Opportunity__c != Null)
             volunteerIdSet.Add(newTimeSheetEntry.Volunteer_Opportunity__c);
         if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
          {
            if(newTimeSheetEntry.Hours_spent__c > 0){
                timeSheetList.add(newTimeSheetEntry);
            }
            
          }
        }
        
        if(volunteerIdSet.Size() > 0){
              TimeSheetTriggerHandler.shareVolunteerOpportunity(volunteerIdSet);
           
      }
            
             
        
        if(timeSheetList.size () > 0){
            TimeSheetTriggerHandler timesheetIns = new TimeSheetTriggerHandler();
            timesheetIns.SplitBefore(timeSheetList);
        }
    }
    if(Trigger.isBefore && Trigger.isupdate){
        for(Time_sheet__c  newTimeSheetEntry : Trigger.new){
           if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
           {
            if((newTimeSheetEntry.Hours_spent__c) >0 && (newTimeSheetEntry.Hours_spent__c != trigger.oldmap.get(newTimeSheetEntry.id).Hours_spent__c)){
                timeSheetList.add(newTimeSheetEntry);
            }
           }
        }
        if(timeSheetList.size () > 0){
            TimeSheetTriggerHandler timesheetIns = new TimeSheetTriggerHandler();
            timesheetIns.SplitBefore(timeSheetList);
        }
    }
    if(Trigger.isAfter && Trigger.isInsert){
     
        for(Time_sheet__c  newTimeSheetEntry : Trigger.new){
         if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
          {
            if(newTimeSheetEntry.Hours_spent__c > 0){
                timeSheetList.add(newTimeSheetEntry);
            }
            
            if(newTimeSheetEntry.Date__c != Null)
            {
               timeSheetIds.add(newTimeSheetEntry.id);
            }
          }
        }
        if(timeSheetList.size () > 0){
            TimeSheetTriggerHandler timesheetIns = new TimeSheetTriggerHandler();
            timesheetIns.calculateHourstoWish(timeSheetList);
            timesheetIns.calculateHourstoNonWish(timeSheetList);
        }
    }
    if(Trigger.isAfter && Trigger.isUpdate){
      
        for(Time_sheet__c  newTimeSheetEntry : Trigger.new){
        if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
         {
            if(newTimeSheetEntry.Hours_Hidden__c!= trigger.oldmap.get(newTimeSheetEntry.Id).Hours_Hidden__c){
                timeSheetList.add(newTimeSheetEntry);
                
            }
            if(newTimeSheetEntry.Date__c != Trigger.oldMap.get(newTimeSheetEntry.id).Date__c && newTimeSheetEntry.Date__c != Null)
               timeSheetIds.add(newTimeSheetEntry.id);
          }
        }
        if(timeSheetList.size () > 0){
            TimeSheetTriggerHandler timesheetIns = new TimeSheetTriggerHandler();
            timesheetIns.calculateHourstoWish(timeSheetList);
            timesheetIns.calculateHourstoNonWish(timeSheetList);
        }
    }
    
    if(timeSheetIds.size() > 0)
    {
        TimeSheetTriggerHandler.findRecentTimeSheetDate(timeSheetIds);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        Set<Id> VolunteerOpportunitiesIdSet = new Set<Id>();
        //TimeSheetTriggerHandler.findRecentTimeSheetDate(Trigger.oldMap);
        for(Time_sheet__c  newTimeSheetEntry : Trigger.old){
            VolunteerOpportunitiesIdSet.add(newTimeSheetEntry.Volunteer_Opportunity__c);
            timeSheetList.add(newTimeSheetEntry);
        }
        if(timeSheetList.size () > 0){
            TimeSheetTriggerHandler timesheetIns = new TimeSheetTriggerHandler();
            timesheetIns.calculateHourstoWish(timeSheetList);
            timesheetIns.calculateHourstoNonWish(timeSheetList);
        }
        
        if(VolunteerOpportunitiesIdSet.size() > 0) {
        //    TimeSheetTriggerHandler.findRecentTimeSheetDate1(VolunteerOpportunitiesIdSet);
        }
    }
}