/*
* Description : It will create volunteer user record while doing volunteer contact data import.
*This will fire only when Migrated_Record is true on Volunteer Contact.
*/

trigger CreateVolunteerUser_AT on Contact (After Insert, After Update) {
   
    Constant_AC constant = new Constant_AC();
    Set<id> conId=new Set<Id>();
    Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
    
    if(Trigger.isAfter && Trigger.isinsert){
        for(Contact currContact:trigger.new)
        {
             if(currContact.recordTypeid == volunteerRecordTypeId 
             && currContact.Do_Not_Create_User__c==False 
             && currContact.Migrated_Record__c == True)
             {
                 conId.add(currContact.id);   
             }
        }
    }
    
    if(Trigger.isAfter && Trigger.isupdate){
        for(Contact currContact:trigger.new)
        {
            if(currContact.recordTypeid == volunteerRecordTypeId 
            && currContact.Do_Not_Create_User__c==False 
            && currContact.recordTypeid != trigger.oldmap.get(currContact.id).recordTypeid) 
              
            {
               conId.add(currContact.id);
            }
            System.debug('Contact Info1:' + currContact.Do_Not_Create_User__c + ' - ' + currContact.Migrated_Record__c + ' - ' + currContact.recordTypeid);
         }
    }
    System.debug('Contact Info2:' + conId);
    if(conId.size()>0)
    {
       // VolunteerContactHandler.createUser(conId);
    }

}