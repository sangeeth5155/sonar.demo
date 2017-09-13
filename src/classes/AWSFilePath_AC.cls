/*****************************************************************************************************************
Author      : MST Solutions
Date        : 10/4/2016
Description : This class is used to generate file path for the attachment that stored in SDrive for object
*******************************************************************************************************************/
public without sharing class AWSFilePath_AC{
    
    @future
    public static void UpdateAccountFilePath(List<Id> fileRecordIds){
        
        List<String> accountFilePaths;
        List<Id> fileParentIds=new List<Id>();
        List<Map<String,String>> requestParametersList = new  List<Map<String,String>>();
        
        List<cg__AccountFile__c> accountFiles = [Select Id, cg__Account__c, cg__File_Name__c, File_Path__c from cg__AccountFile__c where cg__AccountFile__c.cg__Content_Type__c !='Folder' and  cg__AccountFile__c.Id in: fileRecordIds];
        
        if(accountFiles.size() > 0){
            for(cg__AccountFile__c dbAccountFileRec : accountFiles){
                fileParentIds.add(dbAccountFileRec.cg__Account__c);
                requestParametersList.add(new Map<String,String>{'response-content-disposition'=>'attachment;filename=' + dbAccountFileRec.cg__File_Name__c});
            }
        }
        
        if(!Test.isRunningTest())
            //Used to get the file path of the attachment stored in Amazon
            accountFilePaths = cg.SDriveTools.getAttachmentURLs(fileParentIds, fileRecordIds, (365 * 24 * 60 * 60), requestParametersList);
        else
            accountFilePaths = new List<String>{'https://s3-us-west-2.amazonaws.com/mawafilesfullcopy/00Q5B000001s3bt/a1U5B0000000Df1UAE/MedicalSummaryReport.txt?response-content-disposition=attachment&filename=MedicalSummaryReport.txt&AWSAccessKeyId=AKIAIEYUJRAAMNE7W7NA&Expires=1509032442&Signature=Yx0UX2ADZxo9GbbDFH+q7opBzwU='};
                
                
                
                
                System.debug('accountFilePaths>>>>'+accountFilePaths);
        system.debug('S drive File Paths 1 : '+ accountFilePaths);
        
        for( cg__AccountFile__c accountFileRec : accountFiles){
            for(String str : accountFilePaths){
                if(str.contains(accountFileRec.Id)){
                    accountFileRec.File_Path__c=str;
                }
            }
        }
        system.debug('S drive File Paths 2 : '+ accountFiles);
        update accountFiles;
        system.debug('S drive File Paths 3 : '+ accountFiles); 
        
    }
    
    @future
    public static void  UpdateContactFilePath(List<Id> fileRecordIds){
        List<String> contactFilePaths;
        List<Id> fileParentIds=new List<Id>();
        List<Map<String,String>> requestParametersList = new  List<Map<String,String>>();
        
        List<cg__ContactFile__c> contactFiles = [Select Id, cg__Contact__c, cg__File_Name__c, File_Path__c from cg__ContactFile__c where cg__Content_Type__c !='Folder' and  cg__ContactFile__c.Id in: fileRecordIds];
        
        if(contactFiles.size() > 0){
            for(cg__ContactFile__c dbContactFileRec : contactFiles){
                fileParentIds.add(dbContactFileRec.cg__Contact__c);
                requestParametersList.add(new Map<String,String>{'response-content-disposition'=>'attachment;filename=' + dbContactFileRec.cg__File_Name__c});
            }
        }
        if(fileParentIds.size() >0) {
            
            if(!Test.isRunningTest())
                //Used to get the file path of the attachment stored in Amazon
                contactFilePaths = cg.SDriveTools.getAttachmentURLs(fileParentIds, fileRecordIds, (365 * 24 * 60 * 60), requestParametersList); 
            else
                contactFilePaths = new List<String>{'https://s3-us-west-2.amazonaws.com/mawafilesfullcopy/00Q5B000001s3bt/a1U5B0000000Df1UAE/MedicalSummaryReport.txt?response-content-disposition=attachment&filename=MedicalSummaryReport.txt&AWSAccessKeyId=AKIAIEYUJRAAMNE7W7NA&Expires=1509032442&Signature=Yx0UX2ADZxo9GbbDFH+q7opBzwU='};
                    
                    }
        System.debug('contactFilePaths>>>>'+contactFilePaths);
        system.debug('S drive File Paths 1 : '+ contactFilePaths );
        
        for( cg__ContactFile__c ContactFileRec : contactFiles){
            for(String str : contactFilePaths){
                if(str.contains(ContactFileRec.Id)){
                    ContactFileRec.File_Path__c=str;
                }
            }
        }
        system.debug('S drive File Paths 2 : '+ contactFiles);
        update contactFiles;
        system.debug('S drive File Paths 3 : '+ contactFiles); 
        
    }
    
    @future
    public static void  UpdateCaseFilePath(List<Id> fileRecordIds){
        List<String> caseFilePaths;
        List<Id> fileParentIds=new List<Id>();
        List<Map<String,String>> requestParametersList = new  List<Map<String,String>>();
        
        List<cg__CaseFile__c> caseFiles = [Select Id, cg__Case__c, cg__File_Name__c, File_Path__c from cg__CaseFile__c where cg__CaseFile__c.cg__Content_Type__c !='Folder' and  cg__CaseFile__c.Id in: fileRecordIds];
        
        if(caseFiles.size() > 0){
            for(cg__CaseFile__c dbCaseFileRec : caseFiles){
                fileParentIds.add(dbCaseFileRec.cg__Case__c);
                requestParametersList.add(new Map<String,String>{'response-content-disposition'=>'attachment;filename=' + dbCaseFileRec.cg__File_Name__c});
            }
        }
        
        if(!Test.isRunningTest())
            //Used to get the file path of the attachment stored in Amazon
            caseFilePaths = cg.SDriveTools.getAttachmentURLs(fileParentIds, fileRecordIds, (365 * 24 * 60 * 60), requestParametersList);
        else
            caseFilePaths = new List<String>{'https://s3-us-west-2.amazonaws.com/mawafilesfullcopy/00Q5B000001s3bt/a1U5B0000000Df1UAE/MedicalSummaryReport.txt?response-content-disposition=attachment&filename=MedicalSummaryReport.txt&AWSAccessKeyId=AKIAIEYUJRAAMNE7W7NA&Expires=1509032442&Signature=Yx0UX2ADZxo9GbbDFH+q7opBzwU='};
                
                System.debug('caseFilePaths>>>>'+caseFilePaths);
        system.debug('S drive File Paths 1 : '+ caseFilePaths );
        
        for(cg__CaseFile__c caseFileRec : caseFiles){
            for(String str : caseFilePaths){
                if(str.contains(caseFileRec.Id)){
                    caseFileRec.File_Path__c=str;
                }
            }
        }
        system.debug('S drive File Paths 2 : '+ caseFiles);
        update caseFiles;
        system.debug('S drive File Paths 3 : '+ caseFiles); 
    }
    
    
    @future
    public static void  UpdateBackgroundCheckFilePath(List<Id> fileRecordIds){
        List<String> bcFilePaths;
        List<Id> fileParentIds=new List<Id>();
        List<Map<String,String>> requestParametersList = new  List<Map<String,String>>();
        
        List<Background_Check_File__c> bcFiles = [Select Id, Parent__c, File_Name__c, File_Path__c from Background_Check_File__c where Background_Check_File__c.Content_Type__c !='Folder' and  Background_Check_File__c.Id in: fileRecordIds];
        
        if(bcFiles.size() > 0){
            for(Background_Check_File__c dbbcFileRec : bcFiles){
                fileParentIds.add(dbbcFileRec.Parent__c);
                requestParametersList.add(new Map<String,String>{'response-content-disposition'=>'attachment;filename=' + dbbcFileRec.File_Name__c});
            }
        }
        
        
        if(!Test.isRunningTest())
            //Used to get the file path of the attachment stored in Amazon
            bcFilePaths= cg.SDriveTools.getAttachmentURLs(fileParentIds, fileRecordIds, (365 * 24 * 60 * 60), requestParametersList);
        else
            bcFilePaths = new List<String>{'https://s3-us-west-2.amazonaws.com/mawafilesfullcopy/00Q5B000001s3bt/a1U5B0000000Df1UAE/MedicalSummaryReport.txt?response-content-disposition=attachment&filename=MedicalSummaryReport.txt&AWSAccessKeyId=AKIAIEYUJRAAMNE7W7NA&Expires=1509032442&Signature=Yx0UX2ADZxo9GbbDFH+q7opBzwU='};
                
                
                
                
                System.debug('bcFilePaths>>>>'+bcFilePaths);
        system.debug('S drive File Paths 1 : '+ bcFilePaths );
        
        for(Background_Check_File__c bcFileRec : bcFiles){
            for(String str : bcFilePaths){
                if(str.contains(bcFileRec.Id)){
                    bcFileRec.File_Path__c=str;
                }
            }
        }
        system.debug('S drive File Paths 2 : '+ bcFiles);
        update bcFiles;
        system.debug('S drive File Paths 3 : '+ bcFiles); 
    }
    
    @future
    public static void  UpdateInKindDonReimburFilePath(List<Id> fileRecordIds){
        List<String> drFilePaths;
        List<Id> fileParentIds=new List<Id>();
        List<Map<String,String>> requestParametersList = new  List<Map<String,String>>();
        
        List<In_Kind_Donation_Reimbursement_File__c> drFiles = [Select Id, Parent__c, File_Name__c, File_Path__c from In_Kind_Donation_Reimbursement_File__c where In_Kind_Donation_Reimbursement_File__c.Content_Type__c !='Folder' and  In_Kind_Donation_Reimbursement_File__c.Id in: fileRecordIds];
        
        if(drFiles.size() > 0){
            for(In_Kind_Donation_Reimbursement_File__c dbdrFileRec : drFiles){
                fileParentIds.add(dbdrFileRec.Parent__c);
                requestParametersList.add(new Map<String,String>{'response-content-disposition'=>'attachment;filename=' + dbdrFileRec.File_Name__c});
            }
        }
        
        
        if(!Test.isRunningTest())
            //Used to get the file path of the attachment stored in Amazon
            drFilePaths= cg.SDriveTools.getAttachmentURLs(fileParentIds, fileRecordIds, (365 * 24 * 60 * 60), requestParametersList);
        else
            drFilePaths= new List<String>{'https://s3-us-west-2.amazonaws.com/mawafilesfullcopy/00Q5B000001s3bt/a1U5B0000000Df1UAE/MedicalSummaryReport.txt?response-content-disposition=attachment&filename=MedicalSummaryReport.txt&AWSAccessKeyId=AKIAIEYUJRAAMNE7W7NA&Expires=1509032442&Signature=Yx0UX2ADZxo9GbbDFH+q7opBzwU='};
                
                
                
                
                System.debug('bcFilePaths>>>>'+drFilePaths);
        system.debug('S drive File Paths 1 : '+ drFilePaths);
        
        for(In_Kind_Donation_Reimbursement_File__c drFileRec : drFiles){
            for(String str : drFilePaths){
                if(str.contains(drFileRec.Id)){
                    drFileRec.File_Path__c=str;
                }
            }
        }
        system.debug('S drive File Paths 2 : '+ drFiles);
        update drFiles;
        system.debug('S drive File Paths 3 : '+ drFiles); 
    }
    
    /*This method is used to create file path for the attachment that stored to SDrive from the Lead record.
It will update the file path to lead file record that created during attachment upload*/
    @future
    public static void  generateLeadFilePath(Set<Id> fileIdsSet){
        List<Id> fileIdsList = new List<Id>(fileIdsSet);
        List<String> leadFilePath;
        List<Id> fileParentIdList = new List<Id>();
        List<Map<String,String>> requestParametersList = new  List<Map<String,String>>();
        
        List<Lead_File__c> leadFileList = [Select Id, Parent__c, File_Name__c, File_Path__c from Lead_File__c where Lead_File__c.Content_Type__c !='Folder' and  Lead_File__c.Id in: fileIdsSet];
        if(leadFileList.size() > 0) {
            for(Lead_File__c collectedFileRec : leadFileList){
                fileParentIdList.add(collectedFileRec.Parent__c);
                requestParametersList.add(new Map<String,String>{'response-content-disposition'=>'attachment;filename=' + collectedFileRec.File_Name__c});
            }
        }
        
        if(!Test.isRunningTest())
            //Used to get the file path of the attachment stored in Amazon
            leadFilePath = cg.SDriveTools.getAttachmentURLs(fileParentIdList, fileIdsList, (365 * 24 * 60 * 60), requestParametersList);
        else
            leadfilepath = new List<String>{'https://s3-us-west-2.amazonaws.com/mawafilesfullcopy/00Q5B000001s3bt/a1U5B0000000Df1UAE/MedicalSummaryReport.txt?response-content-disposition=attachment&filename=MedicalSummaryReport.txt&AWSAccessKeyId=AKIAIEYUJRAAMNE7W7NA&Expires=1509032442&Signature=Yx0UX2ADZxo9GbbDFH+q7opBzwU='};
                for(Lead_File__c collectedFileRec : leadFileList){
                    for(String filePath : leadFilePath){
                        if(filePath.contains(collectedFileRec.Id)){
                            collectedFileRec.File_Path__c = filePath;
                        }
                    }
                }
        update leadFileList;
    }
    
    
    // Used to generate task when volunteer upload image or video
    @Future(callout = true)
    public static void  createAttachmentReviewTask(String jsontaskListString, Set<Id> caseIdsSet){
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId(); 
        Id  staffTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.staffTaskRT).getRecordTypeId();
        List<cg__CaseFile__c> caseFileList = (List<cg__CaseFile__c>)Json.deserialize(jsontaskListString,List<cg__CaseFile__c>.class);
        
        Id contactId;
        Map<Id, Case> caseOwnerMap = new Map<Id, Case>();
        for(Case caseOwner : [SELECT Id, ContactId, RecordTypeId, OwnerId FROM Case WHERE RecordTypeId =: parentWishRecordTypeId AND Id IN : caseIdsSet]) {
            caseOwnerMap.put(caseOwner.Id, caseOwner);
            contactId = caseOwner.Id;
        }
        Set<Id> reviewPhotosSet = new Set<Id>();
        Set<Id> dupCheck = new Set<Id>();
        if(contactId != null) {
            String jsonbody = VolunteerInterviewTask_AC.getUploadReviewTask(contactId);
            List<Task> newTaskList;
            if(!Test.isRunningTest()) {
                newTaskList =  (List<Task>) JSON.deserialize(jsonbody, List<Task>.class);
            } else {
                newTaskList = new list<task>();
            }
            if(newTaskList.size() > 0 ) {
                for(Task getTask : newTaskList) {
                    reviewPhotosSet.add(getTask.WhatId);
                }
            }
        }
        List<Task> reviewTaskList = new List<Task>();
        for(cg__CaseFile__c createTask : caseFileList) {
            if(!reviewPhotosSet.contains(createTask.cg__Case__c) && !dupCheck.contains(createTask.cg__Case__c)) {
                Task reviewTask = new Task();
                reviewTask.Subject = 'Review Volunteer Upload';
                reviewTask.WhatId = createTask.cg__Case__c;
                reviewTask.RecordTypeId = staffTaskRT;
                reviewTask.ActivityDate = System.today().addDays(10);
                if(caseOwnerMap.containsKey(createTask.cg__Case__c)) {
                    reviewTask.OwnerId = caseOwnerMap.get(createTask.cg__Case__c).OwnerId;
                    reviewTask.WhoId = caseOwnerMap.get(createTask.cg__Case__c).ContactId;
                }
                reviewTaskList.add(reviewTask);
                dupCheck.add(createTask.cg__Case__c);
            }
        }
        if(reviewTaskList.size() > 0) {
            insert reviewTaskList;
        }   
        
    }
}