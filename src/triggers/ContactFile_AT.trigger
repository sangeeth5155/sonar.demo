trigger ContactFile_AT on cg__ContactFile__c (before insert, After insert) { 
    
    if(Trigger.isInsert && Trigger.isBefore) {
        Map<Id, cg__ContactFile__c> newFileMap = new Map<Id, cg__ContactFile__c>();
        Map<Id, Id> contactFileMap = new Map<Id, Id>();
        Map<Id, String> contactNameMap = new Map<Id, String>();
        Set<Id> conId = new Set<Id>();
        Map<Id,cg__ContactFile__c > FolderIdsMap = new Map<id,cg__ContactFile__c>();
        for(cg__ContactFile__c conFile : Trigger.new) {
            newFileMap.put(conFile.Id, conFile);
            conId.add(conFile.cg__Contact__c);
        }
        
        if(conId.size() > 0) {
            for(cg__ContactFile__c contactFile : [SELECT Id, cg__Content_Type__c, cg__File_Name__c, cg__Contact__c, cg__Contact__r.Name, cg__Parent_Folder_Id__c FROM cg__ContactFile__c WHERE cg__Contact__c IN : conId AND cg__Content_Type__c = 'Folder']) {
                if(contactFile.cg__File_Name__c == 'Documents'){
                    contactFileMap.put(contactFile.cg__Contact__c, contactFile.Id);
                    //contactNameMap.put(contactFile.cg__Contact__c, contactFile.cg__Contact__r.Name);
                }
                FolderIdsMap.put(contactFile.Id, contactFile);
            }
            for(cg__ContactFile__c conFile1 : Trigger.new) {
                if(FolderIdsMap.containsKey(conFile1.cg__Parent_Folder_Id__c)){
                    conFile1.Parent_Folder_Name__c = FolderIdsMap.get(conFile1.cg__Parent_Folder_Id__c).cg__File_Name__c;
                }
            } 
            if(contactFileMap.size() > 0) {
                List<cg__ContactFile__c> updateContactFileList = new List<cg__ContactFile__c>();
                for(cg__ContactFile__c newConFile : newFileMap.values()) {
                    if(contactFileMap.containsKey(newConFile.cg__Contact__c)) {
                        if(newConFile.cg__Content_Type__c != 'Folder') {
                            newConFile.cg__Parent_Folder_Id__c = contactFileMap.get(newConFile.cg__Contact__c);
                            updateContactFileList.add(newConFile);
                        }
                    }
                }
            }
        }
    }
    if(Trigger.isAfter && Trigger.isInsert) {
        List<Id> contactIds = new List<Id>();
        for(cg__ContactFile__c con: Trigger.new){
            contactIds.add(con.Id);
        }
        if(contactIds.size() >0) {
            AWSFilePath_AC.updateContactFilePath(contactIds);
        }
    }
}