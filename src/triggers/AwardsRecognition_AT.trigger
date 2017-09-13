/*******************************************************************************
Author      : MST Solutions
Description : Sharing Records to Inside Chapter Staff.
*********************************************************************************/

trigger AwardsRecognition_AT on Awards_Recognition__c (after insert,after update) 
{
  
/*   Map<String, List<Awards_Recognition__c>> awardsRegMap = new Map<String, List<Awards_Recognition__c>>();
    
   for(Awards_Recognition__c currRec :[SELECT id, ownerId, owner.UserRoleId, Owner.UserRole.Name, Chapter_Name__c, 
                                       Chapter_Name__r.Name FROM Awards_Recognition__c WHERE Id IN :Trigger.newMap.keySet()])
   {
     if(currRec.Chapter_Name__c != Null && currRec.Owner.userRole.Name == 'National Staff') 
         {
                if(awardsRegMap.containsKey(currRec.Chapter_Name__r.Name))
                   awardsRegMap.get(currRec.Chapter_Name__r.Name).add(currRec);
                else
                   awardsRegMap.put(currRec.Chapter_Name__r.Name, new List<Awards_Recognition__c>{currRec});
         }
   } 
   
   if(awardsRegMap.size() > 0)
           ChapterStaffRecordSharing_AC.awardsRegRecordSharing(awardsRegMap);
    */

       List<User> currUser = [SELECT id,UserRole.Name,Profile.Name FROM User WHERE id = :userInfo.getUserId() limit 1];  
        set<String> chapterNamesSet = new Set<String>();
        Map<Id,String> chapterNameMap = new Map<Id,String>();
        Map<String,String> chapterRoleMap = new Map<String,String>();
        
        for(Awards_Recognition__c  currRec : [SELECT id, ownerId, owner.UserRoleId, Owner.UserRole.Name, Chapter_Name__c, 
                                       Chapter_Name__r.Name FROM Awards_Recognition__c WHERE Id IN :Trigger.newMap.keySet()]){
            if(currRec.Chapter_Name__c != Null){
                chapterNamesSet.add(currRec.Chapter_Name__r.Name);
                chapterNameMap.put(currRec.Id,currRec.Chapter_Name__r.Name);
            }
        }
        
        if(chapterNamesSet.Size() > 0){
            chapterRoleMap=ChapterStaffRecordSharing_AC.FindChapterRole(chapterNamesSet);
        
            for(Awards_Recognition__c  currRec :Trigger.New){ 
                system.debug('Chapter Name****************'+chapterNameMap.get(currRec.Id));
                if(currUser[0].UserRole.Name != 'National Staff' && currUser[0].profile.Name != 'System Administrator' && currUser[0].profile.Name != 'Integration'){
                    if(chapterRoleMap.get(chapterNameMap.get(currRec.Id)) != currUser[0].UserRole.Name || currRec.Chapter_Name__C != Trigger.oldMap.get(currRec.Id).Chapter_Name__C){
                   {
                         currRec.addError('Insufficient previlege to update this record. Please contact system administrator.');        
                   }
                }  
                   
               }
            }
       } 
   }