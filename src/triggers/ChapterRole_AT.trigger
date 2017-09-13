trigger ChapterRole_AT on Chapter_Role__c (before insert,before update,after insert, after Update) 
{
    
    if(Trigger.isBefore)
    {
        Set<Id> roleIdSet = new Set<Id>();
        Map<Id,Role__c> roleMap = new Map<Id,Role__c>();
            
            for(Chapter_Role__c newChapterRole : trigger.new)
            {
                
                if(newChapterRole.Role_Name__c != Null){
                    roleIdSet.add(newChapterRole.Role_Name__c);
                }
            }
            
            if(roleIdSet.size() > 0)
            {
                
                for(Role__c dbRole : [SELECT Id,Name FROM Role__c WHERE Id IN: roleIdSet]){
                    roleMap.put(dbRole.Id,dbRole);
                }
                
                for(Chapter_Role__c newChapterRole : trigger.new){
                   if(roleMap.containsKey(newChapterRole.Role_Name__c)){
                       newChapterRole.Role__c = roleMap.get(newChapterRole.Role_Name__c).Name;
                   }
                }
            }
    
     }
     
     
     
    if((Trigger.isInsert || Trigger.isUpdate) && (Trigger.isAfter))
    {
        Map<String, List<Chapter_Role__c>> chapterRoleMap = new Map<String, List<Chapter_Role__c>>();
      
        for(Chapter_Role__c currRec : [SELECT id, Chapter_Name__c,Chapter_Name__r.Name,OwnerId, Owner.UserRoleId, 
                                       Owner.UserRole.Name FROM Chapter_Role__c WHERE Id IN :Trigger.newMap.keySet()])
        {
        
             if(Trigger.isInsert || (Trigger.isUpdate && currRec.OwnerId != Trigger.oldMap.get(currRec.id).OwnerId))
             {
              if(currRec.Owner.UserRole.Name == 'National Staff')
              {
                if(chapterRoleMap.containsKey(currRec.Chapter_Name__r.Name))
                {
                    chapterRoleMap.get(currRec.Chapter_Name__r.Name).add(currRec);
                }
                else
                    chapterRoleMap.put(currRec.Chapter_Name__r.Name,new List<Chapter_Role__c>{currRec});
               }          
              }
         }
         
         if(chapterRoleMap.size() > 0)
            ChapterStaffRecordSharing_AC.chapterRoleSharing(chapterRoleMap);
     }
    
}