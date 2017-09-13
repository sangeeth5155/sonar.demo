trigger CaseFile_AT on cg__CaseFile__c (before insert,after insert) {
    
    if(Trigger.isInsert && Trigger.isBefore) {
        Map<Id, cg__CaseFile__c > newFileMap = new Map<Id, cg__CaseFile__c >();
        Map<Id, Id> caseFileMap = new Map<Id, Id>();
        //Map<Id, String> caseNameMap = new Map<Id, String>();
        Set<Id> caseId = new Set<Id>();
        Map<Id, List<cg__CaseFile__c>> cfFolderNames = new Map<Id, List<cg__CaseFile__c>>();
        Set<Id> FolderIds = new Set<Id>();
        Map<Id,cg__CaseFile__c> FolderIdsMap = new Map<id,cg__CaseFile__c>();
        
        for(cg__CaseFile__c cseFile : Trigger.new) {
            newFileMap.put(cseFile.Id, cseFile);
            caseId.add(cseFile.cg__Case__c);
        }
        
        if(caseId.size() > 0) {
            for(cg__CaseFile__c caseFile : [SELECT Id, cg__Content_Type__c, cg__File_Name__c, cg__Case__c, cg__Case__r.CaseNumber, cg__Parent_Folder_Id__c FROM cg__CaseFile__c WHERE cg__Case__c IN : caseId AND cg__Content_Type__c = 'Folder']) {
                if(caseFile.cg__File_Name__c == 'Documents'){
                    caseFileMap.put(caseFile.cg__Case__c, caseFile.Id);
                }
                //caseNameMap.put(caseFile.cg__Case__c, caseFile.cg__Case__r.CaseNumber);
                FolderIdsMap.put(caseFile.Id, caseFile);
            } 
            for(cg__CaseFile__c cseFile1 : Trigger.new) {
                if(FolderIdsMap.containsKey(cseFile1.cg__Parent_Folder_Id__c)){
                    cseFile1.Parent_Folder_Name__c = FolderIdsMap.get(cseFile1.cg__Parent_Folder_Id__c).cg__File_Name__c;
                }
            }
            if(caseFileMap.size() > 0) {
                List<cg__CaseFile__c> updateCaswFileList = new List<cg__CaseFile__c>();
                for(cg__CaseFile__c newCaseFile : newFileMap.values()) {
                    if(caseFileMap.containsKey(newCaseFile.cg__Case__c)) {
                        if(newCaseFile.cg__Content_Type__c != 'Folder') {
                            newCaseFile.cg__Parent_Folder_Id__c = caseFileMap.get(newCaseFile.cg__Case__c);
                            updateCaswFileList.add(newCaseFile);
                        }
                    }
                }
            }
        }
        
       
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        List<Id> CaseIds = new List<Id>();
        Set<Id> caseIdsSet = new Set<Id>();
        Set<Id> ParentIdsSet = new Set<Id>();
        List<cg__CaseFile__c> caseFileList = new List<cg__CaseFile__c>();
        
        
        for(cg__CaseFile__c cf: Trigger.new){
            CaseIds.add(cf.Id);
            if(cf.cg__Content_Type__c.contains('image') || cf.cg__Content_Type__c.contains('video')){
                caseIdsSet.add(cf.cg__Case__c);
                caseFileList.add(cf);
            }
            
        }
        
        if(CaseIds.size() > 0) {
            AWSFilePath_AC.UpdateCaseFilePath(CaseIds);
        }
        if(caseFileList.size() > 0) {
            String jsontaskListString = json.serialize(caseFileList);
            AWSFilePath_AC.createAttachmentReviewTask(jsontaskListString, caseIdsSet);
        }
    }
}