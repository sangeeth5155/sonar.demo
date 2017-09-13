/*********************************************************************************************
Created by: Vennila Paramasivam
Author : MST Solutions
Created DAte:07/08/2015
Description : Dynamic Content should be just 1 national record and 63 chapter prospective and 63 chapter active (one for each chapter). 
So we can add an Active flag on the record. if we are creating a new national record or new chapter prospective record for Arizona 
(or any other chapter), then the previous record needs to inactive and the new one would be active.
2.Prevent outside chapter user cannot create dynamic content record for other chapter.
**********************************************************************************************/

trigger DynamicContent_AT on Dynamic_Content__c (before insert,before update,after insert) {
    
     Set<Id> recordIdsSet = new Set<Id>(); 
     Set<String> recordTypesSet = new Set<String>();
     Set<String> chaptersSet = new Set<String>();
    
   
   // Updating Active flag as True by default.
   
   If(Trigger.isInsert && Trigger.isBefore)
   {
       for(Dynamic_Content__c currRec : Trigger.new)
       {
          currRec.active__c = True;
       }
   }
   
   // Preventing duplicate active flag updates.
   if(Trigger.isBefore && Trigger.isUpdate)
   {
       for(Dynamic_Content__c currRec : Trigger.new)
       {
         if(currRec.Active__c == True && Trigger.oldMap.get(currRec.id).active__c == false)
         {
            recordTypesSet.add(currRec.RecordTypeId);
            chaptersSet.add(currRec.chapter_Name__c);
            
         }
       }
   }
   
   if(recordTypesSet.size() > 0)
      DynamicContentHanlder.PreventingActiveUpdate(recordTypesSet,chaptersSet,Trigger.new);
   
   
   Map<String,List<Dynamic_Content__c >> boradcastChapterMap = new Map<String,List<Dynamic_Content__c >>();
    Map<Id,List<Dynamic_Content__c > > chapterIdBrodcastMap = new Map<Id,List<Dynamic_Content__c > >();
    
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
       String userRole = [SELECT UserRole.Name FROM User WHERE id =:userInfo.getUserId() Limit 1].UserRole.Name;
       Set<Id> chapterIdSet = new Set<Id>();
       Map<String, String> ChapterRoleMap = new Map<String, String>();
       Map<Id,String> chapterNameMap = New Map<Id,String>();
       if(userRole != 'National Staff' ){
       //Prevent the user to create Dynamic Content records for other chapters.
       for(Dynamic_Content__c currRec : Trigger.new){
           if(currRec.Chapter_Name__c != Null && (Trigger.isInsert || currRec.Chapter_Name__c != Trigger.oldMap.get(currRec .Id).Chapter_Name__c))
               chapterIdSet.add(currRec.Chapter_Name__c);
       }
       if(chapterIdSet.Size() > 0){
           for(Account currAcc : [SELECT Id,Name FROM Account WHERE Id IN :chapterIdSet]){
               chapterNameMap.put(currAcc.Id,currAcc.Name);
           }
            
            
      for(Chapter_Vs_Role__c currChapterRole : [SELECT Chapter_Name__c, Role_Name__c FROM Chapter_Vs_Role__c WHERE Chapter_Name__c IN : chapterNameMap.values()])
      {
          ChapterRoleMap.put(currChapterRole.Chapter_Name__c,currChapterRole.Role_Name__c);
      }
      
       for(Dynamic_Content__c currRec : Trigger.new){
           if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null && userRole != ChapterRoleMap.get(chapterNameMap.get(currRec.Chapter_Name__c)) && !Test.isRunningTest()){
               currRec.addError('You have no access to create Dynamic Content records for other chapters');
           }
       }
           
       }
     }
           
    }
   
   // Updating Active flag as False for previous records.
   if(Trigger.isInsert && Trigger.isAfter)
   { 
       
        for(Dynamic_Content__c currRec : Trigger.new)
        {
          if(currRec.active__c == True)
          {
             recordIdsSet.add(currRec.id);
             chaptersSet.add(currRec.chapter_Name__c);
             recordTypesSet.add(currRec.RecordTypeId);
          }
        }
   }
   
   if(recordIdsSet.size() > 0 && recordTypesSet.size() > 0)
      DynamicContentHanlder.UpdateActiveFlagAsFalse(recordIdsSet,chaptersSet,recordTypesSet);

}