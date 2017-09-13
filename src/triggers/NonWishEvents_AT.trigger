/****************************************************************************************
Created by : vennila paramasivam
Author : MST Solutions
Date : 6/29/2016
Description : If user tried to create events with same chapter, date and priority, It won't allow 
users to create an event.
*****************************************************************************************/

trigger NonWishEvents_AT on Non_Wish_Events__c (before insert,before update) {
    
    Set<Id> chapterIds = new Set<Id>();
    Set<String> prioritysSet = new Set<String>();
    List<Non_Wish_Events__c> existingEvents = new List<Non_Wish_Events__c>();
    Set<String> chapterPrioritySet = new Set<String>();
    Set<String> eventDate = new Set<String>();
    
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            for(Non_Wish_Events__c currRec : Trigger.new)
            {
                chapterIds.add(currRec.chapter__c);
                prioritysSet.add(currRec.Priority__c);
                
                if(currRec.Event_Date__c < Date.Today() && !Test.isRunningTest() && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
                {
                    currRec.addError('Event Date should be greater than Today');
                }
                
            }
        }
        
        if(Trigger.isUpdate)
        {
            for(Non_Wish_Events__c currRec : Trigger.new)
            {
                if(currRec.chapter__c != Null)
                {
                    chapterIds.add(currRec.chapter__c);
                }
                if(currRec.Priority__c!= Trigger.oldMap.get(currRec.id).Priority__c)
                    prioritysSet.add(currRec.Priority__c);
                
                if(currRec.Event_Date__c != Trigger.oldMap.get(currRec.id).event_date__c  && currRec.Event_Date__c < Date.Today() && !Test.isRunningTest() && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
                {
                    currRec.addError('Event Date should be greater than Today');
                }
            }
            
        }
        
        if(chapterIds.size() > 0 && prioritysSet.size() > 0)
        {
            
            for(Non_Wish_Events__c currRec :[SELECT id, Chapter__c, Priority__c,event_date__c,RecordtypeId FROM Non_Wish_Events__c WHERE chapter__c IN :chapterIds AND Priority__c = :prioritysSet AND event_date__c  > : Date.Today()])
            {
                if(currRec.Priority__c != Null)
                {
                    chapterPrioritySet.add(currRec.Chapter__c+'-'+currRec.Priority__c);
                }
            }
            system.debug('@@@@@@ chapterPrioritySet'+chapterPrioritySet);
        }
        
        for(Non_Wish_Events__c  currRec : Trigger.new)
        {
            system.debug('@@@@@@Currnt Non wish event' + currRec.RecordType.Name+'-'+currRec.Chapter__c+'-'+currRec.Priority__c);
            if(currRec.Priority__c != Null)
            {
                if(chapterPrioritySet.contains(currRec.Chapter__c+'-'+currRec.Priority__c) && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
                {
                    currRec.addError('This Chapter already has event for same priority. Please select some other priority.'); 
                }
            }
        }
    }
    
}