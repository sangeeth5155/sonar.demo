/***************************************************************************************************
Author      : MST Solutions
Date        : 4/10/2016
Description : This trigger us used to fetch the associated case owner,case owner's manager 
****************************************************************************************************/
trigger InKindDonationReimbursement_AT on In_Kind_Donation_Reimbursement__c (before insert,before update,after insert,after update) {
    
    List<Contact> volunteerContactList = new List<Contact>();
    List<User> volunteerUserList = new List<User>();
    Constant_AC newConstant =  new Constant_AC();
    Id reImbursementRtId = Schema.Sobjecttype.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get(newConstant.Reimbursement).getRecordTypeId();
    if(trigger.isBefore && trigger.isInsert){
        set<string> wishIdsSet = new set<string>();
        map<id,id> wishOwnerMap = new map<id,id>();
        map<id,id> wishManagerMap = new map<id,id>();
        Id inKindRtId = Schema.Sobjecttype.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get(newConstant.InKind).getRecordTypeId();
        for(In_Kind_Donation_Reimbursement__c newRecord : trigger.new){
            if(newRecord.Wish__c != Null ){
                wishIdsSet.add(newRecord.Wish__c);
            }
            
            
            if(wishIdsSet.size()>0){
                for(Case newCase : [SELECT Id,ownerId FROM Case WHERE Id IN:wishIdsSet ]){
                    wishOwnerMap.put(newCase.Id, newCase.OwnerId);
                }
            }
            if(wishOwnerMap.size()>0){
                for(User getManager: [Select Id,ManagerId FROM User Where Id IN:wishOwnerMap.values()]){
                    wishManagerMap.put(getManager.Id, getManager.ManagerId);
                }
            }
            
            if(wishManagerMap.size()>0){
                for(In_Kind_Donation_Reimbursement__c newReImburse : trigger.new){
                    if(newReImburse.Wish__c != Null && wishOwnerMap.containsKey(newReImburse.Wish__c)){
                        
                    }
                }
            }
        }
    }
        //Before update trigger is used fetch the associated case owner,case owner's manager and update with In-Kind record
    if(trigger.isbefore && trigger.isUpdate){
        set<string> wishIdsSet = new set<string>();
        map<id,id> wishOwnerMap = new map<id,id>();
        map<id,id> wishManagerMap = new map<id,id>();
        for(In_Kind_Donation_Reimbursement__c inkindReimburse : trigger.new){
            if(inkindReimburse.Wish__c != Null && trigger.oldMap.get(inkindReimburse.id).Wish__c != inkindReimburse.Wish__c){
                wishIdsSet.add(inkindReimburse.Wish__c);
            }
            
            if(wishIdsSet.size()>0){
                for(Case newCase : [SELECT Id,ownerId FROM Case WHERE Id IN:wishIdsSet ]){
                    wishOwnerMap.put(newCase.Id, newCase.OwnerId);
                }
            }
            if(wishOwnerMap.size()>0){
                for(User getManager: [Select Id,ManagerId FROM User Where Id IN:wishOwnerMap.values()]){
                    wishManagerMap.put(getManager.Id, getManager.ManagerId);
                }
            }
            
            if(wishManagerMap.size()>0){
                for(In_Kind_Donation_Reimbursement__c newReImburse : trigger.new){
                    if(newReImburse.Wish__c != Null && wishOwnerMap.containsKey(newReImburse.Wish__c)){
                        
                    }
                }
            }
            
        }
        
    }
    
    if(Trigger.isBefore && Trigger.isUpdate ){
        
       /* List<In_Kind_Donation_Reimbursement__c>dbInkindList =  [SELECT id,Ownerid,owner.UserRole.Name,Wish__r.ChapterName__r.Name FROM In_Kind_Donation_Reimbursement__c WHERE Id IN :Trigger.newMap.Keyset()];
        Map<String,List<In_Kind_Donation_Reimbursement__c >> inKindDonationMap = new Map<String,List<In_Kind_Donation_Reimbursement__c>>();
        for(In_Kind_Donation_Reimbursement__c currRec : dbInkindList ){
            if(currRec.Wish__c != Null && (Trigger.isInsert || currRec.OwnerId != Trigger.oldMap.get(currRec.Id).OwnerId) && currRec.Owner.UserRole.Name == 'National Staff' ){
                if(inKindDonationMap.containsKey(currRec.Wish__r.ChapterName__r.Name))
                    inKindDonationMap.get(currRec.Wish__r.ChapterName__r.Name).add(currRec);
                else
                    inKindDonationMap.put(currRec.Wish__r.ChapterName__r.Name, new List<In_Kind_Donation_Reimbursement__c>{currRec});
            }
        }
        
        if(inKindDonationMap.Size() > 0)
           ChapterStaffRecordSharing_AC.inKindReimbursementSharing(inKindDonationMap);
    }*/
        List<User> currUser = [SELECT id,UserRole.Name,Chapter_Name__c,Profile.Name FROM User WHERE id = :userInfo.getUserId() limit 1];  
        set<String> chapterNamesSet = new Set<String>();
        Map<Id,String> chapterNameMap = new Map<Id,String>();
        Map<String,String> chapterRoleMap = new Map<String,String>();
        
        for(In_Kind_Donation_Reimbursement__c currRec : [SELECT id,Ownerid,Wish__C,owner.UserRole.Name,Wish__r.ChapterName__r.Name FROM In_Kind_Donation_Reimbursement__c WHERE Id IN :Trigger.newMap.Keyset()]){
            if(currRec.Wish__C != Null)
                chapterNamesSet.add(currRec.Wish__r.ChapterName__r.Name);
                chapterNameMap.put(currRec.Id,currRec.Wish__r.ChapterName__r.Name);
        }
        
        if(chapterNamesSet.Size() > 0){
            chapterRoleMap=ChapterStaffRecordSharing_AC.FindChapterRole(chapterNamesSet);
        
            for(In_Kind_Donation_Reimbursement__c currRec :Trigger.New){ 
                system.debug('Chapter Name****************'+chapterNameMap.get(currRec.Id));
                if(chapterRoleMap.get(chapterNameMap.get(currRec.Id)) != currUser[0].UserRole.Name && currUser[0].UserRole.Name != 'National Staff' && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null
                    && currUser[0].profile.Name != 'System Administrator' && currUser[0].Chapter_Name__c != (chapterNameMap.get(currRec.id)))
               {
                     currRec.addError('Insufficient previlege to update this record. Please contact system administrator.');        
               }
            }
       } 
   }
   
}