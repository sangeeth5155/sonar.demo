trigger PopulateRoleName on Chapter_Role__c (before insert,before update) {
    
    if(Trigger.isBefore){
    Set<Id> roleIdSet = new Set<Id>();
    Map<Id,Role__c> roleMap = new Map<Id,Role__c>();
        for(Chapter_Role__c newChapterRole : trigger.new){
            
            if(newChapterRole.Role_Name__c != Null){
                roleIdSet.add(newChapterRole.Role_Name__c);
            }
        }
        
        if(roleIdSet.size() > 0){
            
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
}