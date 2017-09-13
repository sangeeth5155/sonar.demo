/*****************************************************************************************
 Created By  : MST
 CreatedDate : 07/20/2016
 Author : MST Solutions
 Description : This batch would update the Affiliation Record as Active or Inactive based on the COI and Background Check.
 This batch class would run every morning 1 am MST. It will check the Background Check Expiration Date and COI expiration 
 Date. If any of one is expired, then it will update the Affiliation record as Inactive. Suppose user renewed the expiraton date
 then it would update the status as "Active".
**********************************************************************************************/
global class UpdatAffiliationAsInactiveSchedule_AC implements Schedulable{

    global void execute(SchedulableContext SC){
        
        Database.executeBatch(new UpdatAffiliationAsInactiveBatch_AC(),25);
        
    }
}