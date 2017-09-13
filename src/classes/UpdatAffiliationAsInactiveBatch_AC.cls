/*****************************************************************************************
Created By  : MST
CreatedDate : 07/20/2016
Author : MST Solutions
Description : This batch would update the Affiliation Record as Active or Inactive based on the COI and Background Check.
This batch class would run every morning 1 am MST. It will check the Background Check Expiration Date and COI expiration 
Date. If any of one is expired, then it will update the Affiliation record as Inactive. Suppose user renewed the expiraton date
then it would update the status as "Active".
**********************************************************************************************/
global class UpdatAffiliationAsInactiveBatch_AC implements Database.Batchable<Aggregateresult> {
    
    // It will return  all the active and inactive records for execute.
    global iterable<Aggregateresult> Start(Database.BatchableContext BC) { 
        list<AggregateResult> batchAggregationList = NEW list<AggregateResult>();
        batchAggregationList =  [SELECT npe5__Contact__c con FROM npe5__Affiliation__c WHERE (npe5__Status__c = 'Active' OR npe5__Status__c = 'inactive' ) GROUP BY npe5__Contact__c];
        return batchAggregationList;
    }
    
    // If Background check/COI is expired, it will the active status to Inactive. 
    // If Background check and COI is renewed, then it will update the inactive status to active status.
    global void Execute(Database.BatchableContext BC, List<AggregateResult> scope)  {
        Set<Id> contactIdsSet = new Set<Id>();
        List<npe5__Affiliation__c> updateAffiliationList = new List<npe5__Affiliation__c>(); 
        Set<Id> backGroundContactIdsSet = new Set<Id>();
        Set<Id> coiContactIdsSet = new Set<Id>();
        for(AggregateResult currResult : scope) {
            String conId = String.valueof(currResult.get('con'));
            contactIdsSet.add(conId);
        }   
        for(Background_check__c dbbackgroundCheckRec : [SELECT Id,current__c,Date__c,Volunteer__c FROM Background_check__c  WHERE Volunteer__c IN: contactIdsSet AND Date__c >: Date.Today() ]) {
            backGroundContactIdsSet.add(dbbackgroundCheckRec.Volunteer__c);
        }
        
        for(Conflict_Of_Interest__c dbconflictInterestRec : [SELECT Id,Expiration_Date__c,Volunteer_Contact__c FROM Conflict_Of_Interest__c  WHERE Volunteer_Contact__c IN: contactIdsSet AND Expiration_Date__c >: Date.Today()]){
            coiContactIdsSet.add(dbconflictInterestRec.Volunteer_Contact__c);
        } 
        for(npe5__Affiliation__c  currRec : [SELECT Id, npe5__Contact__c, npe5__Status__c FROM npe5__Affiliation__c WHERE npe5__Status__c = 'Active' AND npe5__Contact__c IN :contactIdsSet]) {
            if(!(backGroundContactIdsSet.contains(currRec.npe5__Contact__c) && coiContactIdsSet.contains(currRec.npe5__Contact__c))){
                npe5__Affiliation__c  newRec = new npe5__Affiliation__c();
                newRec.id = currRec.id;
                newRec.npe5__Status__c = 'Inactive';
                updateAffiliationList.add(newRec);
            }
        }
        for(npe5__Affiliation__c  currRec : [SELECT Id, npe5__Contact__c, npe5__Status__c FROM npe5__Affiliation__c WHERE npe5__Status__c = 'inactive' AND npe5__Contact__c IN :contactIdsSet]) {
            if(backGroundContactIdsSet.contains(currRec.npe5__Contact__c) && coiContactIdsSet.contains(currRec.npe5__Contact__c)) {
                npe5__Affiliation__c  newRec = new npe5__Affiliation__c();
                newRec.id = currRec.id;
                newRec.npe5__Status__c = 'Active';
                updateAffiliationList.add(newRec);
            }
        }
        
        if(updateAffiliationList.size() >0)
            update updateAffiliationList;
    }
    global void Finish(Database.BatchableContext BC) {
    }
}