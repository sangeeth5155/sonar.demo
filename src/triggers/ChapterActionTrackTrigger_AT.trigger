/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Description: Prevent outside chapter user cannot create chapter action track record for other chapter.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

trigger ChapterActionTrackTrigger_AT on Chapter_Action_Track__c (after Insert,before Insert,after Update,before Update) {
    Map<String,List<Chapter_Action_Track__c >> boradcastChapterMap = new Map<String,List<Chapter_Action_Track__c >>();
    Map<Id,List<Chapter_Action_Track__c > > chapterIdBrodcastMap = new Map<Id,List<Chapter_Action_Track__c > >();
    
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
       String userRole = [SELECT UserRole.Name FROM User WHERE id =:userInfo.getUserId() Limit 1].UserRole.Name;
       Set<Id> chapterIdSet = new Set<Id>();
       Map<String, String> ChapterRoleMap = new Map<String, String>();
       Map<Id,String> chapterNameMap = New Map<Id,String>();
       //Prevent the user to create Chapter Action Track records for other chapters.
       if(userRole != 'National Staff'){
           for(Chapter_Action_Track__c currRec : Trigger.new){
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
          
           for(Chapter_Action_Track__c currRec : Trigger.new){
               if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null && userRole != ChapterRoleMap.get(chapterNameMap.get(currRec.Chapter_Name__c)) && !Test.isRunningTest()){
                   currRec.addError('You have no access to create Chapter Action Track records for other chapters');
               }
           }
               
           }
       }
           
    }
  
    if((Trigger.isInsert || Trigger.isUpdate) && (Trigger.isAfter))
    {
        Map<String, List<Chapter_Action_Track__c>> chapterActionMap = new Map<String, List<Chapter_Action_Track__c>>();
      
        for(Chapter_Action_Track__c currRec : [SELECT id, Chapter_Name__c,Chapter_Name__r.Name,OwnerId, Owner.UserRoleId, Owner.UserRole.Name FROM Chapter_Action_Track__c WHERE Id IN :Trigger.newMap.keySet()])
        {
        
             if(Trigger.isInsert || (Trigger.isUpdate && currRec.OwnerId != Trigger.oldMap.get(currRec.id).OwnerId))
             {
              if(currRec.Owner.UserRole.Name == 'National Staff')
              {
                if(chapterActionMap.containsKey(currRec.Chapter_Name__r.Name))
                {
                    chapterActionMap.get(currRec.Chapter_Name__r.Name).add(currRec);
                }
                else
                    chapterActionMap.put(currRec.Chapter_Name__r.Name,new List<Chapter_Action_Track__c>{currRec});
               }          
              }
         }
         
         if(chapterActionMap.size() > 0)
            ChapterStaffRecordSharing_AC.chapterActionTrackSharing(chapterActionMap);
     }
    
  
  
}