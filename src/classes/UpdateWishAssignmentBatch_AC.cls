/*****************************************************************************************
 Created By  : MST
 CreatedDate : 8/31/2016
 Author : MST Solutions
 Description : If wish granter is not assigned for a parent wish particular period of time, then it will send an 
 email notification to Volunteer Manager.
**********************************************************************************************/

global class UpdateWishAssignmentBatch_AC implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
         Constant_AC  constant = new Constant_Ac();  
         integer d = 2;  
         Id parentWishRT = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
         String query = 'SELECT Id,CaseNumber,isEmail__c,CreatedDate,ChapterName__c, ChapterName__r.Name,Case_Member_Count__c FROM CASE WHERE ((Case_Member_Count__c < '+d+' OR Case_Member_Count__c = Null) ' + 
                         ' OR (RecordTypeId = \''+parentWishRT+'\')) AND ChapterName__c != Null';
                        
         System.debug('Query+++++++++++++++++++++++++++ ' + query);
         return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Case> scope) 
    {
        Set<String> chapterNamesSet = new Set<String>();
        Map<String, Account> chapterMap = new Map<String, Account>();
        Set<Id> caseIds = new Set<Id>();
        
        for(Case currCase : scope)
        {
             if(currCase.ChapterName__c != Null)
                {
                   caseIds.add(currCase.id);
                   chapterNamesSet.add(currCase.ChapterName__r.Name);
                }
        }
        
        Map<Id,List<Volunteer_Opportunity__c>> volunteerWishMap = new Map<Id, List<Volunteer_Opportunity__c>>();
        
        for(Volunteer_Opportunity__c currOpp : [SELECT id,Chapter_Role_Opportunity__c, Chapter_Role_Opportunity__r.Role_Name__r.Name,
                                                Wish__c FROM Volunteer_Opportunity__c  WHERE 
                                                Wish__c IN :caseIds AND RecordType.Name = 'Wish' AND 
                                                Chapter_Role_Opportunity__r.Role_Name__r.Name = 'Wish Granter' AND Volunteer_Name__c != Null])
        {
           if(volunteerWishMap.containsKey(currOpp.Wish__c))
               volunteerWishMap.get(currOpp.Wish__c).add(currOpp);
           else
               volunteerWishMap.put(currOpp.Wish__c, new List<Volunteer_Opportunity__c>{currOpp});
        } 
        
       
        
        System.debug('chapterNamesSet++++++++++++++++++++++++++ ' + chapterNamesSet);
        
        if(chapterNamesSet.size() > 0)
        {
           for(Account currChapter : [SELECT id, Name, Volunteer_Manager__c, Alert_for_Unassigned_Wishes__c,Volunteer_Manager__r.Name, Volunteer_Manager__r.Email 
                                      FROM Account WHERE Name IN :chapterNamesSet])
            {
                chapterMap.put(currChapter.Name, currChapter);
            }
        }
        System.debug('chapterMap++++++++++++++++++++++++++ ' + chapterMap);
        
        List<Case> updateCaseList = new List<Case>();
        for(Case currCase : scope)
        {
             DateTime dT = System.now();
             Date todayDate = date.newinstance(dT.year(), dT.month(), dT.day()); 
             boolean flag = false;
             if(volunteerWishMap.containsKey(currCase.id))
             {
                if((volunteerWishMap.get(currCase.id)).size() < 2)
                {
                   flag = True;
                }
                else
                {
                   flag = false;
                }
             
             }
             
             else
               flag = true;
            
            
            if(flag == True)
            {
                
                if(chapterMap.containsKey(currCase.chaptername__r.Name))
                {
                   Date currDate;
                  if(chapterMap.get(currCase.chaptername__r.Name).Alert_for_Unassigned_Wishes__c != Null)
                  { 
                       Date currentDate = Date.valueOf(currCase.CreatedDate);
                       currDate = date.newinstance(currentDate.year(), currentDate.month(), currentDate.day());
                      
                       currDate =  (Date.valueOf(currDate)).addDays(integer.valueOf(chapterMap.get(currCase.chaptername__r.Name).Alert_for_Unassigned_Wishes__c));
                  }
                 
                   if(currDate == todayDate)
                   {
                       Case newCase = new Case();
                       newCase.id = currCase.id;
                       newCase.VOlunteer_Manager_Name__c = chapterMap.get(currCase.chaptername__r.Name).Volunteer_Manager__r.Name;
                       newCase.Volunteer_Manager_Email__c = chapterMap.get(currCase.chaptername__r.Name).Volunteer_Manager__r.Email;
                       newCase.isEmail__c = True;
                       updateCaseList.add(newCase);
                   }
                }
            }
        }
        
        if(updateCaseList.size() > 0)
          Update updateCaseList;
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}