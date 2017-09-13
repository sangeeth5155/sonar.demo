global class batch_FillWishInterviewDate  implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {    Constant_AC  constant = new Constant_Ac();  
         Id parentWishRT = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
         Id wishDeterminationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
         
        // String query = 'SELECT Id,ParentId,Parent.Interview_Date__c FROM CASE WHERE ((Parent.RecordTypeId = \''+parentWishRT+'\') '
                    //     + ' AND (RecordTypeId = \''+wishDeterminationRecordTypeId+'\') AND (Parent.Interview_date__c = Null) ';
          return Database.getQueryLocator([SELECT Id,ParentId,Parent.Interview_Date__c,createdDate,Parent.Interview_Date_Not_Set__c FROM CASE WHERE Parent.RecordTypeId =: parentWishRT
                                            AND RecordTypeId =: wishDeterminationRecordTypeId AND Parent.Interview_date__c = Null ]);
    }
   
    global void execute(Database.BatchableContext BC, List<Case> scope) 
    {
         Map<Id,Case> updateParentCaseMap = new Map<Id,Case>();
        for(Case currCase : scope)
        {
            datetime creDate = currCase.createdDate;
            date wishDeterminiationcreatedDate = date.newInstance(creDate.year(), creDate.month(), creDate.day());
           if(wishDeterminiationcreatedDate == Date.Today())
           {
              if(currCase.Parent.Interview_Date__c == Null)
              {
                  Case toUpdate = new Case();
                  toupdate.id = currCase.parentId;
                  toUpdate.Interview_Date_Not_Set__c = True;
                  updateParentCaseMap.put(toUpdate.Id,toUpdate);
              }
                 
           }
        }
        
        if(updateParentCaseMap.size() > 0)
            update updateParentCaseMap.values();
    }   

    global void finish(Database.BatchableContext BC) {
    }
}