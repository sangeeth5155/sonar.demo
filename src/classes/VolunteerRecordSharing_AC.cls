/***********************************************************
Created By: Vennila Paramasivam
Author : MST Solutions
Createddate :  6/14/2016
Description : Once volunteer has been added to the Case Team, They should have the ability to view
Parent wish, wish kid and household account.
************************************************************/

Public class VolunteerRecordSharing_AC
{
  public static void recordSharing(Map<Id,Volunteer_Opportunity__c> volunteerforApexSharing, Map<String,Set<String>> volunteerCaseMap)
  {
      
    List<AccountShare> accountsToShare = new List<AccountShare>();
    List<ContactShare> contactSharing = new List<ContactShare>();
    Map<String,Set<String>> accountCaseMap = new Map<String, Set<String>>();
    Map<Id,Id> userContactMap = new Map<Id,Id>();
    
    Set<Id> accountIdsSet = new Set<Id>();
    Constant_AC  constant = new Constant_Ac();
    String wishFamilyDT = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
    String wishChildDT = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
    String houseHoldDT = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.HouseholdRT).getRecordTypeId();
    Set<String> volunteerContactsSet = new Set<String>();
    
    for(String vol :volunteerCaseMap.keySet())
    {
      volunteerContactsSet.addAll(volunteerCaseMap.get(vol));
    }
    
    for(User currvolunteer : [SELECT id, contactId FROM User WHERE contactID IN :volunteerContactsSet])
    {
       userContactMap.put(currvolunteer.contactId,currvolunteer.id);
    }
    
    
    for(Case currCase : [SELECT Id,AccountId,Account.OwnerId FROM Case WHERE Id IN :volunteerCaseMap.keySet() 
                         AND Account.RecordtypeId = :houseHoldDT ])
    {
       for(String currVolunteer : volunteerCaseMap.get(currCase.id))
       {
       
           accountIdsSet.add(currCase.AccountId);
           
           if(accountCaseMap.containsKey(currCase.AccountId))
             accountCaseMap.get(currCase.AccountId).add(currCase.id);
           else
             accountCaseMap.put(currCase.AccountId,new Set<String>{currCase.id});
          
          if(userContactMap.get(currVolunteer) != currCase.ACcount.ownerId)
          {
           AccountShare currSharing = new AccountShare();
           currSharing.accountId= currCase.AccountId;
           System.debug('currVolunteer++++++++++++++++++++++= ' +currVolunteer.subString(0,15));
           currSharing.UserOrGroupId = userContactMap.get(currVolunteer);//.subString(0,15);//'00536000001rItA';//currVolunteer.subString(0,15);
           currSharing.accountAccessLevel = 'Read';
           currSharing.contactAccesslevel = 'Read';
           currSharing.opportunityAccesslevel = 'Read';
           currSharing.RowCause = Schema.AccountShare.RowCause.Manual;
           accountsToShare.add(currSharing);
          }

       }
    }
    
  for(Contact currContact : [SELECT Id,OwnerId, AccountId FROM Contact WHERE AccountId IN :accountIdsSet AND (RecordtypeId = :wishFamilyDT OR RecordtypeId = :wishChildDT)])
    {
    
      for(String currCaseId :accountCaseMap.get(currContact.accountId))
      {
       for(String currVolunteer : volunteerCaseMap.get(currCaseId))
       {
          if(currContact.OwnerId != userContactMap.get(currVolunteer))
          {
            contactShare currContactSharing = new contactShare();
            currContactSharing.ContactId = currContact.Id;
            currContactSharing.UserOrGroupId = userContactMap.get(currVolunteer);
            currContactSharing.ContactAccessLevel = 'Read';
            currContactSharing.RowCause = Schema.contactshare.RowCause.Manual;
            contactSharing.add(currContactSharing);
          }
       }
      }
        
        
    } 
    
    if(accountsToShare.size() > 0)
        insert accountsToShare;
        
    if(contactSharing.size() > 0)
        insert contactSharing;
    
  }

}