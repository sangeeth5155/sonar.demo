global class batch_changeVolunOppSatus  implements Database.Batchable<sObject> {
       global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        
          return  Database.getQueryLocator([SELECT Event_date__c,id,status__C FROM Volunteer_Opportunity__c
                                 where Event_date__c < :Date.Today() AND recordtype.name = 'Non Wish & Event' ]);    
    }
    global void execute(Database.BatchableContext bc, list<Volunteer_Opportunity__c> nonWishEventList){
        if(nonWishEventList.size () > 0 && nonWishEventList!= null){
           Map<Id,Volunteer_Opportunity__c> VolunteerOppMap =new Map<id,Volunteer_Opportunity__c>();
            Volunteer_Opportunity__c vOpp;
            for(Volunteer_Opportunity__c currRec: nonWishEventList){
                vOpp= new Volunteer_Opportunity__c ();
                vOpp.Id=currRec.id;
                vOpp.status__c='Completed';
                VolunteerOppMap.put(vOpp.id,vOpp);
            }
            Update VolunteerOppMap.Values();
       }
    }
     global void finish(Database.BatchableContext BC) {
    }
}