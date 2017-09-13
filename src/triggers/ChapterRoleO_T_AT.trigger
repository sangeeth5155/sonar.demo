trigger ChapterRoleO_T_AT on Chapter_Role_O_T__c (After insert, After update) 
{
   if((Trigger.isInsert || Trigger.isUpdate) && (Trigger.isAfter))
    {
        Map<String, List<Chapter_Role_O_T__c>> chapterRoleMap = new Map<String, List<Chapter_Role_O_T__c>>();
      
        for(Chapter_Role_O_T__c currRec : [SELECT id, Chapter_Name__c,OwnerId, Owner.UserRoleId, 
                                       Owner.UserRole.Name FROM Chapter_Role_O_T__c WHERE Id IN :Trigger.newMap.keySet()])
        {
        
             if(Trigger.isInsert || (Trigger.isUpdate && currRec.OwnerId != Trigger.oldMap.get(currRec.id).OwnerId))
             {
              if(currRec.Owner.UserRole.Name == 'National Staff')
              {
                if(chapterRoleMap.containsKey(currRec.Chapter_Name__c))
                {
                    chapterRoleMap.get(currRec.Chapter_Name__c).add(currRec);
                }
                else
                    chapterRoleMap.put(currRec.Chapter_Name__c,new List<Chapter_Role_O_T__c>{currRec});
               }          
              }
         }
         
         if(chapterRoleMap.size() > 0)
            ChapterStaffRecordSharing_AC.chapterRoleOTSharing(chapterRoleMap);
     }


}