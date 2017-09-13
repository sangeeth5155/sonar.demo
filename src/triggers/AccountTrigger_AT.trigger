/***************************************************************************************************
Author      : MST Solutions
Date        : 10/15/2016
Description : AccountTrigger_AT is used to assign the chapter account name for inkind account when volunteer creates inkind account.
After insert In-Kind account it is automatically send for approval to wish co-ordinator of the associated chapter
*****************************************************************************************************/
trigger AccountTrigger_AT on Account (before insert,after insert,after update,before update) {
    //Before insert update wish co-ordinator email value to the hidden field to send emai alert
    if(trigger.isBefore && trigger.isInsert)
    {
        string userId = UserInfo.getUserId();
        string contactId;
        list<User> userList = [SELECT Id,ContactId FROM User WHERE Id =: userId AND ContactId != Null limit 1];
        list<Contact> contactList;
        if(userList.Size() == 1){
            contactId = userList[0].ContactId;
            contactList = [SELECT ID,AccountId,Account.Wish_Co_ordinator__c FROM Contact WHERE ID =: contactId];
        }
        set<id> chapterAccountIdsSet = new set<id>();
        map<id,string> chapterMap = new map<id,string>();
        Id inKindDonorsAccountRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('In Kind Donors').getRecordTypeId();
        for(Account currentAccount : Trigger.new){
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
            {
                if(contactId != Null){
                    currentAccount.Chapter_Name__c = contactList[0].AccountId;
                }
                if(currentAccount.RecordTypeId == inKindDonorsAccountRecordTypeId && currentAccount.Chapter_Name__c != Null){
                    chapterAccountIdsSet.add(currentAccount.Chapter_Name__c);
                } 
            }
            
            
        }
        if(chapterAccountIdsSet.size() > 0){
            for(Account chapterAccount : [SELECT Id,Wish_Co_ordinator__c,Wish_Co_ordinator__r.Email FROM Account WHERE Id IN: chapterAccountIdsSet AND Wish_Co_ordinator__c != Null]){
                chapterMap.put(chapterAccount.Id,chapterAccount.Wish_Co_ordinator__r.Email);
            }
        }
        
        for(Account inKindAccount : trigger.new){
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
            {
                if(inKindAccount.RecordTypeId == inKindDonorsAccountRecordTypeId && inKindAccount.Chapter_Name__c != Null && chapterMap.containsKey(inKindAccount.Chapter_Name__c)){
                    inKindAccount.Wish_Co_ordinator_Hidden_Email__c = chapterMap.get(inKindAccount.Chapter_Name__c);
                }
            }
        }
        
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        Constant_AC cons = new Constant_AC();
        Id housHoldAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(cons.HouseholdRT).getRecordTypeId();
        Id wishChildRT = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(cons.contactWishChildRT).getRecordTypeId();
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Id> wishChildMap = new Map<Id,Id>();
        List<Account> primaryContactUpdateList = new List<Account>();
        
        for(Account newAccount : trigger.new){
            if(newAccount.RecordTypeId == housHoldAccountRTId && (Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)){
                accountIdSet.add(newAccount.Id);
            }
        }
        
        if(accountIdSet.size() > 0){
            for(contact dbWishChild : [SELECT Id,Name,AccountId,RecordTypeId FROM Contact WHERE AccountId IN :accountIdSet AND RecordTypeId =: wishChildRT Limit 1]){
                wishChildMap.put(dbWishChild.AccountId,dbWishChild.Id);
            }
        }
        
        if(wishChildMap.size() > 0){
            for(Account newAccount : trigger.new){
                system.debug('Contins>>>>'+wishChildMap.containsKey(newAccount.Id));
                system.debug('RecordType Id '+newAccount.RecordTypeId +'housHoldAccountRTId '+housHoldAccountRTId );
                if(newAccount.RecordTypeId == housHoldAccountRTId && wishChildMap.containsKey(newAccount.Id) &&  (Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)){
                    newAccount.npe01__One2OneContact__c = wishChildMap.get(newAccount.Id);
                }
            }
            
        }
    }
    
    
    
    //After insert trigger to fire the approval process once inkind donor account is created and sahre the record to group based on the chapter name
    if(trigger.isAfter && trigger.isInsert)
    {   
        Set<Id> chaptterAccountIdSet = new Set<Id> ();
        Set<Id> inKindDonorAccountSet = new Set<Id>();
        Map<Id,Id> chaptterMap = new Map<Id,Id>();
        Map<Id,Id> volunteerManagersMap = new map<Id,Id>();
        Constant_AC cons = new Constant_AC();
        Map<Id, String> chapterNameMap = new Map<Id, String>();
        Map<String,Id> publicGroupMap = new Map<String,Id>();
        List<AccountShare> accountShareList = New List<AccountShare>();
        
        Id groupId;
        Id inKindDonorsAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('In Kind Donors').getRecordTypeId();
        Id chapterAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(cons.chapterRT).getRecordTypeId();
        Id housHoldAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(cons.HouseholdRT).getRecordTypeId();
        Id wishChildRT = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(cons.contactWishChildRT).getRecordTypeId();
        Map<String,List<Account>> accountMapforSharing = new Map<String, List<Account>>();
        Set<String> chapterIds = new Set<String>();
        Set<Id> ownerIds = new Set<Id>();
        Map<Id, String> userRoleMap = new Map<Id, String>();
        
      /*  for(Account currAccount : Trigger.new)
        {
            ownerIds.add(currAccount.OwnerId);
        }
        
        if(ownerIds.size() > 0)
            userRoleMap = UserRoleUtility.getUserRole(ownerIds);*/
        
        for(Account inKindAccount : Trigger.new)
        {
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
            {    
                if(inKindAccount.RecordTypeId == inKindDonorsAccountRTId && inKindAccount.Chapter_Name__c != Null)
                {
                    chaptterAccountIdSet.add(inKindAccount.Chapter_Name__c);
                    inKindDonorAccountSet.add(inKindAccount.Id);
                }
                
                
            }
            
            if(inKindAccount.RecordTypeId == chapterAccountRTId)
                chapterIds.add(inKindAccount.id);
            else
                chapterIds.add(inKindAccount.Chapter_Name__c);
        }
        
        
        
        if(chaptterAccountIdSet.size() > 0 || chapterIds.size() > 0)
        {
            for(Account daAccount : [SELECT Id,Name,Wish_Co_ordinator__c, OwnerId,Owner.UserRole.Name,Owner.ContactId,Volunteer_Manager__c,RecordTypeId,Chapter_Name__c,
                                    Chapter_Name__r.Name  FROM Account WHERE (Id IN: chaptterAccountIdSet OR 
                                    (Chapter_Name__c IN :chapterIds AND Id IN :Trigger.newMap.keySet()))])
            {
                
                if(daAccount.RecordTypeId == chapterAccountRTId)
                {
                    chaptterMap.put(daAccount.Id,daAccount.Wish_Co_ordinator__c);
                    volunteerManagersMap.put(daAccount.Id,daAccount.Volunteer_Manager__c);
                    String chapterNameTrim = daAccount.Name.removeStart('Make-A-Wish ');
                    chapterNameMap.put(daAccount.Id, chapterNameTrim);
                    
                  /*  if(accountMapforSharing.containsKey(daAccount.Name))
                    {
                    accountMapforSharing.get(daAccount.Name).add(daAccount);
                    }
                    else
                    accountMapforSharing.put(daAccount.Name, new List<Account>{daAccount});*/ 
                }
                
                else
                {
                   if(daAccount.Owner.userRole.Name == 'National Staff' ) //|| (daAccount.RecordTypeId == inKindDonorsAccountRTId && daAccount.Owner.ContactId != Null)
                   {
                        if(accountMapforSharing.containsKey(daAccount.Chapter_Name__r.Name))
                        {
                            accountMapforSharing.get(daAccount.Chapter_Name__r.Name).add(daAccount);
                        }
                        else
                            accountMapforSharing.put(daAccount.Chapter_Name__r.Name, new List<Account>{daAccount}); 
                   }
                }
            }
        }
        
        Set<Id> inKindDonorAccountWithChildRecords = new Set<Id>();
        for(Group currentGroup : [SELECT Id, Name FROM Group WHERE Type = 'Regular' AND Name IN: chapterNameMap.values()]){
            publicGroupMap.put(currentGroup.Name, currentGroup.id);
        }
        
        
        if(chaptterMap.size() > 0)
        {    
            for(Account inKindAccount : trigger.new){
               if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
                {   
                    if(inKindAccount.RecordTypeId == inKindDonorsAccountRTId)
                    {
                        
                        if(chaptterMap.containsKey(inKindAccount.Chapter_Name__c) && !String.isEmpty(chaptterMap.get(inKindAccount.Chapter_Name__c))){
                            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                            req.setComments('Submitting request for approval');
                            req.setObjectId(inKindAccount.id);
                            req.setProcessDefinitionNameOrId('Account_In_Kind_Donors_Approval');
                            req.setNextApproverIds(new Id[]{chaptterMap.get(inKindAccount.Chapter_Name__c)});
                            req.setSkipEntryCriteria(true);
                            Approval.ProcessResult result = Approval.process(req);
                        }
                        else{
                            inKindAccount.addError('There is no wish co-ordinator to approve this record');
                        }
                        
                        if(chapterNameMap.containsKey(inkindAccount.Chapter_Name__c)) 
                        {    
                            if( publicGroupMap.containsKey(chapterNameMap.get(inkindAccount.Chapter_Name__c)))
                            {    
                                groupId = publicGroupMap.get(chapterNameMap.get(inkindAccount.Chapter_Name__c));
                                AccountShare dynamicAccountShare  = new AccountShare();
                                dynamicAccountShare.AccountId = inkindAccount.Id;
                                dynamicAccountShare.Accountaccesslevel = 'Read';
                                dynamicAccountShare.CaseAccessLevel = 'Read';
                                dynamicAccountShare.ContactAccessLevel = 'Read';
                                dynamicAccountShare.OpportunityAccessLevel = 'Read';
                                dynamicAccountShare.UserOrGroupId = groupId;
                                accountShareList.add(dynamicAccountShare); 
                                
                            }
                        }                    
                    }  
                }
            }
            
            if(!accountShareList.isEmpty()){
                
                Insert accountShareList;
            }
            
        }  
        
        
        if(accountMapforSharing.size() > 0)
           ChapterStaffRecordSharing_AC.AccountSharing(accountMapforSharing);
        
    }
    
    //After update trigger is used to remove the access from the group if the record was rejected based on the chapter name
    if(trigger.isAfter && trigger.isUpdate)
    {
        List<AccountShare> accountShareList = New List<AccountShare>();
        List<AccountShare> updateAccountShareList = New List<AccountShare>();
        Constant_AC  constant = new Constant_Ac();
        Id chapterAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        Id inKindDonorsAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('In Kind Donors').getRecordTypeId();
        Id chapterId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Chapter').getRecordTypeId();
        Id wishChildRT = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Id houseHoleRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.HouseholdRT).getRecordTypeId();
        Constant_AC cons = new Constant_AC();
        Id housHoldAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Household Account').getRecordTypeId();
        
        String groupName;
        id groupId;
        set<String> accountIdsSet = new set<String>();
        map<string,id> publicGroupMap = new map<string,id>();
        Set<Id> chapterIdsSet = new Set<Id>();
        Set<Id> checkForChildRecordSet = new Set<Id>();
        Map<Id, Id> accWishCoorUpdateMap = new Map<Id, Id>();
        Map<Id, String> chapterNameMap = new Map<Id, String>();
        Map<Id,Account> accountMap = new Map<Id,Account>();
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        map<id,string> chapterEmailmap = new map<id,string>();
        
        
        //This for loop is used to remove inkind account from the public group based on updated chapter name          
        for(Account currentAccount : trigger.new)
        {
            
            if(currentAccount.Wish_Co_ordinator__c != null && currentAccount.Wish_Co_ordinator__c != Trigger.oldMap.get(currentAccount.Id).Wish_Co_ordinator__c) {
                accWishCoorUpdateMap.put(currentAccount.Id, currentAccount.Wish_Co_ordinator__c);
            }
            
            if(currentAccount.RecordTypeId == inKindDonorsAccountRTId)
            {
                if(currentAccount.In_Kind_Approval_Status__c == 'Rejected' && Trigger.oldMap.get(currentAccount.id).In_Kind_Approval_Status__c != 'Rejected') {
                    accountIdsSet.add(currentAccount.id);
                    chapterIdsSet.add(currentAccount.Chapter_Name__c);
                }
                if((currentAccount.Chapter_Name__c != trigger.oldMap.get(currentAccount.id).Chapter_Name__c && currentAccount.In_Kind_Approval_Status__c != 'Rejected') || 
                   currentAccount.Chapter_Name__c == Null &&  trigger.oldMap.get(currentAccount.id).Chapter_Name__c != NUll){
                       accountIdsSet.add(currentAccount.id);
                       chapterIdsSet.add(trigger.oldMap.get(currentAccount.id).Chapter_Name__c);
                       
                   }
            }
            
            if(currentAccount.RecordTypeId == chapterAccountRTId && currentAccount.DevStaffEmail__c != Null && 
               currentAccount.DevStaffEmail__c != trigger.oldmap.get(currentAccount.id).DevStaffEmail__c){
                   chapterEmailmap.put(currentAccount.id, currentAccount.DevStaffEmail__c);
               }
        }
        // This is used to update wisgrantingcase devstaff email field     
        if(chapterEmailmap.size() > 0){
            AccountTriggerHandler.updateGrantingCaseDevStaffEmai(chapterEmailmap);
        }
        
        if(accWishCoorUpdateMap.size() > 0) {
            List<Case> caseOwnerUpdateList = new List<Case>();
            for(Case parentCase : [SELECT Id, OwnerId, ChapterName__c FROM Case WHERE isClosed = false AND RecordTypeId =: parentWishRecordTypeId AND ChapterName__c IN : accWishCoorUpdateMap.keySet()]) {
                parentCase.OwnerId = accWishCoorUpdateMap.get(parentCase.ChapterName__c);
                caseOwnerUpdateList.add(parentCase);
            }
            if(caseOwnerUpdateList.size() > 0) {
                //update caseOwnerUpdateList;
            }
        }
        
        
        
        if(chapterIdsSet.size() > 0){
            for(Account getAccountName : [SELECT Id, Name FROM Account WHERE RecordTypeId =: chapterId]){
                String chapterNameTrim = getAccountName.Name.removeStart('Make-A-Wish ');
                chapterNameMap.put(getAccountName.Id, chapterNameTrim);
            }
        }
        
        
        for(Group currentGroup : [SELECT Id, Name FROM Group WHERE Type = 'Regular']){
            publicGroupMap.put(currentGroup.Name, currentGroup.id);
        }
        if(accountIdsSet.size() > 0 && publicGroupMap.size() > 0 ){
            accountShareList = [SELECT Id,AccountId,UserOrGroupId FROM AccountShare WHERE AccountId IN: accountIdsSet AND UserOrGroupId IN: publicGroupMap.values()];
        }
        
        if(accountShareList.size() > 0 ){
            delete accountShareList;
        }
        
        
        //This for loop is used to add inkind account to the public group based on new updated chapter name          
        for(Account newInkind : trigger.new){
            if(newInkind.Chapter_Name__c != trigger.oldMap.get(newInkind.id).Chapter_Name__c){
                if(chapterNameMap.containsKey(newInkind.Chapter_Name__c)) 
                {    
                    if( publicGroupMap.containsKey(chapterNameMap.get(newInkind.Chapter_Name__c)))
                    {    
                        groupId = publicGroupMap.get(chapterNameMap.get(newInkind.Chapter_Name__c));
                        AccountShare dynamicAccountShare  = new AccountShare();
                        dynamicAccountShare.AccountId = newInkind.Id;
                        dynamicAccountShare.Accountaccesslevel = 'Read';
                        dynamicAccountShare.CaseAccessLevel = 'Read';
                        dynamicAccountShare.ContactAccessLevel = 'Read';
                        dynamicAccountShare.OpportunityAccessLevel = 'Read';
                        dynamicAccountShare.UserOrGroupId = groupId;
                        updateAccountShareList.add(dynamicAccountShare);
                        
                    }
                }
            }
            
        }
        
        if(!updateAccountShareList.isEmpty()){
            
            Insert updateAccountShareList;
        }
        
    }
    
    //Reset the address verification checkbox if the address has changed
    if(trigger.isBefore && trigger.isUpdate)
    {
        for(Account newAccount : trigger.new){
            // the billing address is already marked as verified
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null &&
            // one of the shipping address fields changed
            (newAccount.BillingStreet != Trigger.oldMap.get(newAccount.Id).BillingStreet ||
            newAccount.BillingState != Trigger.oldMap.get(newAccount.Id).BillingState ||
            newAccount.BillingStateCode != Trigger.oldMap.get(newAccount.Id).BillingStateCode ||
            newAccount.BillingCity != Trigger.oldMap.get(newAccount.Id).BillingCity ||
            newAccount.BillingPostalCode != Trigger.oldMap.get(newAccount.Id).BillingPostalCode
            )
            ){
                system.debug('Update BillingAddressVerified__c>>>>'+newAccount.BillingAddressVerified__c);
                newAccount.BillingAddressVerified__c = false;
                newAccount.BillingAddressVerificationAttempted__c = null;
                
            }
            
            // the shipping address is already marked as verified
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null &&
            // one of the shipping address fields changed
            (newAccount.ShippingStreet != Trigger.oldMap.get(newAccount.Id).ShippingStreet ||
            newAccount.ShippingState != Trigger.oldMap.get(newAccount.Id).ShippingState ||
            newAccount.ShippingStateCode != Trigger.oldMap.get(newAccount.Id).ShippingStateCode ||
            newAccount.ShippingCity != Trigger.oldMap.get(newAccount.Id).ShippingCity ||
            newAccount.ShippingPostalCode != Trigger.oldMap.get(newAccount.Id).ShippingPostalCode
            )
            ){
                system.debug('Update ShippingAddressVerified__c>>>>'+newAccount.ShippingAddressVerified__c);
                newAccount.ShippingAddressVerified__c = false;
                newAccount.ShippingAddressVerificationAttempted__c = null;
                
            }
        }
    
    }
    
}