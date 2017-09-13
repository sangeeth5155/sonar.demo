/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 5/23/2016
Description : This TimeSheetTriggerHandler is used to calculate the total hours spent by volunteer to close the wish and 
              Non-wish & Event.
*******************************************************************************************************************/
public class TimeSheetTriggerHandler{
    
    /* This splitBefore() is used to split the time into hours and minutes and also it is used for validation purpose. */
    public void SplitBefore(List<Time_sheet__c> timesheetList){
        for(Time_sheet__c processtimesheetEntry : timesheetList){
            List<String> timeList = String.valueOf(processtimesheetEntry.Hours_spent__c).split('\\.');
            integer hours = Integer.ValueOf(timeList [0]);
            integer minutes = Integer.ValueOf(timeList [1]);
            if(minutes  > 99){
                processtimesheetEntry.Hours_spent__c.addError('Minutes should be 99 or less than 99');
            }
            Integer hrs;
            if(hours != Null )
                hrs=hours*60;
            processtimesheetEntry.Hours_Hidden__c = hrs+minutes;
        }
    }
    /* This calculateHourstoWish method is used to calculate the total hours spent by the volunteer to close the corresponding wish.*/
    public void CalculateHourstoWish(List<Time_sheet__c> timesheetList){
        Set<Id> volOpportunityIdSet = new Set<Id>();
        Map<Id,Decimal> volOpportunityMap = new Map<Id,Decimal>();
        Map<Id,Case> caseMap = New  Map<Id,Case>();
        Set<ID> wishIdSet = New  Set<ID>();
        Decimal hrs=0,min=0;
        String totalHours;
        List<Non_Wish_Events__c> nonWishList = new List <Non_Wish_Events__c>();
        for(Time_sheet__c processtimesheetEntry : timesheetList){
            if(processtimesheetEntry.Volunteer_Opportunity__c != Null )
                volOpportunityIdSet.add(processtimesheetEntry.Volunteer_Opportunity__c); 
        }
        for(Volunteer_Opportunity__c  vop:[select id,wish__c from Volunteer_Opportunity__c where id IN:volOpportunityIdSet AND wish__c != Null]){
            wishIdSet.add(vop.wish__c);
        }
        AggregateResult[] groupedResults = [SELECT Volunteer_Opportunity__r.Wish__c wish,Sum(Hours_Hidden__c)aver FROM Time_sheet__c WHERE Volunteer_Opportunity__r.Wish__c IN: wishIdSet AND Volunteer_Opportunity__r.Wish__c != Null GROUP BY Volunteer_Opportunity__r.Wish__c];
        if(!groupedResults.isEmpty()){
            for(AggregateResult arr : groupedResults){
                volOpportunityMap.put((ID)arr.get('wish'),(decimal)arr.get('aver'));
            }
            for(Volunteer_Opportunity__c dbOpportunity : [SELECT Id,Wish__c,Wish__r.Total_Hour_Spent_Hidden__c FROM Volunteer_Opportunity__c WHERE Wish__c IN: volOpportunityMap .KeySet() AND Wish__c != NULL]){
                
                case caseIns;
                if(caseMap.containsKey(dbOpportunity.Wish__c)){
                    system.debug('==='+caseMap);
                    caseIns = New case();
                    caseIns.id = caseMap.get(dbOpportunity.Wish__c).id;
                } else {
                    caseIns = New case();
                    caseIns.id = dbOpportunity.Wish__c;
                }  
                
                if((caseIns.Total_Hour_Spent_Hidden__c  == NULL || caseIns.Total_Hour_Spent_Hidden__c == 0.00) && dbOpportunity.Wish__r.Total_Hour_Spent_Hidden__c != NULL && dbOpportunity.Wish__r.Total_Hour_Spent_Hidden__c > 0){
                    hrs = Math.floor(dbOpportunity.Wish__r.Total_Hour_Spent_Hidden__c / 60);
                    min = Math.Mod(Integer.ValueOf(dbOpportunity.Wish__r.Total_Hour_Spent_Hidden__c),60);
                    totalHours = hrs+'.'+min;
                    caseIns.Total_Hour_Spent_Hidden__c = Decimal.ValueOF(totalHours);
                    //caseIns.Total_Hour_Spent_Hidden__c = dbOpportunity.Wish__r.Total_Hour_Spent_Hidden__c / 60;
                    }
                
                if(caseIns.Total_Hour_Spent_Hidden__c  == NULL || caseIns.Total_Hour_Spent_Hidden__c == 0.00){
                    hrs = Math.floor(volOpportunityMap.get(dbOpportunity.Wish__c) / 60);
                    min = Math.Mod(Integer.ValueOf(volOpportunityMap.get(dbOpportunity.Wish__c)),60);
                    totalHours = hrs+'.'+min;
                    caseIns.Total_Hour_Spent_Hidden__c = Decimal.ValueOF(totalHours);
                    //caseIns.Total_Hour_Spent_Hidden__c = volOpportunityMap.get(dbOpportunity.Wish__c) /60;
                    }
                else{
                    hrs = Math.floor(volOpportunityMap.get(dbOpportunity.Wish__c) / 60);
                    min = Math.Mod(Integer.ValueOf(volOpportunityMap.get(dbOpportunity.Wish__c)),60);
                    totalHours = hrs+'.'+min;
                    caseIns.Total_Hour_Spent_Hidden__c = Decimal.ValueOF(totalHours);
                    //caseIns.Total_Hour_Spent_Hidden__c = volOpportunityMap.get(dbOpportunity.Wish__c) / 60;
                    }
                
                if(caseIns.Total_Hour_Spent_Hidden__c > 0){
                    Decimal toround = caseIns.Total_Hour_Spent_Hidden__c;
                     system.debug('@@@@@ rounded1 @@@@@'+toround );
                    Decimal rounded = toround.setScale(2);
                    system.debug('@@@@@ rounded @@@@@'+rounded );
                    List<String> timeList = String.valueOf(rounded).split('\\.');
                    Integer hours  = Integer.ValueOf(timeList [0]);
                    Integer minutes  = Integer.ValueOf(timeList [1]);
                    if( hours   > 0){
                        if(minutes   > 59){
                            Integer divideMinutes = minutes  /60;
                            Integer roundMinutes = math.mod(minutes ,60);
                            if(divideMinutes  != Null){
                                hours = hours + divideMinutes;
                                if(roundMinutes <10){
                                    caseIns.Total_Hour_Spent__c = hours  + ':0'+roundMinutes ;
                                    caseMap.put(caseIns.id,caseIns);
                                }
                                else{
                                    caseIns.Total_Hour_Spent__c = hours  + ':'+roundMinutes ;
                                    caseMap.put(caseIns.id,caseIns);
                                }
                            } 
                        }
                        else{
                            caseIns.Total_Hour_Spent__c = hours+ ':'+minutes;
                            caseMap.put(caseIns.id,caseIns);
                        }
                    }
                    else{
                        caseIns.Total_Hour_Spent__c = hours+ ':'+minutes;
                        caseMap.put(caseIns.id,caseIns);
                    }   
                }
            }
        }
        else{
            for(Case caseIns : [SELECT Id,Total_Hour_Spent_Hidden__c FROM Case WHERE Id IN: wishIdSet]){
                caseIns.Total_Hour_Spent__c = String.valueof(0);
                caseMap.put(caseIns.id,caseIns);
            }
        }
        update caseMap.values();
    }
    /* This calculateHourstoNonWish is used to calculate the total hours spent by the volunteer to close the corresponding NonWish & Event.*/
    public void CalculateHourstoNonWish(List<Time_sheet__c> timesheetList){
        Set<Id> volOpportunityIdSet = new Set<Id>();
        Map<Id,Decimal> volOpportunityMap = new Map<Id,Decimal>();
        Map<Id,Non_Wish_Events__c> nonwishMap = New  Map<Id,Non_Wish_Events__c>();
        Set<ID> nonwishIdSet = New  Set<ID>();
        Decimal hrs=0,min=0;
        String totalHours;
        for(Time_sheet__c processtimesheetEntry : timesheetList){
            if(processtimesheetEntry.Volunteer_Opportunity__c != Null )
                volOpportunityIdSet.add(processtimesheetEntry.Volunteer_Opportunity__c); 
            
        }
        for(Volunteer_Opportunity__c  vop:[select id,Non_Wish_Event__c from Volunteer_Opportunity__c where id IN: volOpportunityIdSet AND Non_Wish_Event__c  != Null]){
            nonwishIdSet .add(vop.Non_Wish_Event__c );
            
        }
        AggregateResult[] groupedResults = [SELECT Volunteer_Opportunity__r.Non_Wish_Event__c nonwish,Sum(Hours_Hidden__c)aver FROM Time_sheet__c WHERE Volunteer_Opportunity__r.Non_Wish_Event__c IN: nonwishIdSet AND Volunteer_Opportunity__r.Non_Wish_Event__c != Null GROUP BY Volunteer_Opportunity__r.Non_Wish_Event__c];
        if(!groupedResults.isEmpty()){
            
            for(AggregateResult arr : groupedResults){
                volOpportunityMap.put((ID)arr.get('nonwish'),(decimal)arr.get('aver'));
                
            }
            for(Volunteer_Opportunity__c dbOpportunity : [SELECT Id,Non_Wish_Event__c,Non_Wish_Event__r.Total_Hour_Spent_Hidden__c FROM Volunteer_Opportunity__c WHERE Non_Wish_Event__c IN: volOpportunityMap .KeySet() AND Non_Wish_Event__c != NULL]){
                
                Non_Wish_Events__c nonwishIns;
                if(nonwishMap.containsKey(dbOpportunity.Non_Wish_Event__c)){
                    nonwishIns = New Non_Wish_Events__c();
                    nonwishIns.id = nonwishMap.get(dbOpportunity.Non_Wish_Event__c).id;
                } else {
                    nonwishIns = New Non_Wish_Events__c();
                    nonwishIns .id = dbOpportunity.Non_Wish_Event__c;
                }  
                if((nonwishIns.Total_Hour_Spent_Hidden__c == NULL || nonwishIns.Total_Hour_Spent_Hidden__c == 0.00) && dbOpportunity.Non_Wish_Event__r.Total_Hour_Spent_Hidden__c != NULL && dbOpportunity.Non_Wish_Event__r.Total_Hour_Spent_Hidden__c > 0)
                {
                    hrs = Math.floor(dbOpportunity.Non_Wish_Event__r.Total_Hour_Spent_Hidden__c / 60);
                    min = Math.Mod(Integer.ValueOf(dbOpportunity.Non_Wish_Event__r.Total_Hour_Spent_Hidden__c),60);
                    totalHours = hrs+'.'+min;
                    nonwishIns.Total_Hour_Spent_Hidden__c = Decimal.ValueOF(totalHours);
                //    nonwishIns.Total_Hour_Spent_Hidden__c = dbOpportunity.Non_Wish_Event__r.Total_Hour_Spent_Hidden__c / 60;
                }
                if(nonwishIns .Total_Hour_Spent_Hidden__c == NULL || nonwishIns.Total_Hour_Spent_Hidden__c == 0.00)
                {    
                    hrs = Math.floor(volOpportunityMap.get(dbOpportunity.Non_Wish_Event__c)/ 60);
                    min = Math.Mod(Integer.ValueOf(volOpportunityMap.get(dbOpportunity.Non_Wish_Event__c)),60);
                    totalHours = hrs+'.'+min;
                    nonwishIns.Total_Hour_Spent_Hidden__c = Decimal.ValueOF(totalHours);
                   // nonwishIns.Total_Hour_Spent_Hidden__c = volOpportunityMap.get(dbOpportunity.Non_Wish_Event__c) / 60;
                }
                else{
                    hrs = Math.floor(volOpportunityMap.get(dbOpportunity.Non_Wish_Event__c)/ 60);
                    min = Math.Mod(Integer.ValueOf(volOpportunityMap.get(dbOpportunity.Non_Wish_Event__c)),60);
                    totalHours = hrs+'.'+min;
                    nonwishIns.Total_Hour_Spent_Hidden__c = Decimal.ValueOF(totalHours);
                 //   nonwishIns.Total_Hour_Spent_Hidden__c = volOpportunityMap.get(dbOpportunity.Non_Wish_Event__c) / 60;
                 }
                if(nonwishIns.Total_Hour_Spent_Hidden__c > 0){
                    Decimal toround = nonwishIns .Total_Hour_Spent_Hidden__c ;
                    Decimal rounded = toround.setScale(2);
                    
                    List<String> timeList = String.valueOf(rounded).split('\\.');
                    Integer hours = Integer.ValueOf(timeList [0]);
                    Integer minutes   = Integer.ValueOf(timeList [1]);
                    if( hours  > 0){
                        if(minutes  > 59){
                            Integer divideMinutes  = minutes/60;
                            Integer roundMinutes  = math.mod(minutes,60);
                            if(divideMinutes != Null){
                                hours  = hours +divideMinutes;
                                if(roundMinutes <10){
                                    nonwishIns.Total_Hour_Spent__c = hours + ':0'+roundMinutes ;
                                    nonwishMap.put(nonwishIns.id,nonwishIns);
                                }
                                else{
                                    nonwishIns.Total_Hour_Spent__c = hours + ':'+roundMinutes ;
                                    nonwishMap.put(nonwishIns.id,nonwishIns);
                                }
                            } 
                        }
                        else{
                            nonwishIns.Total_Hour_Spent__c = hours + ':'+minutes;
                            nonwishMap.put(nonwishIns.id,nonwishIns);
                        }
                    }
                    else{
                        nonwishIns.Total_Hour_Spent__c = hours + ':'+minutes;
                        nonwishMap.put(nonwishIns.id,nonwishIns);
                    }  
                }
                
            }
        }
        else{
            for(Non_Wish_Events__c nonwishIns : [SELECT Id,Total_Hour_Spent__c FROM Non_Wish_Events__c  WHERE Id IN: nonwishIdSet]){
                nonwishIns.Total_Hour_Spent__c = string.valueof(0);
                nonwishMap.put(nonwishIns.id,nonwishIns );
            }
        }
        
        update nonwishMap.values();
    }
  /*  public Static void findRecentTimeSheetDate(Map<Id,Time_sheet__c> timeSheetMap){ 
        System.debug('>>>>>>>timeSheetMap'+timeSheetMap);
        Id volunteerUserId = userInfo.getUserId();
        List<Contact> volunteerInfoUpdate = new List<Contact>();
        Set<Id> volunteerIdsSet = new Set<Id>();
        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        
        for(Time_sheet__c getVolunteerInfo : [SELECT Id, Volunteer_Opportunity__r.Volunteer_Name__c FROM Time_sheet__c WHERE Id IN : timeSheetMap.keySet()]) {
            volunteerIdsSet.add(getVolunteerInfo.Volunteer_Opportunity__r.Volunteer_Name__c);
        }
        
        Map<Id,Date> volunteerRecentDateMap = new Map<Id, Date>();
        for(AggregateResult getRecentTimeSheet : [SELECT MAX(Date__c) maxTimeDate, Volunteer_Opportunity__r.Volunteer_Name__c volunteerName FROM Time_sheet__c WHERE Volunteer_Opportunity__r.Volunteer_Name__c IN : volunteerIdsSet GROUP BY Volunteer_Opportunity__r.Volunteer_Name__c]) {
            volunteerRecentDateMap.put((Id)getRecentTimeSheet.get('volunteerName'), (Date)getRecentTimeSheet.get('maxTimeDate'));
        }
        for(Contact updateTimeSheetInfo : [SELECT Id, Timesheet_Date__c, RecordTypeId FROM Contact WHERE RecordTypeId =: volunteerRecordTypeId]) {
            if(volunteerRecentDateMap.containsKey(updateTimeSheetInfo.Id)) {
                updateTimeSheetInfo.Timesheet_Date__c = volunteerRecentDateMap.get(updateTimeSheetInfo.Id);
                volunteerInfoUpdate.add(updateTimeSheetInfo);
            }
             
        }
        if(volunteerInfoUpdate.size() > 0) {
            update volunteerInfoUpdate;
        }
    } */
    
