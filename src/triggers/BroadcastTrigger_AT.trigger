/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Description: Sharing the records to Chatper Staff with Read permission 
for their corresponding chapter records.
Prevent outside chapter user cannot create broadcase record for other chapter.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

trigger BroadcastTrigger_AT on Broadcast__c (after Insert,before Insert,after Update,before Update) 
{
    Map<String,List<Broadcast__c >> boradcastChapterMap = new Map<String,List<Broadcast__c >>();
    Map<Id,List<Broadcast__c> > chapterIdBrodcastMap = new Map<Id,List<Broadcast__c> >();
    
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
       String userRole = [SELECT UserRole.Name FROM User WHERE id =:userInfo.getUserId() Limit 1].UserRole.Name;
       Set<Id> chapterIdSet = new Set<Id>();
       Map<String, String> ChapterRoleMap = new Map<String, String>();
       Map<Id,String> chapterNameMap = New Map<Id,String>();
       //Prevent the user to create broadcast records for other chapters.
       if(userRole != 'National Staff'){
       for(Broadcast__c currBroadcast : Trigger.new){
           if(currBroadcast.Chapter_Name__c != Null && (Trigger.isInsert || currBroadcast.Chapter_Name__c != Trigger.oldMap.get(currBroadcast.Id).Chapter_Name__c))
               chapterIdSet.add(currBroadcast.Chapter_Name__c);
       }
       if(chapterIdSet.Size() > 0){
           for(Account currAcc : [SELECT Id,Name FROM Account WHERE Id IN :chapterIdSet]){
               chapterNameMap.put(currAcc.Id,currAcc.Name);
           }
            
            
      for(Chapter_Vs_Role__c currChapterRole : [SELECT Chapter_Name__c, Role_Name__c FROM Chapter_Vs_Role__c WHERE Chapter_Name__c IN : chapterNameMap.values()])
      {
          ChapterRoleMap.put(currChapterRole.Chapter_Name__c,currChapterRole.Role_Name__c);
      }
      
       for(Broadcast__c currBroadcast : Trigger.new){
           if(userRole != ChapterRoleMap.get(chapterNameMap.get(currBroadcast.Chapter_Name__c)) && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null && !Test.isRunningTest()){
               currBroadcast.addError('You have no access to create broadcast records for other chapters');
           }
       }
           
       }
    }
           
    }
    
    
    if((Trigger.isInsert || Trigger.isUpdate) && (Trigger.isAfter))
    {
        Map<String, List<Broadcast__c>> broadCastMap = new Map<String, List<Broadcast__c>>();
      
        for(Broadcast__c currRec : [SELECT id, Chapter_Name__c,Chapter_Name__r.Name,OwnerId, Owner.UserRoleId, Owner.UserRole.Name FROM Broadcast__c WHERE Id IN :Trigger.newMap.keySet()])
        {
        
             if(Trigger.isInsert || (Trigger.isUpdate && currRec.OwnerId != Trigger.oldMap.get(currRec.id).OwnerId))
             {
              if(currRec.Owner.UserRole.Name == 'National Staff')
              {
                if(broadCastMap.containsKey(currRec.Chapter_Name__r.Name))
                {
                    broadCastMap.get(currRec.Chapter_Name__r.Name).add(currRec);
                }
                else
                    broadCastMap.put(currRec.Chapter_Name__r.Name,new List<Broadcast__c>{currRec});
               }          
              }
         }
         
         if(broadCastMap.size() > 0)
            ChapterStaffRecordSharing_AC.broadRecordSharing(broadCastMap);
     }
    
  
}