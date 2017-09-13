trigger AddFlagonHouseHoldAccount on Account (before insert) {

    Constant_AC  constant = new Constant_AC();
    public Id houseHoldRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.HouseholdRT).getRecordTypeId();
   
    for(Account currAccount : Trigger.new)
    {
       if(currAccount.RecordTypeId == houseHoldRT)
       {
         
          if(Bypass_Triggers__c.getValues(userInfo.getUserId()) != Null)
              currAccount.Migrated_Record__c = true;
        
       } 
    }

}