     public Static void findRecentTimeSheetDate(Set<Id> timeSheetIds){ 
      
      //  Id volunteerUserId = userInfo.getUserId();
        //List<Contact> volunteerInfoUpdate = new List<Contact>();
        Map<Id,Contact> volunteerInfoUpdateMap = new Map<Id,Contact>();
        
       for(Time_sheet__c currRec : [SELECT Id,Date__c,Volunteer_Opportunity__r.Volunteer_Name__c,
                                             Volunteer_Opportunity__r.Volunteer_Name__r.Date_of_last_engagement__c 
                                             FROM Time_sheet__c WHERE Id IN : timeSheetIds]) {
            if(currRec.Volunteer_Opportunity__r.Volunteer_Name__r.Date_of_last_engagement__c== Null || currRec.Volunteer_Opportunity__r.Volunteer_Name__r.Date_of_last_engagement__c < currRec.Date__c)  
            {                               
                Contact updateContact = new Contact();
                updateContact.id = currRec.Volunteer_Opportunity__r.Volunteer_Name__c;
                updateContact.Date_of_last_engagement__c = currRec.Date__c;
                //volunteerInfoUpdate.add(updateContact);
                volunteerInfoUpdateMap.put(updateContact.Id,updateContact);
                
            }
        }
                if(volunteerInfoUpdateMap.size() > 0)
                  update volunteerInfoUpdateMap.Values();
      
    }
    //share the volunteer opportunity record with Edit Access to the current Volunteer user.
    public static void shareVolunteerOpportunity(Set<Id> volunteerOppIdSet){
        Set<Id>volOppIdSet = new Set<Id>();
        Set<Id> sharedIdSet = new Set<Id>();
         List<Volunteer_Opportunity__Share> volOpportunitySharingList = new List<Volunteer_Opportunity__Share>();
        List<user> currUser = [SELECT contactId,Id FROM User WHERE Id =: Userinfo.getUserId() AND contactId != Null];
        if(currUser.Size() > 0){
        for(Volunteer_Opportunity__C currRec : [SELECT Id FROM Volunteer_Opportunity__C WHERE Volunteer_Name__c != Null AND Volunteer_Name__c =:currUser[0].ContactId  AND Id IN: volunteerOppIdSet]){
               volOppIdSet.add(currRec.Id);  
              
           }
           
           if(volOppIdSet.Size() > 0){
               for(Volunteer_Opportunity__Share volOpp : [SELECT ParentId FROM Volunteer_Opportunity__Share WHERE ParentId IN:volOppIdSet]){
                   sharedIdSet.add(volOpp.Id);
                   
               }
               
               for(Id volunteerOppId : volOppIdSet){
                   if(!sharedIdSet.Contains(volunteerOppId)){
                        Volunteer_Opportunity__Share newVolOppShareRec = new Volunteer_Opportunity__Share();
                        newVolOppShareRec.ParentId = volunteerOppId;
                        newVolOppShareRec.AccessLevel ='Edit';
                        newVolOppShareRec.UserOrGroupId = currUser[0].Id;
                        newVolOppShareRec.rowcause=Schema.Volunteer_Opportunity__Share.RowCause.Grant_Edit_Access_to_assigned_Volunteer__C;
                        volOpportunitySharingList.add(newVolOppShareRec);
                        
                }
            }
            if(volOpportunitySharingList.size() > 0)
                insert volOpportunitySharingList;
        }
        }
   }
}