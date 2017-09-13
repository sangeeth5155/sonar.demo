/*****************************************************************************************************************
Author      : MST Solutions
Date        : 5/26/2016
Description : 
1.This trigger is used to create child wish for parent wish .
2.Create tasks for child wishes.
3.Submits parent wish for approval once the required number of volunteers added to the parent wish team.
4.Add parent wish team members to child wish team.
*******************************************************************************************************************/

trigger CaseTrigger_AT on Case (after insert, after update,before update, after delete,before insert) {
    
    Constant_AC  constant = new Constant_Ac();   
    public static String wishDeterminationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
    public static String parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
    public static String wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();
    public static String wishAssistRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishAssistRT).getRecordTypeId();
    public static String wishGrantRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
    public static String wishEffectRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishEffectRT).getRecordTypeId();
    
    public Id partARecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(constant.partARecordTypeId).getRecordTypeId();
    public Id volunteerOppWishRecordTypeId = Schema.SObjectType.Volunteer_Opportunity__c.getRecordTypeInfosByName().get('Wish').getRecordTypeId();
    public static Id diagnosisVerificationRT = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.diagnosisRT).getRecordTypeId();
    public Id chapterecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
    List<Approval.ProcessSubmitRequest> approvalReqList=new List<Approval.ProcessSubmitRequest>();
    Set<Id> contactIds = new Set<Id>();
    Map<Id,contact> contactMap = new Map<Id,Contact>();
    
    
    // Mapping Birthdate from Contact to Wish.
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) { 
        Set<Id> PartAwishContactSet = new Set<Id>();
        Map<Id,Contact> PartAwishContactMap = new Map<Id,Contact>();
        Set<Id> wishOwnerIdSet = new Set<Id>();
        Map<Id,User> wishOwnerMap = new Map<Id,User>();
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> medicalprofContactdSet = new Set<Id>();
        String nationalRec;
        String email;
        if(Trigger.isInsert)
        {
            
            //  WishesTriggerHelperClass.updateDateReceived(null,trigger.new);
            Map<Id, Id> intakeManagerMap = new Map<Id, Id>();
            Set<Id> chapterSet = new Set<Id>();
            map<id,Case> parentChildCaseMap = new map<id,Case>();
            for(Case newCase : trigger.new){
                
                if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null) {
                    
                    wishOwnerIdSet.add(newCase.OwnerId);
                }
                if(newCase.RecordTypeId == wishGrantRecordTypeId && newCase.ParentId != Null){
                    parentChildCaseMap.put(newCase.ParentId,newCase);
                }
                if(newCase.RecordTypeId == parentWishRecordTypeId) {
                    chapterSet.add(newCase.ChapterName__c);
                }
                
                if(!newCase.Rush__c){
                    newCase.Rush_Timeframe__c=Null;
                    newCase.Rush_Explanation__c=Null;
                }
            }
            
            for(Account accInfo : [SELECT Id,Intake_Manager__c FROM Account WHERE Id IN : chapterSet]) {
                intakeManagerMap.put(accInfo.Id, accInfo.Intake_Manager__c);
            }
            
            
            
            if(wishOwnerIdSet.size() > 0){
                for(User wishOwner : [SELECT Id,ManagerId,Manager.Name,Manager.Email From User WHERE Id IN: wishOwnerIdSet AND ManagerId != Null ]){
                    wishOwnerMap.put(wishOwner.id,wishOwner);
                }
                
                
            }
            
            
            
            for(Case newCase : trigger.new){
                if(intakeManagerMap.containsKey(newCase.chapterName__c) && intakeManagerMap.get(newCase.chapterName__c) != null ) {
                    //  newCase.OwnerId = intakeManagerMap.get(newCase.chapterName__c);
                }
                if(wishOwnerMap.containsKey(newCase.OwnerId)){
                    if(wishOwnerMap.get(newCase.OwnerId).ManagerId != Null)
                    {
                        newCase.Hidden_Wish_Owner_Manager__c  = wishOwnerMap.get(newCase.OwnerId).Manager.Name;
                        newCase.Hidden_Wish_Owner_Email__c = wishOwnerMap.get(newCase.OwnerId).Manager.Email;
                    }
                    
                }
                
            }
            
            if(parentChildCaseMap.size() > 0 ){
                CaseTriggerHandler.updateGrantingCaseDevEmail(parentChildCaseMap);
            }
            
        }
        if(Trigger.isUpdate)
        {
            UserSetting__c usc = UserSetting__c.getValues(userinfo.getUserId());
            List<Case>updateChildCaseList = new List<Case>();
            Map<Id,Case> caseMap = New Map<Id,Case>();
            Map<Id,Account> managerUserMap = new Map<Id,Account>();
            Map<String,Case> wishChildInfoMap = new Map<String,case>();
            Map<Id, Case> parentCaseMap = new Map<Id, Case>();
            Set<Id> contactSet = new Set<Id>();
            Set<Id> parentGrantedIdSet = new Set<Id>();
            List<Case> wishGrantedList = new List<Case>();
            List<Case> updateChildCasetocloseList = new List<Case>();
            Profile dbprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId()];
            List<Account> dbAccountList = [SELECT Id,MAC_Email_del__c,Name,RecordTypeId FROM Account WHERE Name =: 'Make-A-Wish America' AND RecordTypeId =: chapterecordTypeId Limit 1];
            //system.debug('National Email' + dbAccountList[0].MAC_Email_del__c);
            // WishesTriggerHelperClass.updateDateReceived(trigger.oldMap,trigger.newMap.values());
            Set<Id> parentWishIdsSet = new Set<Id>();
            Set<Id> WishIdSet = new Set<Id>();
            for(Case currentCase : Trigger.new)
            {  
                if(currentCase.ownerId == null)
                    currentCase.Ownerid = Userinfo.getUserId();
                
                wishOwnerIdSet.add(currentCase.OwnerId);
                
                if((currentCase.Status == 'Ready to Assign') && trigger.oldmap.get(currentCase.id).Status !=  'Ready to Assign' && currentCase.RecordTypeId == parentWishRecordTypeId){
                    
                    caseMap.Put(currentCase.ChapterName__c,currentCase);
                    currentCase.Ready_to_Assign_Date__c = Date.Today();
                    parentCaseMap.put(currentCase.Id, currentCase);
                    contactSet.add(currentCase.ContactId);
                    
                }
                /* if((currentCase.Appropriate_Comments__c != trigger.oldMap.get(currentCase.Id).Appropriate_Comments__c ||  currentCase.Please_Explain__c != trigger.oldMap.get(currentCase.Id).Please_Explain__c) && currentCase.RecordTypeId == parentWishRecordTypeId){
currentCase.Wish_Clearance_Received_Date__c = system.today();
}*/
                
                if((!currentCase.Rush__c) && trigger.oldMap.get(currentCase.Id).Rush__c==True){
                    currentCase.Rush_Timeframe__c=Null;
                    currentCase.Rush_Explanation__c=Null;
                }
                
                if(currentCase.status == 'Hold' && currentCase.status != trigger.oldMap.get(currentCase.Id).Status && (trigger.oldMap.get(currentCase.Id).Status != 'Hold' || 
                                                                                                                       trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Approved' || trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Submitted')){
                                                                                                                           
                                                                                                                           currentCase.Hidden_Hold_Status_Value__c = trigger.oldMap.get(currentCase.Id).Status;
                                                                                                                       }
                
                if(currentCase.status == 'Inactive' &&  currentCase.status != trigger.oldMap.get(currentCase.Id).Status && (trigger.oldMap.get(currentCase.Id).Status != 'Inactive' || 
                                                                                                                            trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Approved' || trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Submitted')){
                                                                                                                                currentCase.Hidden_Hold_Status_Value__c = trigger.oldMap.get(currentCase.Id).Status;
                                                                                                                            }
                if(currentCase.status == 'Closed' && currentCase.status != trigger.oldMap.get(currentCase.Id).Status && (trigger.oldMap.get(currentCase.Id).Status != 'Closed' || 
                                                                                                                         trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Approved' || trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Submitted')){
                                                                                                                             currentCase.Hidden_Hold_Status_Value__c = trigger.oldMap.get(currentCase.Id).Status;
                                                                                                                         }
                if(currentCase.status == 'DNQ' && currentCase.status != trigger.oldMap.get(currentCase.Id).Status && (trigger.oldMap.get(currentCase.Id).Status != 'DNQ' || 
                                                                                                                      trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Approved' || trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Submitted')){
                                                                                                                          currentCase.Hidden_Hold_Status_Value__c = trigger.oldMap.get(currentCase.Id).Status;
                                                                                                                      }
                
                if(currentCase.status == 'Ready to Interview' && trigger.oldMap.get(currentCase.Id).Status == 'Ready to Assign'){
                    currentCase.Sub_Status__c = 'Pending';
                }
                
                if(currentCase.RecordTypeId == partARecordTypeId && currentCase.Local_MCA_Team__c != trigger.oldMap.get(currentCase.Id).Local_MCA_Team__c) {
                    currentCase.Chapter_MACEmail__c = currentCase.Medical_Advisor_Email__c;
                }
                
                if(currentCase.RecordTypeId == partARecordTypeId && currentCase.status == 'Escalated' && trigger.oldMap.get(currentCase.Id).Status ==  'Escalated' && currentCase.Case_Comment__c != trigger.oldMap.get(currentCase.Id).Case_Comment__c){
                    currentCase.isNationalReply__c = true;
                }
                
                
                if(currentCase.Comments__c != trigger.oldMap.get(currentCase.Id).Comments__c)
                    currentCase.Air_Travel_Details__c = 'This wish does not involve air trave';
                if(currentCase.Comment_1__c != trigger.oldMap.get(currentCase.Id).Comment_1__c)  
                    currentCase.Air_Travel_Details__c = 'I am fully aware of the medical research regarding air travel and feel it is appropriate for this child. I will make any necessary adjustments to the medical treatment plan prior to their travel dates';
                if(currentCase.Comment_2__c != trigger.oldMap.get(currentCase.Id).Comment_2__c)  
                    currentCase.Air_Travel_Details__c = 'I do not support air travel for this child';
                if(currentCase.Appropriate_Comments__c != trigger.oldMap.get(currentCase.Id).Appropriate_Comments__c)
                    currentCase.Wish_Clearance__c = 'Appropriate';
                if(currentCase.Please_Explain__c != trigger.oldMap.get(currentCase.Id).Please_Explain__c )
                    currentCase.Wish_Clearance__c = 'Not Appropriate';
                
                if(currentCase.RecordTypeId == parentWishRecordTypeId && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null && currentCase.Status == 'Wish Determined' && currentCase.Sub_Status__c == 'Within Policy' && currentCase.Wish_Type__c == Null)
                    currentCase.Wish_Type__c.addError('Please Enter the value for Wish Type'); 
                
                if(currentCase.RecordTypeId == parentWishRecordTypeId && currentCase.Status == 'Wish Determined' && currentCase.Sub_Status__c == 'Within Policy' && currentCase.Wish_Type__c != Null){
                    
                    caseMap.Put(currentCase.ChapterName__c,currentCase);
                }
                /* Used to close the wish determine case and open the new planning and Granting and Impact sub cases will open. */
                if(currentCase.status == 'Wish Determined' && currentCase.Sub_Status__c != Trigger.oldMap.get(currentCase.id).Sub_Status__c && currentCase.Sub_Status__c == 'Within Policy' && currentCase.Wish_Type__c != Null && currentCase.RecordTypeid == parentWishRecordTypeId){
                    currentCase.Meet_PWL_Criteria__c = 'Yes';
                    currentCase.Concept_Approval_Date__c = Date.Today();
                    updateChildCaseList.add(currentCase);
                }
                
                if(currentCase.status == 'Wish Determined' && Trigger.oldMap.get(currentCase.id).status != 'Wish Determined' && currentCase.RecordTypeid == parentWishRecordTypeId){
                    currentCase.Wish_Determined_Date__c = system.Today();
                }
                
                
                if((currentCase.Budget_Approved_Date__c != Null && trigger.oldMap.get(currentCase.Id).Budget_Approved_Date__c == Null) || (currentCase.Budget_Submitted_Date__c != Null && trigger.oldMap.get(currentCase.Id).Budget_Submitted_Date__c == Null)){
                    if(currentCase.Budget_Submitted_Date__c != Null)
                        currentCase.Status = 'Budget Approval - Submitted';
                    if(currentCase.Budget_Approved_Date__c != Null)
                        currentCase.Status = 'Budget Approval - Approved';
                    
                }
                
                if((currentCase.Status == 'Budget Approval - Submitted' && trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Submitted') || (currentCase.Status == 'Budget Approval - Approved' && trigger.oldMap.get(currentCase.Id).Status != 'Budget Approval - Approved')){
                    currentCase.Sub_Status__c = Null;
                }
                
                if(currentCase.Status == 'Escalated' && currentCase.RecordTypeId == partARecordTypeId && trigger.oldMap.get(currentCase.id).Status != 'Escalated'){
                    
                    system.debug('MAC_Email_del__c @@@@@@@@@@2'+ dbAccountList[0].MAC_Email_del__c);
                    currentCase.isNational__c = True;
                    currentCase.MAC_Email__c = dbAccountList[0].MAC_Email_del__c;
                    system.debug(' currentCase.MAC_Email__c @@@@@@@@@@2'+  currentCase.MAC_Email__c); 
                }
                
                if(currentCase.Status == 'DNQ - Chapter Staff' || currentCase.Status == 'DNQ - Chapter Medical Advisor' || 
                   currentCase.Status == 'DNQ - National Staff' || currentCase.Status == 'DNQ - National Medical Council')
                {
                    
                    currentCase.DNQ_Date__c = Date.Today();
                }
                
                
                
                /* if((currentCase.Status == 'Wish Determined') && (trigger.oldmap.get(currentCase.id).Status != 'Wish Determined')){
currentCase.Meet_PWL_Criteria__c = 'Yes';
currentCase.Sub_Status__c = 'Within Policy';
currentCase.Concept_Approval_Date__c = Date.Today();
}*/
                
                if((currentCase.Status == 'Completed') && (trigger.oldmap.get(currentCase.id).Status != 'Completed') && currentCase.RecordTypeId == parentWishRecordTypeId ){
                    //currentCase.status = 'Closed';
                    //system.debug('Parent Case Id 1 :'+currentCase.Id);
                    parentWishIdsSet.add(currentCase.Id);
                }
                if(currentCase.RecordTypeId == parentWishRecordTypeId && currentCase.Status != Trigger.oldMap.get(currentCase.Id).Status && (((currentCase.Status == 'Granted') && (trigger.oldmap.get(currentCase.id).Status == 'Wish Scheduled')) || ((currentCase.Status == 'Completed') && (trigger.oldmap.get(currentCase.id).Status != 'Completed')) ||
                                                                          (currentCase.Status == 'DNQ' || currentCase.Status == 'Hold' || currentCase.Status == 'Inactive' || currentCase.Status == 'Closed'))){
                                                                              parentGrantedIdSet.add(currentCase.Id);
                                                                          }
                
                if(currentCase.Sub_Status__c == 'Abandoned' || currentCase.isClosed == True){
                    
                    currentCase.IsLocked__c = true;
                }
                
                if(RecursiveTriggerHandler.blockCaseLockRecursive == True)  
                {  
                    RecursiveTriggerHandler.blockCaseLockRecursive = false;
                    if( currentCase.IsLocked__c == true && trigger.oldMap.get(currentCase.Id).IsLocked__c == true && usc != Null){
                        if(usc.All_Closed_Cases_except_Abandoned__c == false && currentCase.Sub_Status__c != 'Abandoned' && currentCase.isClosed == True &&
                           dbprofile.Name != 'System Administrator' && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null && (currentCase.RecordTypeId != wishPlanningRecordTypeId || currentCase.RecordTypeId != wishDeterminationRecordTypeId))
                            currentCase.addError('You have not Permission to edit this record.');
                        if(usc.Edit_Abandoned_Cases__c== false && currentCase.Sub_Status__c == 'Abandoned' && currentCase.isClosed == True &&
                           dbprofile.Name != 'System Administrator' && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null &&  (currentCase.RecordTypeId != wishPlanningRecordTypeId || currentCase.RecordTypeId != wishDeterminationRecordTypeId))
                            currentCase.addError('You have not Permission to edit this record.');
                    }
                    else if( currentCase.IsLocked__c == true && trigger.oldMap.get(currentCase.Id).IsLocked__c == true && usc == Null &&
                            dbprofile.Name != 'System Administrator' && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null && (currentCase.RecordTypeId != wishPlanningRecordTypeId || currentCase.RecordTypeId != wishDeterminationRecordTypeId)){
                                currentCase.addError('You have not Permission to edit this record.');
                            }
                    
                    if(currentCase.Sub_Status__c == 'Abandoned' && Trigger.oldMap.get(currentCase.id).Status == 'Granted' && usc == Null && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
                    {
                        currentCase.addError('You have not Permission to update the granted case as abandoned');
                    }
                    else if(currentCase.Sub_Status__c == 'Abandoned' && Trigger.oldMap.get(currentCase.id).Status == 'Granted' && usc != Null && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
                    {
                        if(usc.Abandon_the_Granted_case__c== false)
                            
                            currentCase.addError('You have not Permission to update the granted case as abandoned');
                    }
                }
                
                if(currentCase.Status == 'On Hold' && Trigger.oldMap.get(currentCase.id).Status != 'On Hold')
                {
                    currentCase.Hold_Date__c = Date.Today();
                }
                else if(currentCase.Status == 'Inactive' && Trigger.oldMap.get(currentCase.id).Status != 'Inactive')
                {
                    currentCase.Inactive_Date__c= Date.Today();
                }
                else if((currentCase.Status == 'Closed' || currentCase.Status == 'Completed') && Trigger.oldMap.get(currentCase.id).Status == 'Granted')
                {
                    currentCase.Completed_date__c= Date.Today();
                }
                
                if(currentCase.Sub_Status__c == 'Abandoned' && currentCase.Sub_Status__c != 'Abandoned')
                    currentCase.Closed_Date__c = Date.Today();
                
                if(currentCase.Update_Wish_Child_Form_Info__c == True && Trigger.oldMap.get(currentCase.id).Update_Wish_Child_Form_Info__c != True)
                {
                    wishChildInfoMap.put(currentCase.id,currentCase);
                } 
                /*  if(currentCase.Interview_date__c < System.today() && Trigger.oldMap.get(currentCase.id).interview_date__c != currentCase.Interview_Date__c) {
currentCase.Interview_date__c.addError('Interview Date should be in future');
}*/
            }
            if(caseIdSet.size() > 0){
                for(User wishOwner : [SELECT Id,Email From User WHERE Id IN: caseIdSet ]){
                    wishOwnerMap.put(wishOwner.id,wishOwner);
                }
            }
            
            if(parentCaseMap.size() > 0) {
                CaseTriggerHandler.wishChildRegionValidation(parentCaseMap, contactSet);
            }
            if(wishOwnerIdSet.size() > 0){
                for(User wishOwner : [SELECT Id,ManagerId,Manager.Name,Manager.Email,Email From User WHERE Id IN: wishOwnerIdSet AND ManagerId != Null ]){
                    wishOwnerMap.put(wishOwner.id,wishOwner);
                }
            }
            for(Case newCase : trigger.new){
                if(wishOwnerMap.containsKey(newCase.OwnerId)){
                    if(wishOwnerMap.get(newCase.OwnerId).ManagerId != Null && newCase.RecordTypeId == parentWishRecordTypeId )
                    {
                        newCase.Hidden_Wish_Owner_Manager__c  = wishOwnerMap.get(newCase.OwnerId).Manager.Name;
                        newCase.Hidden_Wish_Owner_Email__c = wishOwnerMap.get(newCase.OwnerId).Manager.Email;
                    }
                    
                }
                
                
            }
            
            //Case Owner Old Logic
            for(Account currentAccount : [SELECT ID,Volunteer_Manager__c,Wish_Co_ordinator__c FROM Account Where ID IN: caseMap.keyset()] ){
                managerUserMap.put(currentAccount.Id,currentAccount);
            }
            for(Case currentCase : Trigger.new){
                if(managerUserMap.containsKey(currentCase.ChapterName__c) && currentCase.Status == 'Ready to Assign' && currentCase.Status != Trigger.oldMap.get(currentCase.Id).Status){
                    if(managerUserMap.get(currentCase.ChapterName__c).Volunteer_Manager__c != Null) {
                        currentCase.OwnerId = managerUserMap.get(currentCase.ChapterName__c).Volunteer_Manager__c;
                    }
                    
                }
                if(managerUserMap.containsKey(currentCase.ChapterName__c) && currentCase.RecordTypeId == parentWishRecordTypeId && currentCase.Status == 'Wish Determined' && currentCase.Sub_Status__c == 'Within Policy' && currentCase.Wish_Type__c != Null && Trigger.oldMap.get(currentCase.Id).Status != currentCase.Status){
                    if(managerUserMap.get(currentCase.ChapterName__c).Wish_Co_ordinator__c != Null)
                        currentCase.OwnerId = managerUserMap.get(currentCase.ChapterName__c).Wish_Co_ordinator__c ;
                }
            }
            
            if(parentWishIdsSet.size() >0){
                system.debug('Parent Case Id 2 :'+Trigger.new);
                CaseTriggerHandler.CheckBudgetActuals(Trigger.new);
            }
            if(parentGrantedIdSet.size() > 0){
                CaseTriggerHandler.checkreceivedDates(Trigger.new);
            }
            //if(updateChildCaseList.size() > 0)
            //CaseTriggerHandler.updateChildCase(updateChildCaseList);
            
            if(wishChildInfoMap.size() > 0)
            {
                WishChildFormValUpdate_AC.updateWishType(wishChildInfoMap);
                
            }
            
            
            for(Case currWish : Trigger.new) {
                if(currWish.contactId != Null && currWish.birthdate__c == Null) 
                {
                    contactIds.add(currWish.contactId); 
                }
                
                
            }
            
            if(contactIds.size() > 0) {
                contactMap.putAll([SELECT id,birthdate FROM Contact WHERE Id IN :contactIds]);
            }
            
            for(Case currWish : Trigger.new) 
            {
                
                if(contactMap.containsKey(currWish.contactId)) 
                {
                    if(contactMap.get(currWish.contactId).birthdate != Null)
                        currWish.birthdate__c = contactMap.get(currWish.contactId).birthdate;
                } 
            }
        }
    } 
    /* Used to create action track for different stages based on Chapter and used to pull Case team members to child wishes*/ 
    if(Trigger.isInsert && Trigger.isAfter) 
    {
        Set<Id> newCaseIdsSet = new Set<Id>();
        Set<Id> parentIdsSet = new Set<Id>();
        Set<Id> chapterNames = new Set<Id>();
        Map<Id, String> wishReceiptMap = new Map<Id, String>();
        list<Case> wishReceiptCaseList = new list<Case>();
        List<Case> wishDeterminationSubCaseList = new List<Case>();
        List<Case> wishGrantedSubCaseList = new List<Case>();
        Map<Id, Case> wishPlaningAnticipationSubCaseMap = new Map<Id, Case>();
        Set<String> wishTypeSet = new Set<String>();
        Set<Id> wishGrantedSubCaseIdSet = new Set<Id>();
        Map<Id, Case> wishChapterIdsMap = new Map<Id,Case>();
        String wishType = '';
        Map<Id, Id> contactCaseDVAttachmentMergeMap = new Map<Id, Id>();
        List<cg__CaseFile__c> casefiles=new List<cg__CaseFile__c>();
        List<Case> eligibilityReviewCaseList = new List<Case>();
        List<Case> caseParentList = new List<Case>();
        Map<Id, Case> parentCaseIntakeOwnerMap = new Map<Id, Case>();
        Map<String, List<Case>> caseSharingMap = new Map<String, List<Case>>();
        
        for(Case newCase : [SELECT Id,ChapterName__c, ChapterName__r.Name FROM Case WHERE Id IN : Trigger.newMap.keySet()])
        {
            if(newCase.ChapterName__c != Null)
            {
                if(caseSharingMap.containsKey(newCase.ChapterName__r.Name))
                    caseSharingMap.get(newCase.ChapterName__r.Name).add(newCase);
                else
                    caseSharingMap.put(newCase.ChapterName__r.Name, new List<Case>{newCase});
                
                
            }
        }
        
        
        for(Case newWish : Trigger.New) {
            
            
            if(newWish.RecordTypeId == partARecordTypeId && newWish.subject == 'Eligibility Review') {
                eligibilityReviewCaseList.add(newWish);
            }
            if(newWish.RecordTypeId == wishDeterminationRecordTypeId) 
            {
                if(newWish.isClosed != True && newWish.Status != 'Completed')
                {
                    parentIdsSet.add(newWish.ParentId);
                    wishChapterIdsMap.put(newWish.Id, newWish);
                    wishType = constant.wishDeterminationRT;
                }
            } 
            else if(newWish.RecordTypeId == wishPlanningRecordTypeId) {
                
                if(newWish.isClosed != True && newWish.Status != 'Completed')
                {
                    wishTypeSet.add(newWish.Wish_Type__c);
                    wishPlaningAnticipationSubCaseMap.put(newWish.Id, newWish);
                    parentIdsSet.add(newWish.ParentId);
                    wishChapterIdsMap.put(newWish.Id, newWish);
                    wishType = constant.wishPlanningAnticipationRT;
                }
            } 
            else if(newWish.RecordTypeId == wishAssistRecordTypeId) {
                if(newWish.isClosed != True && newWish.Status != 'Completed')
                {
                    parentIdsSet.add(newWish.ParentId);
                    wishChapterIdsMap.put(newWish.Id, newWish);
                    wishType = constant.wishAssistRT;
                }
            } 
            else if(newWish.RecordTypeId == wishGrantRecordTypeId) {
                if(newWish.Wish_Receipt_Items__c != Null && newWish.ParentId != Null){
                    wishReceiptMap.put(newWish.ParentId, newWish.Wish_Receipt_Items__c);
                }
                
                if(newWish.isClosed != True && newWish.Status != 'Completed')
                {
                    parentIdsSet.add(newWish.ParentId);
                    wishChapterIdsMap.put(newWish.Id, newWish);
                    wishType = constant.wishGrantRT;
                    wishGrantedSubCaseList.add(newWish);
                    wishGrantedSubCaseIdSet.add(newWish.ParentId);
                }
            } 
            else if(newWish.RecordTypeId == wishEffectRecordTypeId) {
                
                if(newWish.isClosed != True && newWish.Status != 'Completed')
                {
                    parentIdsSet.add(newWish.ParentId);
                    wishChapterIdsMap.put(newWish.Id, newWish);
                    wishType = constant.wishGrantRT;
                    
                }
            } 
            else if(newWish.RecordTypeId == parentWishRecordTypeId ){
                if(newWish.isClosed != True)
                {
                    parentCaseIntakeOwnerMap.put(newWish.Id, newWish);
                    parentIdsSet.add(newWish.Id);
                    chapterNames.add(newWish.ChapterName__c);
                    contactCaseDVAttachmentMergeMap.put(newWish.ContactId, newWish.Id);
                    
                }
            }
            
            cg__CaseFile__c PicFolder =new cg__CaseFile__c();
            PicFolder.cg__Case__c = newWish.Id;
            PicFolder.cg__Content_Type__c = 'Folder';
            PicFolder.cg__File_Name__c = 'Photos';
            PicFolder.cg__WIP__c = false;
            PicFolder.cg__Private__c= false;
            casefiles.add(PicFolder);
            
            cg__CaseFile__c DocFolder =new cg__CaseFile__c();
            DocFolder.cg__Case__c = newWish.Id  ;
            DocFolder.cg__Content_Type__c = 'Folder';
            DocFolder.cg__File_Name__c = 'Documents';
            DocFolder.cg__WIP__c = false;
            DocFolder.cg__Private__c= false;
            casefiles.add(DocFolder);
            
            cg__CaseFile__c VedioFolder =new cg__CaseFile__c();
            VedioFolder.cg__Case__c = newWish.Id  ;
            VedioFolder.cg__Content_Type__c = 'Folder';
            VedioFolder.cg__File_Name__c = 'Videos';
            VedioFolder.cg__WIP__c = false;
            VedioFolder.cg__Private__c= false;
            casefiles.add(VedioFolder);
            
            cg__CaseFile__c StaffFolder =new cg__CaseFile__c();
            StaffFolder.cg__Case__c = newWish.Id  ;
            StaffFolder.cg__Content_Type__c = 'Folder';
            StaffFolder.cg__File_Name__c = 'Staff - Private';
            StaffFolder.cg__WIP__c = false;
            StaffFolder.cg__Private__c= true;
            casefiles.add(StaffFolder);
            
            cg__CaseFile__c FinanceFolder =new cg__CaseFile__c();
            FinanceFolder.cg__Case__c = newWish.Id  ;
            FinanceFolder.cg__Content_Type__c = 'Folder';
            FinanceFolder.cg__File_Name__c = 'Financials';
            FinanceFolder.cg__WIP__c = false;
            FinanceFolder.cg__Private__c= true;
            casefiles.add(FinanceFolder);
        }
        
        
        if(eligibilityReviewCaseList.size() > 0) {
            CaseTriggerHandler.CreateDiagnosisVerificationReview(eligibilityReviewCaseList);
        }
        if (casefiles.size()>0){
            if(!Test.isRunningTest()) {
                insert casefiles;
            }
        }
        System.debug('Parent Wishes 01:' + parentIdsSet);
        System.debug('Parent Wishes 02:' + chapterNames);
        //Commented
        if (parentIdsSet.size()>0 && chapterNames.size()>0){
            CaseTriggerHandler.UpdateWishRecordIdentifier(parentIdsSet,chapterNames,parentWishRecordTypeId);
        } 
        if(wishChapterIdsMap.size()>0 && parentIdsSet.size()>0) {
            CaseTriggerHandler.createActionTracks(wishType,wishChapterIdsMap,parentIdsSet);
        }
        
        if(contactCaseDVAttachmentMergeMap.size() > 0) {
            //CaseTriggerHandler.InsertDVAttachment(contactCaseDVAttachmentMergeMap);
        }
        
        
        
        
        
        Map<Id, Case> nullMap = new Map<Id, Case>();
        Set<Id> dummySet = new Set<Id>();
        
        if(parentCaseIntakeOwnerMap.size() > 0 ) {
            CaseTriggerHandler.CaseTeamInTakeManager(parentCaseIntakeOwnerMap);
        }
        
        if(caseSharingMap.size() > 0){
            // ChapterStaffRecordSharing_AC.CaseSharing(caseSharingMap);
        }
        
        if(wishReceiptMap.size() > 0){
            for(Case currentCase :[SELECT Id,Wish_Receipt_Items__c FROM Case WHERE ID IN: wishReceiptMap.keySet()]){
                if(wishReceiptMap.containsKey(currentCase.id)){
                    currentCase.Wish_Receipt_Items__c = wishReceiptMap.get(currentCase.id);
                    wishReceiptCaseList.add(currentCase);
                }
            }
        }
        
        if(wishReceiptCaseList.size() > 0){
            update wishReceiptCaseList;
        }
        
    }
    //Used to create child wish for Parent wish
    //Used to submit parent wish for approval once the required volunteer assigend to Wish
    if(Trigger.isUpdate && Trigger.isAfter) 
    {
        String wishType = '';
        Set<Id> newCaseIdsSet = new Set<Id>();
        Set<Id> wishIdsSet = new Set<Id>();
        List<Case> PartAWishList = new List<Case>();
        List<Case> wishListForApprovalList = new List<Case>();
        list<Volunteer_Opportunity__c> volunteerOppList = new list<Volunteer_Opportunity__c>();
        
        Map<string,Chapter_Role__c> chapterRoleMap = new Map<string,Chapter_Role__c>();
        Set<Id> wishIds = new Set<Id>();
        Map<Id,Case> updateWishChildInfo = new Map<Id,Case>();
        Map<Id,String> approvedBudgetStatus = new Map<Id,String>();
        Set<Id> approvedBudgetIdsSet = new Set<Id>();
        Map<Id, case> interviewTaskParentIdMap = new Map<Id, Case>();
        Map<Id, case> presentationOpenTaskParentIdMap = new Map<Id, Case>();
        Map<Id, case> presentationCloseTaskParentIdMap = new Map<Id, Case>();
        Set<Id> interViewCloseTaskIdsSet = new Set<Id>();
        Set<Id> interViewOpenTaskIdsSet = new Set<Id>();
        Set<Id> presentationCloseTaskIdsSet = new Set<Id>();
        Set<Id> presentationOpenTaskIdsSet = new Set<Id>();
        Set<Id> ParentIdSet = new Set<Id>();
        
        Map<Id, Date> dueDateMap = new Map<Id, Date>();
        Map<Id, Case> updateAniticipationTaskMap = new Map<Id,Case>();
        Map<Id, Case> removeAniticipationTaskMap = new Map<Id,Case>();
        Map<Id,Case> UpdateAllOpenTasks = new Map<Id,Case>();
        Set<String> wishTypes = new Set<String>();
        Map<Id,Case> caseIdsMap = new Map<Id, Case>();
        Set<String> newWishTypeSet = new Set<String>();
        Set<Id> wishChildIdSet = new Set<Id>();
        Set<Id> caseTeamMemberParentIdSet = new Set<Id>();
        Set<Id> revokingContactIdSet = new Set<Id>();
        Set<Id> presentationIdsSet = new Set<Id>();
        Set<Id> endDateIdSet = new Set<Id>();
        List<Contact> updateWishchildList = new List<Contact>();
        Set<Id> conceptApprovalParentIdSet = new Set<Id>(); //Parent Id for closing Concept Approval task
        Set<string> updatedApprovedLeadInfoSet = new Set<string>();
        Set<string> updatedDnqLeadInfoSet = new Set<string>();
        String DiagnosisVerificationReviewRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Diagnosis Verification Review').getRecordTypeId();
        List<Case> diagnosisVerificationCaseList = new List<Case>();
        Set<Id> newWishClearanceSet = new Set<Id>();
        Set<Id> newMedicalSummarySet = new Set<Id>();
        Set<Id> newMedicalWishClearanceSet = new Set<Id>();
        Map<Id, Case> wishClearanceMap = new Map<Id, Case>();
        List<Case> childCreationWishList = new List<Case>();
        Map<Id, String> wishReceiptMap = new Map<Id, String>();
        Set<Id> parentCaseWishDeterminationSet = new Set<Id>();
        Constant_AC cons = new Constant_AC();
        list<Case> wishReceiptCaseList = new list<Case>();
        String parentRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(cons.parentWishRT).getRecordTypeId();
        String grantingWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(cons.wishGrantRT).getRecordTypeId();
        Map<Id, Id> newCaseOwnerMap  = new Map<Id, Id>();
        Map<Id, Id> caseContactMap = new Map<Id, Id>(); //Used to hold Case & Contact Id if the status changed from "Completed" or "Closed" to other status
        Set<Id> presentatationIdentifySet = new Set<Id>();
        Set<Id> volunteerManagerIdSet = new Set<Id>();
        Set<Id> wishCoordinatorIdSet = new Set<Id>();
        List<case> wishGrantedIdList = new List<case>();
        Map<Id,Case> readyToAssignParentCaseMap = new Map<Id,Case>(); //Used to hold the case info if the case status changed to "Ready to Assign".
        Set<Id> readtToAssignChapterIdSet = new Set<Id>(); //Used to hold the chapter account Id when the case status changed to "Ready to Assign".
        Map<Id,Case> updateVolunteerManagerCaseTeamMap = new Map<Id, Case>(); // Used to hold the case for updating volunteer manager role to "Volunteer Manager InActive" when case status is "Ready to Assign"
        Set<Id> wishCoordinatorMemberUpdateSet = new Set<Id>();
        Map<Id, Case> parentWishInfoMap = new Map<Id, Case>();
        Map<Id, Case> wishPlanningAndGrantinTaskParentMap = new Map<Id, Case>();
        Set<Id> TaskParentIdSet = new Set<Id>();
        Set<Id> caseParentIdSet = new Set<Id>();
        for(Case caseMemberCheck : Trigger.New) {
            
            //Used to create wish determination type tasks when the status is updated to "Ready to Interview"
            if((caseMemberCheck.Status == 'Ready to Interview' && Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Ready to Assign' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'DNQ' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Inactive' 
                || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Hold' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Closed') && caseMemberCheck.RecordTypeId == parentWishRecordTypeId) {
                    
                    parentWishInfoMap.put(caseMemberCheck.Id, caseMemberCheck);
                }
            // Used to Open all sub cases when the status from "DNQ","Inactive","Hold" and "Closed".
            if((caseMemberCheck.Status == 'Ready to Interview' || caseMemberCheck.Status == 'Wish Determined' || caseMemberCheck.Status == 'Wish Design' || caseMemberCheck.Status == 'Wish Scheduled' || caseMemberCheck.Status == 'Granted') && 
               (Trigger.oldMap.get(caseMemberCheck.Id).Status == 'DNQ' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Inactive' 
                || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Hold' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Closed')){
                    
                    caseParentIdSet.add(caseMemberCheck.id);
                }
            
            if(((caseMemberCheck.Status == 'Ready to Interview') && Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Ready to Assign' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'DNQ' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Inactive' 
                || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Hold' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Closed') && caseMemberCheck.RecordTypeId == parentWishRecordTypeId) {
                    parentWishInfoMap.put(caseMemberCheck.Id, caseMemberCheck);
                }
            
            //Used to close all the System genareated  task when the status is updated to "DNQ", "Closed", "Inactive" , "Hold".'
            if(caseMemberCheck.Status == 'DNQ' || caseMemberCheck.Status == 'Closed' || caseMemberCheck.Status == 'Hold' ||
               caseMemberCheck.Status == 'Inactive' && caseMemberCheck.RecordTypeId == parentWishRecordTypeId ) {
                   TaskParentIdSet.add(caseMemberCheck.Id);
               } 
            
            
            
            //Used to create wish planning and wish granting type tasks when the status is updated to "Wish Determined and within policy"
            /*if(caseMemberCheck.Status == 'Wish Determined' && (Trigger.oldMap.get(caseMemberCheck.Id).Status != caseMemberCheck.Status || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'DNQ' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Hold' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Inactive' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Closed') && caseMemberCheck.RecordTypeId == parentWishRecordTypeId && caseMemberCheck.Sub_Status__c == 'Within Policy') {
wishPlanningAndGrantinTaskParentMap.put(caseMemberCheck.Id, caseMemberCheck);
} else if(caseMemberCheck.Sub_Status__c == 'Within Policy' && Trigger.oldMap.get(caseMemberCheck.Id).Sub_Status__c != caseMemberCheck.Sub_Status__c && caseMemberCheck.RecordTypeId == parentWishRecordTypeId && caseMemberCheck.Status == 'Wish Determined') {
wishPlanningAndGrantinTaskParentMap.put(caseMemberCheck.Id, caseMemberCheck);
}*/
            
            if(((caseMemberCheck.Status == 'Wish Determined' && caseMemberCheck.Sub_Status__c == 'Within Policy') && (caseMemberCheck.Status != Trigger.oldMap.get(caseMemberCheck.Id).Status || caseMemberCheck.Sub_Status__c != Trigger.oldMap.get(caseMemberCheck.Id).Sub_Status__c)) || (Trigger.oldMap.get(caseMemberCheck.Id).Status != caseMemberCheck.Status && (Trigger.oldMap.get(caseMemberCheck.Id).Status == 'DNQ' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Hold' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Inactive' || Trigger.oldMap.get(caseMemberCheck.Id).Status == 'Closed')) && caseMemberCheck.RecordTypeId == parentWishRecordTypeId) {
                wishPlanningAndGrantinTaskParentMap.put(caseMemberCheck.Id, caseMemberCheck);
            }
            
            /*if(((caseMemberCheck.Status == 'Wish Determined' || caseMemberCheck.Sub_Status__c == 'Within Policy') && (caseMemberCheck.Status != Trigger.oldMap.get(caseMemberCheck.Id).Status || caseMemberCheck.Sub_Status__c != Trigger.oldMap.get(caseMemberCheck.Id).Sub_Status__c))) {
wishPlanningAndGrantinTaskParentMap.put(caseMemberCheck.Id, caseMemberCheck);
}*/
            
            if(caseMemberCheck.Status == 'Ready to Assign' && caseMemberCheck.Status != Trigger.oldMap.get(caseMemberCheck.Id).Status) {
                updateVolunteerManagerCaseTeamMap.put(caseMemberCheck.Id, caseMemberCheck);
                volunteerManagerIdSet.add(caseMemberCheck.Id);
            } else if((caseMemberCheck.Status == 'Ready to Assign' || caseMemberCheck.Status == 'Ready to Interview') && caseMemberCheck.OwnerId != Trigger.oldMap.get(caseMemberCheck.Id).OwnerId) {
                updateVolunteerManagerCaseTeamMap.put(caseMemberCheck.Id, caseMemberCheck);
                volunteerManagerIdSet.add(caseMemberCheck.Id);
            }
            
            if(caseMemberCheck.Status != Trigger.oldMap.get(caseMemberCheck.Id).Status && caseMemberCheck.Status == 'Wish Determined') {
                updateVolunteerManagerCaseTeamMap.put(caseMemberCheck.Id, caseMemberCheck);
                wishCoordinatorIdSet.add(caseMemberCheck.Id);
            } else if((caseMemberCheck.OwnerId != Trigger.oldMap.get(caseMemberCheck.Id).OwnerId) && (caseMemberCheck.Status == 'Wish Determined' || caseMemberCheck.Status == 'Wish Design' || caseMemberCheck.Status == 'Wish Scheduled' || caseMemberCheck.Status == 'Budget Approval - Approved' || caseMemberCheck.Status == 'Budget Approval - Submitted')) {
                updateVolunteerManagerCaseTeamMap.put(caseMemberCheck.Id, caseMemberCheck);
                wishCoordinatorIdSet.add(caseMemberCheck.Id);
            }
            
            
            
            if((caseMemberCheck.Status != 'Closed' && caseMemberCheck.Status != 'Completed') && (trigger.oldMap.get(caseMemberCheck.Id).Status == 'Closed' || trigger.oldMap.get(caseMemberCheck.Id).Status == 'Completed')) {
                caseContactMap.put(caseMemberCheck.Id, caseMemberCheck.ContactId);
            }
            if(caseMemberCheck.OwnerId != Trigger.oldMap.get(caseMemberCheck.Id).OwnerId && caseMemberCheck.RecordTypeId == parentRecordTypeId) {
                newCaseOwnerMap.put(caseMemberCheck.Id, caseMemberCheck.OwnerId);
            }
            
            
            
            if(Trigger.oldMap.get(caseMemberCheck.Id).Wish_Type__c != caseMemberCheck.Wish_Type__c  && CaseMemberCheck.RecordTypeid == parentWishRecordTypeId) {
                caseIdsMap.put(caseMemberCheck.Id, caseMemberCheck);
                newWishTypeSet.add(caseMemberCheck.Wish_Type__c);
            }
            
            if(caseMemberCheck.RecordTypeId == grantingWishRecordTypeId && caseMemberCheck.Wish_Receipt_Items__c != Null && 
               caseMemberCheck.Wish_Receipt_Items__c != trigger.oldMap.get(caseMemberCheck.id).Wish_Receipt_Items__c){
                   wishReceiptMap.put(caseMemberCheck.ParentId, caseMemberCheck.Wish_Receipt_Items__c);
                   
               }
            
            
            if(caseMemberCheck.Status == 'Escalated' && caseMemberCheck.RecordTypeId == diagnosisVerificationRT && caseMemberCheck.Status != Trigger.oldMap.get(caseMemberCheck.Id).Status && caseMemberCheck.MAC_Email__c != Null) {
                diagnosisVerificationCaseList.add(caseMemberCheck);
            }
            
            if((caseMemberCheck.Status == 'Approved - Chapter Staff' && trigger.oldMap.get(caseMemberCheck.Id).Status != 'Approved - Chapter Staff') || (caseMemberCheck.Status == 'Approved - Chapter Medical Advisor' && trigger.oldMap.get(caseMemberCheck.Id).Status != 'Approved - Chapter Medical Advisor') || 
               (caseMemberCheck.Status == 'Approved - National Staff' && trigger.oldMap.get(caseMemberCheck.Id).Status != 'Approved - National Staff')||(caseMemberCheck.Status == 'Approved - National Medical Council' && trigger.oldMap.get(caseMemberCheck.Id).Status != 'Approved - National Medical Council') && 
               CaseMemberCheck.RecordTypeid == DiagnosisVerificationReviewRecordTypeId )
            {
                updatedApprovedLeadInfoSet.add(caseMemberCheck.Lead__c);
            }
            else if((caseMemberCheck.Status == 'DNQ - Chapter Staff' || caseMemberCheck.Status == 'DNQ - Chapter Medical Advisor' || caseMemberCheck.Status == 'DNQ - National Staff'||
                     caseMemberCheck.Status == 'DNQ - National Medical Council')&& CaseMemberCheck.RecordTypeid == DiagnosisVerificationReviewRecordTypeId && trigger.oldMap.get(caseMemberCheck.Id).Status != caseMemberCheck.Status){
                         updatedDnqLeadInfoSet.add(caseMemberCheck.Lead__c);
                         
                     }
            
            if(updatedApprovedLeadInfoSet.size()>0 || updatedDnqLeadInfoSet.size()>0 ){
                
                CaseTriggerHandler.updateLeadStatus(updatedApprovedLeadInfoSet,updatedDnqLeadInfoSet);
                
            }
            
            
            if(caseMemberCheck.Sub_Status__c == 'Abandoned' && Trigger.Oldmap.get(caseMemberCheck.id).Sub_Status__c!= 'Abandoned' 
               && CaseMemberCheck.isClosed == True)
            {
                UpdateAllOpenTasks.put(caseMemberCheck.id,CaseMemberCheck);
            }
            
            
            //1.Used to update "Wish Determination" task due date when "Interview Date" field is updated
            //2.Used to Close & Open "Enter Interview" task based on interview date entered and cleard 
            if(CaseMemberCheck.Interview_date__c != null && Trigger.oldMap.get(CaseMemberCheck.id).Interview_date__c == null && CaseMemberCheck.RecordTypeid == parentWishRecordTypeId) {
                interViewCloseTaskIdsSet.add(caseMemberCheck.Id);
                interviewTaskParentIdMap.put(caseMemberCheck.Id,caseMemberCheck);
                dueDateMap.put(CaseMemberCheck.Id,CaseMemberCheck.Interview_date__c);
            } else if(CaseMemberCheck.Interview_date__c == null && Trigger.oldMap.get(CaseMemberCheck.id).Interview_date__c != null && CaseMemberCheck.RecordTypeid == parentWishRecordTypeId) {
                dueDateMap.put(CaseMemberCheck.Id,CaseMemberCheck.Interview_date__c);
                interViewOpenTaskIdsSet.add(caseMemberCheck.Id);
                interviewTaskParentIdMap.put(caseMemberCheck.Id,caseMemberCheck);
            } else if(CaseMemberCheck.Interview_date__c != null && Trigger.oldMap.get(CaseMemberCheck.id).Interview_date__c != null && Trigger.oldMap.get(CaseMemberCheck.id).Interview_date__c != CaseMemberCheck.Interview_date__c &&  CaseMemberCheck.RecordTypeid == parentWishRecordTypeId) {
                dueDateMap.put(CaseMemberCheck.Id,CaseMemberCheck.Interview_date__c);
            }
            
            
            //Used to remove the access for Volunteer user to Wish, when the parent wish is completed.
            ////Used to update child cases if Parent Case Status is changed to 'Completed' or 'Closed'
            if((CaseMemberCheck.Status == 'Completed' || CaseMemberCheck.Status == 'Closed' || CaseMemberCheck.Status == 'DNQ')  && (Trigger.oldMap.get(CaseMemberCheck.Id).Status != CaseMemberCheck.Status && CaseMemberCheck.RecordTypeId == parentRecordTypeId) )
            {
                caseTeamMemberParentIdSet.add(CaseMemberCheck.Id);
                revokingContactIdSet.add(CaseMemberCheck.ContactId);
            }
            
            // Wish Granted task
            
            if(CaseMemberCheck.Presentation_Date__c != null && Trigger.oldMap.get(CaseMemberCheck.id).Presentation_Date__c != CaseMemberCheck.Presentation_Date__c && CaseMemberCheck.RecordTypeId == wishGrantRecordTypeId)
            {
                presentatationIdentifySet.add(CaseMemberCheck.parentId);
                presentationIdsSet.add(caseMemberCheck.ParentId);
                presentationCloseTaskIdsSet.add(caseMemberCheck.ParentId);
                presentationCloseTaskParentIdMap.put(caseMemberCheck.ParentId,caseMemberCheck);
            } if(CaseMemberCheck.Presentation_Date__c == null && Trigger.oldMap.get(CaseMemberCheck.id).Presentation_Date__c != CaseMemberCheck.Presentation_Date__c && CaseMemberCheck.RecordTypeId == wishGrantRecordTypeId) {
                presentatationIdentifySet.add(CaseMemberCheck.parentId);
                presentationIdsSet.add(caseMemberCheck.ParentId);
                presentationOpenTaskIdsSet.add(caseMemberCheck.ParentId);
                presentationCloseTaskParentIdMap.put(caseMemberCheck.ParentId,caseMemberCheck);
            }
            
            // Wish Granted task
            if(CaseMemberCheck.End_Date__c != null && Trigger.oldMap.get(CaseMemberCheck.id).End_Date__c != CaseMemberCheck.End_Date__c && CaseMemberCheck.RecordTypeid == parentWishRecordTypeId)
            {
                endDateIdSet.add(caseMemberCheck.Id);
                presentationCloseTaskIdsSet.add(caseMemberCheck.Id);
                presentationCloseTaskParentIdMap.put(caseMemberCheck.Id,caseMemberCheck);
            }
            
            
            
            
            //New medical summary needed
            if((CaseMemberCheck.Start_Date__c != Trigger.oldMap.get(CaseMemberCheck.Id).Start_Date__c) && (CaseMemberCheck.Wish_Type__c == 'Cruise - Celebrity/Royal' || CaseMemberCheck.Wish_Type__c == 'Cruise - Disney' || CaseMemberCheck.Wish_Type__c == 'Cruise - Other'
                                                                                                           || CaseMemberCheck.Wish_Type__c == 'Travel - International' || CaseMemberCheck.Wish_Type__c == 'Travel - Hawai' || CaseMemberCheck.Wish_Type__c == 'Trailer/Camper'
                                                                                                           || CaseMemberCheck.Wish_Type__c == 'Travel - Other')) {
                                                                                                               if((CaseMemberCheck.Start_Date__c == null) || ((CaseMemberCheck.Start_Date__c != null) && (CaseMemberCheck.Child_s_Medical_Summary_received_date__c == null || CaseMemberCheck.Child_s_Medical_Summary_received_date__c.daysBetween(CaseMemberCheck.Start_Date__c) > 30))) {
                                                                                                                   newMedicalSummarySet.add(CaseMemberCheck.Id);
                                                                                                                   wishClearanceMap.put(CaseMemberCheck.Id, CaseMemberCheck);
                                                                                                               }
                                                                                                           }
            
            
            //New wish clearance needed
            
            if(CaseMemberCheck.End_Date__c != null && CaseMemberCheck.End_Date__c != Trigger.oldMap.get(CaseMemberCheck.Id).End_Date__c) {
                if((CaseMemberCheck.Wish_Clearance_Received_Date__c == null) || (Date.today().monthsBetween(CaseMemberCheck.Wish_Clearance_Received_Date__c) > 6)) {
                    newWishClearanceSet.add(CaseMemberCheck.Id);
                    wishClearanceMap.put(CaseMemberCheck.Id, CaseMemberCheck);
                }
                
                if(CaseMemberCheck.Wish_Type__c == 'Celebrity - Domestic Travel' || CaseMemberCheck.Wish_Type__c == 'Celebrity - Local' || CaseMemberCheck.Wish_Type__c == 'Celebrity-International Travel'
                   || CaseMemberCheck.Wish_Type__c == 'Travel - International' || CaseMemberCheck.Wish_Type__c == 'Travel - Hawai' || CaseMemberCheck.Wish_Type__c == 'Trailer/Camper'
                   || CaseMemberCheck.Wish_Type__c == 'Travel - Other') {
                       if((CaseMemberCheck.Child_s_Medical_Summary_received_date__c == null) || ((Date.today().monthsBetween(CaseMemberCheck.Child_s_Medical_Summary_received_date__c) > 6))) {
                           newMedicalWishClearanceSet.add(CaseMemberCheck.Id);
                           wishClearanceMap.put(CaseMemberCheck.Id, CaseMemberCheck);
                       }
                       
                   }
            }
            
            //Open all sub cases when 2 wish granters are assigned to parent wish
            if(CaseMemberCheck.Case_Member_Count__c == 2 && CaseMemberCheck.Case_Member_Count__c != Trigger.oldMap.get(CaseMemberCheck.Id).Case_Member_Count__c) {
                if(CaseMemberCheck.RecordTypeId == parentWishRecordTypeId) {
                    childCreationWishList.add(CaseMemberCheck);
                    parentCaseWishDeterminationSet.add(CaseMemberCheck.Id);
                    wishType = 'Wish Determination'+'-'+wishDeterminationRecordTypeId;
                }
            }
            
            if(CaseMemberCheck.End_Date__c == null && Trigger.oldMap.get(CaseMemberCheck.id).End_Date__c != CaseMemberCheck.End_Date__c && CaseMemberCheck.RecordTypeid == parentWishRecordTypeId) {
                endDateIdSet.add(caseMemberCheck.Id);
                presentationOpenTaskIdsSet.add(caseMemberCheck.Id);
                presentationCloseTaskParentIdMap.put(caseMemberCheck.Id,caseMemberCheck);
            }
            
            //For closing concept approval task when wish status set to Wish Determined within policy
            if((CaseMemberCheck.Status == 'Wish Determined' && CaseMemberCheck.Sub_Status__c == 'Within Policy') && (CaseMemberCheck.Status != Trigger.oldMap.get(CaseMemberCheck.Id).Status || CaseMemberCheck.Sub_Status__c != Trigger.oldMap.get(CaseMemberCheck.Id).Sub_Status__c)) {
                conceptApprovalParentIdSet.add(CaseMemberCheck.Id);
            }
            
            
            if(caseMemberCheck.Budget_Approval_Status__c == 'Approved'  && caseMemberCheck.Budget_Approval_Status__c != Trigger.oldMap.get(caseMemberCheck.Id).Budget_Approval_Status__c && caseMemberCheck.RecordTypeId == wishPlanningRecordTypeId) {
                approvedBudgetIdsSet.add(caseMemberCheck.ParentId);
                approvedBudgetStatus.put(caseMemberCheck.ParentId, caseMemberCheck.Budget_Approval_Status__c);
                system.debug('----Budgetapproved Status'+ caseMemberCheck.ParentId);
            }
            
            
            if(CaseMemberCheck.Status == 'Granted' && Trigger.oldMap.get(CaseMemberCheck.id).Status != 'Granted' && parentWishRecordTypeId == CaseMemberCheck.RecordTypeid)
            {
                wishIds.add(CaseMemberCheck.id);
            }
            
            
            
            if(caseMemberCheck.Update_Wish_Child_Form_Info__c == True && Trigger.oldMap.get(caseMemberCheck.id).Update_Wish_Child_Form_Info__c != True)
            {
                updateWishChildInfo.put(caseMemberCheck.id,caseMemberCheck);
            } 
            
            if(caseMemberCheck.Status != trigger.oldMap.get(caseMemberCheck.Id).Status && caseMemberCheck.RecordTypeId == partARecordTypeId && caseMemberCheck.Lead__c != Null){
                if(caseMemberCheck.Status == 'Open' || caseMemberCheck.Status == 'Escalated')
                    PartAWishList.add(caseMemberCheck);
            }
            
            if(caseMemberCheck.RecordTypeId == parentWishRecordTypeId && caseMemberCheck.Anticipated_Start_Date__c== Null &&
               Trigger.oldMap.get(caseMemberCheck.id).Anticipated_Start_Date__c!= Null)
            {
                removeAniticipationTaskMap.put(caseMemberCheck.id,caseMemberCheck);
            } else if(caseMemberCheck.RecordTypeId == parentWishRecordTypeId && caseMemberCheck.Anticipated_Start_Date__c!= Null
                      && caseMemberCheck.Anticipated_Start_Date__c!= Trigger.oldMap.get(caseMemberCheck.id).Anticipated_Start_Date__c)
            {
                updateAniticipationTaskMap.put(caseMemberCheck.id,caseMemberCheck);
                wishTypes.add(caseMemberCheck.wish_type__c);
            }
            
            
            
            //For creating 2 volunteer opportunity record when the case status changed to "Ready to Assign" from "Qualified".
            if((caseMemberCheck.Status == 'Ready to Assign') && trigger.oldmap.get(caseMemberCheck.id).Status ==  'Qualified' && caseMemberCheck.RecordTypeId == parentWishRecordTypeId){
                if(RecursiveTriggerHandler.isFirstTime == true ) {
                    readyToAssignParentCaseMap.put(caseMemberCheck.Id,caseMemberCheck);
                    readtToAssignChapterIdSet.add(caseMemberCheck.ChapterName__c);
                } 
            }
            
            //if Status is 'Granted' then populate the hiddengranteddate in Contact
            if(caseMemberCheck.Status == 'Granted' && Trigger.oldmap.get(caseMemberCheck.id).Status != 'Granted' && caseMemberCheck.ContactId != null && caseMemberCheck.RecordTypeId == parentWishRecordTypeId){
                wishGrantedIdList.add(caseMemberCheck);
            }
        } 
        if(wishGrantedIdList.size() > 0){
            CaseTriggerHandler.updateGrantedDate(wishGrantedIdList);
        }
        
        if(TaskParentIdSet.size() > 0){
            CaseTriggerHandler.closeAllOpenTask(TaskParentIdSet);
        }
        
        if(caseParentIdSet.size() > 0){
            CaseTriggerHandler.UpdateSubCaseStatus(caseParentIdSet);
        }
        
        //Used to update Case Team Role & to create new Case Team Member based on case Status
        List<Case> nullCase = new List<Case>();
        if(updateVolunteerManagerCaseTeamMap.size() > 0) {
            CaseTriggerHandler.CreateAndUpdateUserCaseTeamRole(updateVolunteerManagerCaseTeamMap, volunteerManagerIdSet, wishCoordinatorIdSet);
        }
        if(caseContactMap.size() > 0 ) {
            CaseTriggerHandler.chageAccessPermission(caseContactMap);
        }
        if(newCaseOwnerMap.size() > 0) {
            CaseTriggerHandler.changeChildCasesOwner(newCaseOwnerMap);
            CaseTriggerHandler.updateInkindDonationWishOwner(newCaseOwnerMap);
        }
        
        //Create task for wish planning and wish granting
        if(wishPlanningAndGrantinTaskParentMap.size() > 0) {
            System.debug('Task Creation Block');
            CaseTriggerHandler.wishPlaningAnticipationTaskCreation(wishPlanningAndGrantinTaskParentMap);
            CaseTriggerHandler.wishGrantedSubCaseTaskCreation(wishPlanningAndGrantinTaskParentMap);
        }
        if(wishClearanceMap.size() > 0 && (newWishClearanceSet.Size() > 0 || newMedicalSummarySet.Size() > 0 || newMedicalWishClearanceSet.Size() > 0)) {
            CaseTriggerHandler.wishClearanceTask(wishClearanceMap,newWishClearanceSet,newMedicalSummarySet,newMedicalWishClearanceSet);
        }
        
        //Used to create wish determination tasks that stored under chapter action track
        if(parentWishInfoMap.size() > 0) {
            CaseTriggerHandler.wishDeterminationSubCaseTaskCreation(parentWishInfoMap);
        }
        
        // Volunteer Opportunity creation under the parent case when status is changed as Ready To Assign ------------------ */
        
        
        if(wishChildIdSet.size() >0){
            
            for(Contact dbWishchildCon : [SELECT Id,Name,Publicity_OK__c FROM Contact WHERE Id IN: wishChildIdSet]){
                
                Contact newCon = new Contact();
                newCon.Id = dbWishchildCon.Id;
                newCon.Publicity_OK__c = 'YES';
                updateWishchildList.add(newCon);
            }
        }
        
        if(wishReceiptMap.size() > 0){
            for(Case currentCase :[SELECT Id,Wish_Receipt_Items__c FROM Case WHERE ID IN: wishReceiptMap.keySet()]){
                if(wishReceiptMap.containsKey(currentCase.id)){
                    currentCase.Wish_Receipt_Items__c = wishReceiptMap.get(currentCase.id);
                    wishReceiptCaseList.add(currentCase);
                }
            }
        }
        
        
        if(wishReceiptCaseList.size() > 0){
            update wishReceiptCaseList;
        }
        if(updateWishchildList.size() > 0){
            update updateWishchildList;
        }
        if(caseIdsMap.size() > 0) {
            CaseTriggerHandler.deleteAnticipationTask(caseIdsMap,newWishTypeSet);
        }
        if(updateAniticipationTaskMap.size() > 0 || removeAniticipationTaskMap.size() >0)
        {
            CaseTriggerHandler.updateAnticipationTasks(updateAniticipationTaskMap,removeAniticipationTaskMap,wishTypes);
        }
        //if(ParentIdSet.size() > 0)
        //CaseTriggerHandler.CreateSubCases(ParentIdSet);
        
        if(UpdateAllOpenTasks.size() > 0)
        {
            CaseTriggerHandler.UpdateTasksAsAbondoned(UpdateAllOpenTasks);
        }
        
        if(diagnosisVerificationCaseList.size() > 0) {
            CaseTriggerHandler.sendEmailToNationalMACTeam(diagnosisVerificationCaseList);
        }
        
        //Used to update caseTeam Member Role
        if(caseTeamMemberParentIdSet.size() > 0 && revokingContactIdSet.size() > 0) {
            CaseTriggerHandler.revokeWishPermissionForVolunteers(caseTeamMemberParentIdSet, revokingContactIdSet);
        }
        
        if(approvedBudgetIdsSet.size() > 0 && approvedBudgetStatus.size() > 0) {
            CaseTriggerHandler.matchBudgetData(approvedBudgetIdsSet, approvedBudgetStatus);
        }
        
        
        
        if(PartAWishList.size() > 0){
            CaseTriggerHandler.UpdateLeadStatus(PartAWishList);
        }
        
        if(wishIds.size() > 0)
        {
            // CaseTriggerHandler.UpdateVolunteerWishGranted(wishIds);
            CaseTriggerHandler.grantedWishCount(wishIds);
        }
        
        if(updateWishChildInfo.size() > 0)
        {
            WishChildFormValUpdate_AC.UpdateWishChildandWishFamily(updateWishChildInfo);
            //casehandler.casecreate(updateWishChildInfo);
        }
        
        if(childCreationWishList.size()>0) {
            CaseTriggerHandler.createChildWish(childCreationWishList, wishType, parentCaseWishDeterminationSet);
        }
        
        if(dueDateMap.size() > 0 ) {
            CaseTriggerHandler.updateDeterminationTaskDueDates(dueDateMap);
        }
        if((interViewCloseTaskIdsSet.size() > 0 || interViewOpenTaskIdsSet.size() > 0) && interviewTaskParentIdMap.size() > 0) {
            CaseTriggerHandler.inTerviewTask(interViewCloseTaskIdsSet, interViewOpenTaskIdsSet, interviewTaskParentIdMap);
        }
        
        if(interViewCloseTaskIdsSet.size() > 0){
            CaseTriggerHandler.updateWishDeterminationInterviewDateNotSet(interViewCloseTaskIdsSet);
        }
        
        if(interViewOpenTaskIdsSet.size() > 0){
            CaseTriggerHandler.updateWishDeterminationInterviewDateNotSet(interViewOpenTaskIdsSet);
        }
        
        //Wish Granted Task
        if((presentationCloseTaskIdsSet.size() > 0 || presentationOpenTaskIdsSet.size() > 0) && presentationCloseTaskParentIdMap.size() > 0) {
            CaseTriggerHandler.wishGrantedPresentationTask(presentationCloseTaskIdsSet, presentationOpenTaskIdsSet, presentationCloseTaskParentIdMap,presentationIdsSet,endDateIdSet,presentatationIdentifySet);
        }
        
        //Concept Approval Task auto close
        if(conceptApprovalParentIdSet.size() > 0) {
            CaseTriggerHandler.autoCloseTask(conceptApprovalParentIdSet);
        }
        
        List<Id> closedCaseIdList = new List<Id>();
        List<Id> completedCaseIdList=new List<Id>();
        for(Case currRec:trigger.new){
            if( (currRec.Status == 'Completed' || currRec.Status == 'Closed') && (trigger.oldMap.get(currRec.id).Status != 'Completed' || trigger.oldMap.get(currRec.id).Status != 'Closed')){
                completedCaseIdList.add(currRec.id);
                if(currRec.RecordTypeId == parentWishRecordTypeId)
                    closedCaseIdList.add(currRec.Id);
            }
        }
        if(completedCaseIdList.size() > 0 && completedCaseIdList != Null){
            CaseTriggerHandler.updateVolunteerOpportunityStatus(completedCaseIdList);
        }
        //Used to create 2 volunteer opportunity when wish status change to 'Ready to Assign'
        if(readyToAssignParentCaseMap.size()>0 && readtToAssignChapterIdSet.size() > 0){
            CaseTriggerHandler.createVolunteerOpportunity(readyToAssignParentCaseMap, readtToAssignChapterIdSet);
        }
        //Update Open volunteer Opportunity as Inactive
        
        if(closedCaseIdList.Size() > 0) 
            CaseTriggerHandler.updateVolunteerOpportunityasInactive(closedCaseIdList);
    }
}