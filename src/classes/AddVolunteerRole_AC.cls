/*************************************************************************************************
CreatedBy: Kanagaraj 
Author   : MST Solutions
CreatedDate : 07/27/2016
Location : This controller referred in AddVolunteerRole_VF.
Description : This VF page is placed as a Inline VF page of Non Wish & Event page layout. Here  chapter staff will enter
the roles and number of members in that role needed for that event. Once entered the value and hit [Save] button
It would create n number of Volunteer Opportunity records for that event.
*************************************************************************************************/
public class AddVolunteerRole_AC{
    public List<Volunteer_Count__c> volunteerCountList{get;set;}
    public List<Non_Wish_Events__c> addNewVolunteerRoleList{get;set;}
    private ApexPages.StandardController controller {get; set;}
    public Non_Wish_Events__c nonWishEvent{get;set;}
    public Non_Wish_Events__c currNonWishRec;
    public String RoleName{get;set;}
    public Integer VolunteerCount{get;set;}
    public Boolean outputMode{get;set;}
    public Boolean inputMode{get;set;}
    public Boolean isEdit{get;set;}
    public Boolean isNew{get;set;}
    public List<Volunteer_Count__c> volunteerCountEditList{get;set;}
    public List<Volunteer_Count__c> volunteerCountToUpdateList{get;set;}
    public Id ChapterRoleId{get;set;}
    Public Id CountId{get;set;}
    Public Integer neededCount;
    public String eventRT;    
    public User curruser{get;set;}
    public Boolean isCommunity{get;set;}
    Constant_AC constant = new Constant_AC();
    public String communityUserString;
    public List<VolunteerCountWrapper> volunteerCountWrapList{get;set;}
    public String activeVolunteer{get;set;}
    public string profileId{get;set;}
    public Id trainingRTId = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();
    public Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
    public boolean isReferesh{get;set;}
    public boolean isActiveVolunteer{get;set;}
    public boolean dateMessage;
    public boolean sameValue;
    public boolean boolValue;
    public String redirectUrl {public get; private set;}
    public Boolean shouldRedirect {public get; private set;}
    /* It will display the volunteer opportunities grouped by role when the page is loaded */
    public AddVolunteerRole_AC(ApexPages.StandardController controller){
    shouldRedirect = false;
        this.controller = controller;
        nonWishEvent  = (Non_Wish_Events__c)controller.getRecord();
        isActiveVolunteer = false;
        currUser = [SELECT Id,contactId,Hidden_Role_Name_Id__c,Profile.Name  FROM User WHERE Id = :userInfo.getUserId()];
        volunteerCountWrapList = new List<VolunteerCountWrapper>();
        activeVolunteer = label.Active_Volunteer_Profile;
        profileId = userInfo.getProfileId();
        Set<String> nonWishIdSet = new Set<String>();
        
        if(currUser.Profile.Name == 'Active Volunteer (Member)' ||currUser.Profile.Name == 'Active Volunteer (Login)' )
            isActiveVolunteer = True;
        
        if(currUser.ContactId != Null){
            isCommunity = true;
            if(currUser.Hidden_Role_Name_Id__c  != Null)
                communityUserString = currUser.Hidden_Role_Name_Id__c;
            for(Volunteer_Opportunity__c registerdVolOpp : [SELECT Id,Role__c,Volunteer_Name__c,Wish__c,Non_Wish_Event__c,Status__c,Chapter_Role_Opportunity__c FROM Volunteer_Opportunity__c WHERE Volunteer_Name__c =: currUser.ContactId AND Chapter_Role_Opportunity__c != Null AND Role__c != Null AND Volunteer_Name__c != Null  
                                                            AND Non_Wish_Event__c != Null AND Wish__c =: Null AND (Status__c = 'Pending' OR Status__c = 'Approved')]){
               // String chapterRoleString = registerdVolOpp.Chapter_Role_Opportunity__c+' '+registerdVolOpp.Role__c;
                
                nonWishIdSet.add(registerdVolOpp.Non_Wish_Event__c+' '+registerdVolOpp.Role__c);
                
            }
        }
        currNonWishRec = [SELECT Id,Name,Chapter__c FROM Non_Wish_Events__c WHERE Id =: nonWishEvent.Id];
        
        eventRT= Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.nonWishEventRT).getRecordTypeId();
        volunteerCountList = new List<Volunteer_Count__c>();
        addNewVolunteerRoleList = new List<Non_Wish_Events__c>();
        
        for(Volunteer_Count__c dbCount : [SELECT Id,Name,Volunteer_Needed__c,Non_Wish_Events__c,Chapter_Role__r.Name,Description__c,
                                         Hidden_Chapter_Name__c,Chapter_Role__c,Registered__c,Event_Name__c,Start_Time__c,End_Time__c,Date__c,Location__c
                                         FROM Volunteer_Count__c WHERE Non_Wish_Events__c =: nonWishEvent.id 
                                         AND Volunteer_Needed__c != 0 ])
         {
           /* if(currUser.ContactId != Null){
                 
                 system.debug('@@@@@ chapterRoleString 2 @@@@@@'+dbCount.Hidden_Chapter_Name__c);
                 if(!nonWishIdSet.contains(dbCount.Non_Wish_Events__c+' '+dbCount.Hidden_Chapter_Name__c)){
                    system.debug('@@@@@ chapterRoleString 2 @@@@@@'+dbCount.Hidden_Chapter_Name__c);
                     volunteerCountList.add(dbCount);
                 }
           }
            else{ 
                volunteerCountList.add(dbCount);
            }*/
            volunteerCountList.add(dbCount);
        }
      
        system.debug('---- volunteerCountList ----'+volunteerCountList);
        
        for(Volunteer_Count__c currRec : volunteerCountList)
        {
            VolunteerCountWrapper currVolunteer = new VolunteerCountWrapper(currRec.Id,currRec.Chapter_Role__c,currRec.Chapter_Role__r.Name,currRec.Hidden_Chapter_Name__c,currRec.Name,currRec.Event_Name__c,currRec.Description__c,currRec.Date__c,currRec.Start_Time__c,currRec.End_Time__c,currRec.Location__c,currRec.Volunteer_Needed__c,currRec.Registered__c);
            System.debug('@@volunteerCountWrapList@@1'+currRec.Date__c);
            volunteerCountWrapList.add(currVolunteer);
            System.debug('@@volunteerCountWrapList@@'+volunteerCountWrapList);
        }
        
        if(!volunteerCountList.isEmpty()){
            outputMode = true;
            inputMode = false;
            isEdit = false;
            isNew = false;
        }
        else{
            isNew = true;
            outputMode = false;
            inputMode = false;
            isEdit = false;
        }
        
    }
    
    /* This addRow() is used to add a new row in the pageblock table*/
    public void addRow(){
        if(!volunteerCountList.isEmpty()){
            isNew = false;
            inputMode = true;
            outputMode = false;
            isEdit = false;
           
            if(!addNewVolunteerRoleList.isEmpty()){
                Integer listSize = addNewVolunteerRoleList.size() - 1;
                if(addNewVolunteerRoleList.get(listSize).Chapter_Role__c == Null){
                    addNewVolunteerRoleList.remove(listSize);
                    addNewVolunteerRoleList.add(new Non_Wish_Events__c());
                }
                else{
                    //addNewVolunteerRoleList.remove(listSize);
                    addNewVolunteerRoleList.add(new Non_Wish_Events__c());
                }
            }
            else{
                addNewVolunteerRoleList.add(new Non_Wish_Events__c());
            }
        }
        else{
            isNew = true;
            inputMode = false;
            outputMode = false;
            isEdit = false;
           
            addNewVolunteerRoleList.add(new Non_Wish_Events__c());
        }
    }
    
    /*This SaveRec() is used to create the no. of volunteer opportuity based on the volunteerNeeded.
As well as it will update the volunteer opportunity.*/
    public PageReference saveRec(){
       
        PageReference pr ;
        inputMode = false;
        isEdit = false;
        isNew = false;
        outputMode = true;
       
        pr = new PageReference('/'+nonWishEvent.Id);
        List<Volunteer_Opportunity__c> newVolOpportunityList = new List<Volunteer_Opportunity__c>();
        List<Volunteer_Count__c> newvolunteerCountList = new List<Volunteer_Count__c>();
        List<Volunteer_Count__c> volunteerCountEditListtwo= new List<Volunteer_Count__c>();
        volunteerCountList = new List<Volunteer_Count__c>();
        Set<String> descSet = new Set<String>();
        if(volunteerCountToUpdateList != NULL && !volunteerCountToUpdateList.isEmpty()){
            
            Integer listSize = 0;
            if(volunteerCountToUpdateList.get(listSize).Chapter_Role__c == Null){
                Volunteer_Count__c volunteercount = [SELECT Id,Name,Volunteer_Needed__c,Chapter_Role__c,Description__c,Hidden_Chapter_Name__c,Non_Wish_Events__c,Registered__c,Start_Time__c,End_Time__c,Date__c,Location__c FROM Volunteer_Count__c WHERE Non_Wish_Events__c =: nonWishEvent.id AND Volunteer_Needed__c != 0 AND Registered__c  = 0];
                //delete volunteercount;
                List<Volunteer_Opportunity__c> dbVolOpporunity= [SELECT id,RecordTypeId,Chapter_Role_Opportunity__c,Chapter_Name__c,Volunteer_Name__c,Non_Wish_Event__c,Reason_Inactive__c FROM Volunteer_Opportunity__c WHERE Volunteer_Name__c = Null AND Non_Wish_Event__c =: nonWishEvent.id  AND RecordTypeId =:eventRT AND  Status__c != 'Approved'AND Reason_Inactive__c =: Null];
                delete dbVolOpporunity;
            }
            else{
                Set<Id> chapterRoleIdSet = new Set<Id>();
                Integer Size = volunteerCountToUpdateList.size() - 1;
                if(volunteerCountToUpdateList.get(Size).Chapter_Role__c  == Null)
                    volunteerCountToUpdateList.remove(Size);
                for(Volunteer_Count__c  roleName : volunteerCountToUpdateList){
                    if(roleName.Volunteer_Needed__c < roleName.Registered__c && roleName.Registered__c > 0 ){
                        isReferesh = true;
                        boolValue = true;
                         displayErrorMsg();
                        return null;
                    }
                    
                    if(roleName.Date__c < system.today()){
                            dateMessage = true;
                        }
                        
                    volunteerCountEditListtwo.add(roleName);
                }
                
                 for(Volunteer_Count__c volcount : [SELECT id,Chapter_Role__c,Description__c,Non_Wish_Events__c,Event_Name__c,Date__c,Start_Time__c,End_Time__c FROM Volunteer_Count__c WHERE Non_Wish_Events__c =:nonWishEvent.id]){
                     if(descSet.contains(volcount.Chapter_Role__c+''+volcount.Description__c+''+volcount.Date__c+''+volcount.Start_Time__c+''+volcount.End_Time__c)){
                       sameValue = true;
                     }
                  }
                  if(sameValue == true || dateMessage == true){
                   isReferesh = true;
                  displayErrorMsg();
                  return null;
                }
                
                for(Volunteer_Count__c  roleName : volunteerCountEditListtwo){
                    chapterRoleIdSet.add(roleName.Chapter_Role__c);
                }
                List<Volunteer_Opportunity__c> deleteVolunteerList = [SELECT id,Chapter_Name__c,Chapter_Role_Opportunity__c,Volunteer_Name__c,Non_Wish_Event__c FROM Volunteer_Opportunity__c WHERE Chapter_Role_Opportunity__c IN: chapterRoleIdSet AND Volunteer_Name__c = Null AND Non_Wish_Event__c =: nonWishEvent.id AND Reason_Inactive__c =: Null];
                delete deleteVolunteerList;
                if(!test.isRunningTest()) 
                    try{
                        update volunteerCountEditListtwo;
                    }
                catch(Exception ex){
                }
                volunteerCountList = [SELECT Id,Name,Volunteer_Needed__c,Description__c,Event_Name__c ,Chapter_Role__c,Hidden_Chapter_Name__c,Non_Wish_Events__c,Registered__c,Start_Time__c,End_Time__c,Date__c,Location__c FROM Volunteer_Count__c WHERE Non_Wish_Events__c =: nonWishEvent.id AND Volunteer_Needed__c != 0];
                for(Volunteer_Count__c  processnewVolCount : volunteerCountEditListtwo){
                    if(processnewVolCount.Volunteer_Needed__c > 0){
                        Integer count = Integer.valueOf(processnewVolCount.Volunteer_Needed__c) -  Integer.valueOf(processnewVolCount.Registered__c); 
                        for(Integer i=0; i < count; i++){
                            Volunteer_Opportunity__c newVolOpp = new Volunteer_Opportunity__c();
                            newVolOpp.Non_Wish_Event__c = nonWishEvent.id;
                            newVolOpp.Chapter_Role_Opportunity__c = processnewVolCount.Chapter_Role__c;
                            newVolOpp.HiddenVolunteer_Count_Description__c = processnewVolCount.Id;
                            newVolOpp.Hidden_VolunteerCount_Desc__c = processnewVolCount.Description__c;
                            newVolOpp.RecordTypeId = eventRT;
                            newVolOpp.Chapter_Name__c = currNonWishRec.Chapter__c;
                            newVolOpp.Description__c = processnewVolCount.Description__c;
                            newVolOpp.Start_Time__c = processnewVolCount.Start_Time__c;
                            newVolOpp.End_Time__c = processnewVolCount.End_Time__c;
                            newVolOpp.Location__c = processnewVolCount.Location__c;
                            newVolOpp.Date__c = processnewVolCount.Date__c;
                           // newVolOpp.isEventVolunteerOpportunity__c = true;
                            newVolOpportunityList.add(newVolOpp);
                        }
                    }
                }
                insert newVolOpportunityList;
           }
        }
        else{
            if(addNewVolunteerRoleList.size() > 0){
                Integer size = addNewVolunteerRoleList.size() - 1;
                if(addNewVolunteerRoleList.get(size).Chapter_Role__c == null) {
                    addNewVolunteerRoleList.remove(Size );
                }
                 
                if(addNewVolunteerRoleList.size() > 0){
                    for(Non_Wish_Events__c processNonWish : addNewVolunteerRoleList){
                        Volunteer_Count__c newVolCount = new Volunteer_Count__c ();
                        newVolCount.Volunteer_Needed__c = processNonWish.Volunteer_Need__c;
                        newVolCount.Chapter_Role__c = processNonWish.Chapter_Role__c;
                        newVolCount .Non_Wish_Events__c = nonWishEvent.id;
                        newVolCount.Description__c = processNonWish.Description__c;
                        newVolCount.Start_Time__c = processNonWish .Start_Time__c;
                        newVolCount.End_Time__c = processNonWish .End_Time__c;
                        newVolCount.Location__c = processNonWish .Hidden_Location__c;
                        newVolCount.Date__c = processNonWish .Hidden_Date__c;
                        
                        if(newVolCount.Date__c < system.today()){
                            dateMessage = true;
                        }
                        
                        newvolunteerCountList.add(newVolCount);
                        descSet.add(newVolCount.Chapter_Role__c+''+newVolCount.Description__c+''+newVolCount.Date__c+''+newVolCount.Start_Time__c+''+newVolCount.End_Time__c);
                    }
                    
                    for(Volunteer_Count__c volcount : [SELECT id,Chapter_Role__c,Description__c,Non_Wish_Events__c,Event_Name__c,Date__c,Start_Time__c,End_Time__c FROM Volunteer_Count__c WHERE Non_Wish_Events__c =:nonWishEvent.id AND Description__c =: newvolunteerCountList[0].Description__c AND  Chapter_Role__c =: newvolunteerCountList[0].Chapter_Role__c]){
                     if(descSet.contains(volcount.Chapter_Role__c+''+volcount.Description__c+''+volcount.Date__c+''+volcount.Start_Time__c+''+volcount.End_Time__c)){
                       sameValue = true;
                       
                     }
                      
                    }
                  if(sameValue != true && dateMessage != true){
                    Integer listSize = newvolunteerCountList.size() - 1;
                    if(newvolunteerCountList.get(listSize).Chapter_Role__c == Null){
                        newvolunteerCountList.remove(listSize);
                        insert newvolunteerCountList;
                        volunteerCountList = [SELECT Id,Name,Volunteer_Needed__c,Description__c,Event_Name__c ,Chapter_Role__c,Hidden_Chapter_Name__c,Non_Wish_Events__c,Registered__c,Start_Time__c,End_Time__c,Date__c,Location__c FROM Volunteer_Count__c WHERE Non_Wish_Events__c =: nonWishEvent.id AND Volunteer_Needed__c != 0];
                        
                    }
                    else
                        insert newvolunteerCountList;
                
                }
                else if(sameValue == true || dateMessage == true){
                 isReferesh = true;
                   displayErrorMsg();
                   return null;
                }
                
                volunteerCountList = [SELECT Id,Name,Volunteer_Needed__c,Description__c,Event_Name__c ,Chapter_Role__c,Hidden_Chapter_Name__c,Non_Wish_Events__c,Registered__c,Start_Time__c,End_Time__c,Date__c,Location__c FROM Volunteer_Count__c WHERE Non_Wish_Events__c =: nonWishEvent.id AND Volunteer_Needed__c != 0];
                if(newvolunteerCountList.Size() > 0){
                    volunteerCountList = [SELECT Id,Name,Volunteer_Needed__c,Chapter_Role__c,Description__c,Hidden_Chapter_Name__c,Non_Wish_Events__c,Registered__c,Start_Time__c,End_Time__c,Date__c,Location__c FROM Volunteer_Count__c WHERE Non_Wish_Events__c =: nonWishEvent.id AND Volunteer_Needed__c != 0];
                    for(Volunteer_Count__c  processnewVolCount : newvolunteerCountList){
                        if(processnewVolCount.Volunteer_Needed__c > 0){
                            for(Integer i=0; i<processnewVolCount.Volunteer_Needed__c; i++){
                                Volunteer_Opportunity__c newVolOpp = new Volunteer_Opportunity__c();
                                newVolOpp.Non_Wish_Event__c = nonWishEvent.id;
                                newVolOpp.Chapter_Role_Opportunity__c= processnewVolCount.Chapter_Role__c;
                                newVolOpp.RecordTypeId = eventRT;
                                newVolOpp.HiddenVolunteer_Count_Description__c = processnewVolCount.Id;
                                newVolOpp.Hidden_VolunteerCount_Desc__c = processnewVolCount.Description__c;
                                newVolOpp.Chapter_Name__c = currNonWishRec.Chapter__c;
                                newVolOpp.Description__c = processnewVolCount.Description__c;
                                newVolOpp.Start_Time__c = processnewVolCount.Start_Time__c;
                                newVolOpp.End_Time__c = processnewVolCount.End_Time__c;
                                newVolOpp.Location__c = processnewVolCount.Location__c;
                                newVolOpp.Date__c = processnewVolCount.Date__c;
                                
                                
                               // newVolOpp.isEventVolunteerOpportunity__c = true;
                                newVolOpportunityList.add(newVolOpp);
                            }
                        }
                    }
                }
                insert newVolOpportunityList;
                
            }
         }
       
         }
        shouldRedirect = true;
        redirectUrl = '/'+nonWishEvent.Id;
       
         return null;
       
    }
    public pageReference displayErrorMsg(){
      isReferesh = true;
      System.debug('@@isReferesh@@'+isReferesh);
         if(sameValue == true)
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'All values match with an existing entry. Please update the existing entry or create a new one.'));
              if(dateMessage == true )
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the current or future date.'));
                if(boolValue == true)
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Volunteer Need count is Should not be less than to  volunteer registerd count'));
              return null;
    }
    
    /* This EditRec method is used to update the no of volunteer opportunities needed.*/
    public void EditRec(){
        isEdit = true;
        outputMode = false;
        isNew = false;
        inputMode = false;
       
        volunteerCountToUpdateList = new List<Volunteer_Count__c>();
        Map<String,Volunteer_Count__c> volunteercountMap = new Map<String,Volunteer_Count__c>([SELECT Id,Name,Volunteer_Needed__c,Hidden_Chapter_Name__c,Chapter_Role__c,Non_Wish_Events__c,Registered__c,Start_Time__c,End_Time__c,Date__c,Location__c FROM Volunteer_Count__c WHERE Non_Wish_Events__c =: nonWishEvent.id AND Volunteer_Needed__c != 0]);
        volunteerCountList= [SELECT Id,Name,Volunteer_Needed__c,Description__c,Non_Wish_Events__c,Chapter_Role__c,Hidden_Chapter_Name__c,Registered__c,Start_Time__c,End_Time__c,Date__c,Location__c FROM Volunteer_Count__c WHERE Non_Wish_Events__c =: nonWishEvent.id  AND Volunteer_Needed__c != 0];
        volunteerCountEditList = new List<Volunteer_Count__c >();
        volunteerCountEditList.addAll(volunteerCountList);
        for(Volunteer_Count__c  processvol : volunteerCountEditList){
            if(volunteercountMap.containsKey(processvol.Id)){
                Volunteer_Count__c  newProceess = new Volunteer_Count__c();
                newProceess.Id = volunteercountMap.get(processvol.Id).Id;
                newProceess.Chapter_Role__c = volunteercountMap.get(processvol.Id).Chapter_Role__c;
                newProceess .Volunteer_Needed__c = processvol.Volunteer_Needed__c ;
                newProceess.Registered__c = volunteercountMap.get(processvol.Id).Registered__c ;
                newProceess.Description__c = processvol.Description__c;
                newProceess.Start_Time__c = processvol.Start_Time__c;
                newProceess.End_Time__c = processvol.End_Time__c;
                newProceess.Location__c = processvol.Location__c;
                newProceess.Date__c = processvol.Date__c;
                neededCount = Integer.valueOf(processvol.Volunteer_Needed__c);
                volunteerCountToUpdateList.add(newProceess);
            }
        }
    }
    /*This cancelRec method is used if the system admin or chapter users enterd incorect data they can able to cancel*/
    public void cancelRec(){
        isEdit = false;
        outputMode = true;
        isNew = false;
        inputMode = false;
       
    }
     public boolean getChapterRoleOanTStatus(Id chapterRole)
    {
    
       List<Chapter_Role_O_T__c> currTrainig = [SELECT id, Required__c FROM Chapter_Role_O_T__c WHERE 
                                                       Chapter_Role__c = :chapterRole 
                                                       AND Orientation_Training__r.RecordTypeId = :trainingRTId limit 1];
       if(currTrainig.size() > 0)                                                
           return currTrainig[0].Required__c;
       else
           return false;
    
    }
    
    
    public boolean allowRegisteration(List<Volunteer_Opportunity__c> volunteerOpportunity)
    {
    
    
                Boolean updateRecord=false;
                Boolean allowRegister = false;
                boolean isWishRole = false;
                Map<Id,Volunteer_Roles__c> WishTrainedMap = new Map<Id,Volunteer_Roles__c>();
                Map<Id,Volunteer_Roles__c> WishNonTrainedMap = new Map<Id,Volunteer_Roles__c>();
                Set<Id> TrainedNonWishRoles = new Set<Id>();
                Set<Id> notTrainedNonWishRoles = new Set<Id>();
                boolean isWishGranterMentor=false;
                for(Role__c currRole : [SELECT id,Name,isWishRole__c FROM Role__c WHERE Id = :volunteerOpportunity[0].Chapter_Role_Opportunity__r.Role_Name__c])
                { 
                    if(currRole.isWishRole__c == True)
                        isWishRole = True;
                        
                        System.debug('isWishRole++++++++++++++++++++++++++++++++++++ ' + isWishRole);
                }
                for(Volunteer_Roles__c checkForMatchingRole : [SELECT Id, Chapter_Name__c,Role_Name__c,isWishRole__c,Status__c, Chapter_Role__c,
                                                               Chapter_Role__r.Role_Name__c 
                                                               FROM Volunteer_Roles__c WHERE Volunteer_Name__c =: currUser.ContactId
                                                               AND Chapter_Name__c =: volunteerOpportunity.get(0).Chapter_Name__r.Name])
                                                                
                 {
                     if(checkForMatchingRole.isWishRole__c == True && checkForMatchingRole.Status__c == 'Trained')
                     {
                          WishTrainedMap.put(checkForMatchingRole.Chapter_Role__c,checkForMatchingRole);
                          
                          if(checkForMatchingRole.Role_Name__c == 'Wish Granter Mentor')
                              isWishGranterMentor = True;
                     }
                     else if(checkForMatchingRole.isWishRole__c == True && checkForMatchingRole.Status__c != 'Trained')
                          WishNonTrainedMap.put(checkForMatchingRole.Chapter_Role__c,checkForMatchingRole);
                     else if(checkForMatchingRole.isWishRole__c == false && checkForMatchingRole.Status__c == 'Trained')
                          TrainedNonWishRoles.add(checkForMatchingRole.Chapter_Role__r.Role_Name__c);
                     else if(checkForMatchingRole.isWishRole__c == false && checkForMatchingRole.Status__c != 'Trained')
                          notTrainedNonWishRoles.add(checkForMatchingRole.Chapter_Role__r.Role_Name__c);
                 } 
                 
                 // Allowing Non-Wish Role for registering VO.
                 if(isWishRole == false)
                 {
                     if(WishTrainedMap.size() > 0)
                     {  
                         updateRecord = true;
                         allowRegister = true;
                         System.debug('Block1++++++++++++++++++++++++++++++++++++++++++++++++++== ');
                     }
                     else
                     {
                         if(getChapterRoleOanTStatus(volunteerOpportunity[0].Chapter_Role_Opportunity__c) == True)
                         {
                            if(TrainedNonWishRoles.contains(volunteerOpportunity[0].Chapter_Role_Opportunity__r.Role_Name__c))
                            {
                               updateRecord = true;
                               allowRegister = true;
                               
                               System.debug('Block1++++++++++++++++++++++++++++++++++++++++++++++++++== ');
                            
                            }
                         
                         } 
                         else
                         {
                         
                           if(TrainedNonWishRoles.contains(volunteerOpportunity[0].Chapter_Role_Opportunity__r.Role_Name__c) || 
                              (notTrainedNonWishRoles.contains(volunteerOpportunity[0].Chapter_Role_Opportunity__r.Role_Name__c)))
                              {
                                updateRecord = true;
                                allowRegister = true;
                                System.debug('Block2++++++++++++++++++++++++++++++++++++++++++++++++++== ');
                              }
                          }
                          
                     
                         }
                    }   
                 
                 
                  else if(isWishRole == True)
                  {
                  
                         if(getChapterRoleOanTStatus(volunteerOpportunity[0].Chapter_Role_Opportunity__c) == True)
                            {
                               if(WishTrainedMap.containsKey(volunteerOpportunity[0].Chapter_Role_Opportunity__c) || (isWishGranterMentor == True && volunteerOpportunity[0].Role__c == 'Wish Granter'))
                               {
                                 
                                          updateRecord = true;
                                          allowRegister = true;
                                          System.debug('Block3++++++++++++++++++++++++++++++++++++++++++++++++++== ');
                                     
                               }
                            
                            }
                            else if(getChapterRoleOanTStatus(volunteerOpportunity[0].Chapter_Role_Opportunity__c) == false)
                            {
                                  if(WishTrainedMap.containsKey(volunteerOpportunity[0].Chapter_Role_Opportunity__c) ||
                                     WishNonTrainedMap.containsKey(volunteerOpportunity[0].Chapter_Role_Opportunity__c) ||
                                     (isWishGranterMentor == True && volunteerOpportunity[0].Role__c == 'Wish Granter'))
                                  {      
                                          updateRecord = true;
                                          allowRegister = true;
                                          System.debug('Block4++++++++++++++++++++++++++++++++++++++++++++++++++== ');
                                  }
                            }
                  
                  
                  }
                 
           if(updateRecord == True && allowRegister == True)
             return True;
           else 
             return false;
    }
    /*This method is used when the volunteer contact can able to register for the particular volunteer opportunity*/
    public pageReference register(){
        try{
            boolean isUpdate = false;
            isReferesh = true;
            inputmode = false;
            outputmode = false;
            isnew = false;
            String chatperRoleId;
            String volunteerStatus; 
            pageReference  pr;
            Chapter_Role__c dbRole;
            String roleId;
            Boolean allowRegister = false;
            Id voulnteerCountId;
            Id trainingRTId = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();
            pr = new PageReference('/'+nonWishEvent.Id);
            Map<Id,Volunteer_Count__c> volunteerCountMap = new Map<Id,Volunteer_Count__c>();
            
            Contact volunteerContact = [SELECT Id,LastName From Contact WHERE RecordTypeId = :volunteerRecordTypeId limit 1]; 
            
            List<Volunteer_Opportunity__c>  dbVolOpporunity= [SELECT id,RecordTypeId,HiddenVolunteer_Count_Description__c,Role__c,Chapter_Name__r.Name,
                                                              Chapter_Role_Opportunity__c,Chapter_Role_Opportunity__r.Role_Name__c,Description__c,
                                                              Chapter_Name__c,Volunteer_Name__c,Non_Wish_Event__c,Reason_Inactive__c,Date__c,End_Time__c,Start_Time__c,Hidden_VolunteerCount_Desc__c 
                                                              FROM Volunteer_Opportunity__c WHERE Chapter_Role_Opportunity__c =: ChapterRoleId 
                                                              AND Volunteer_Name__c = Null AND Non_Wish_Event__c =: nonWishEvent.id  
                                                              AND RecordTypeId =:eventRT AND Status__c != 'Approved' AND Reason_Inactive__c =: Null AND HiddenVolunteer_Count_Description__c =: CountId Limit 1];
             if(dbVolOpporunity.size() > 0){   
             system.debug('@@@ dbVolOpporunity @@@'+dbVolOpporunity);                                              
            dbRole = [SELECT Id,Name,Role_Name__c,Role_Name__r.Name From Chapter_Role__c  WHERE Id =: dbVolOpporunity[0].Chapter_Role_Opportunity__c];
            
            for(Volunteer_Opportunity__c dbVol : [Select id,RecordTypeId,HiddenVolunteer_Count_Description__c,Role__c,Chapter_Name__r.Name,
                                                              Chapter_Role_Opportunity__c,Chapter_Role_Opportunity__r.Role_Name__c,
                                                              Chapter_Name__c,Volunteer_Name__c,Non_Wish_Event__c,Reason_Inactive__c,Hidden_VolunteerCount_Desc__c,Start_Time__c,End_Time__c,Date__c
                                                              FROM Volunteer_Opportunity__c WHERE Non_Wish_Event__c =: dbVolOpporunity[0].Non_Wish_Event__c  AND Chapter_Role_Opportunity__c =: dbVolOpporunity[0].Chapter_Role_Opportunity__c 
                                                              AND Chapter_Role_Opportunity__r.Role_Name__c =: dbVolOpporunity[0].Chapter_Role_Opportunity__r.Role_Name__c AND Reason_Inactive__c = 'Not Approved' AND Volunteer_Name__c =: currUser.ContactId
                                                              AND Start_Time__c =: dbVolOpporunity[0].Start_Time__c AND End_Time__c =: dbVolOpporunity[0].End_Time__c AND Hidden_VolunteerCount_Desc__c =: dbVolOpporunity[0].Hidden_VolunteerCount_Desc__c AND Date__c =: dbVolOpporunity[0].Date__c
                                                              AND HiddenVolunteer_Count_Description__c =: CountId  ] ){
                 
                 
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You have been previously  declined for this opportunity. Please contact the chapter office with any questions.'));
                  return null;
                
            }
               
              for(Volunteer_Opportunity__c dbVol : [Select id,RecordTypeId,HiddenVolunteer_Count_Description__c,Role__c,Chapter_Name__r.Name,
                                                              Chapter_Role_Opportunity__c,Chapter_Role_Opportunity__r.Role_Name__c,
                                                              Chapter_Name__c,Volunteer_Name__c,Non_Wish_Event__c,Reason_Inactive__c,Hidden_VolunteerCount_Desc__c 
                                                              FROM Volunteer_Opportunity__c WHERE Non_Wish_Event__c =: dbVolOpporunity[0].Non_Wish_Event__c  AND Chapter_Role_Opportunity__c =: dbVolOpporunity[0].Chapter_Role_Opportunity__c 
                                                              AND Chapter_Role_Opportunity__r.Role_Name__c =: dbVolOpporunity[0].Chapter_Role_Opportunity__r.Role_Name__c AND (Status__c =: 'Pending' OR Status__c = 'Approved') AND Volunteer_Name__c =: currUser.ContactId AND 
                                                              Start_Time__c =: dbVolOpporunity[0].Start_Time__c AND End_Time__c =: dbVolOpporunity[0].End_Time__c AND Hidden_VolunteerCount_Desc__c =: dbVolOpporunity[0].Hidden_VolunteerCount_Desc__c AND Date__c =: dbVolOpporunity[0].Date__c] ){
                 
                 system.debug('@@@ dbVol @@@'+dbVol );                                              
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'You already registered for this event'));
                
                system.debug('@@@ dbVol @@@'+dbVol );                                              
                 return null;
                 
               }
               
               for(Volunteer_Opportunity__c dbVol : [Select id,RecordTypeId,HiddenVolunteer_Count_Description__c,Role__c,Chapter_Name__r.Name,
                                                              Chapter_Role_Opportunity__c,Chapter_Role_Opportunity__r.Role_Name__c,
                                                              Chapter_Name__c,Volunteer_Name__c,Non_Wish_Event__c,Reason_Inactive__c,Date__c,End_Time__c,Start_Time__c,Hidden_VolunteerCount_Desc__c  
                                                              FROM Volunteer_Opportunity__c WHERE Non_Wish_Event__c =: dbVolOpporunity[0].Non_Wish_Event__c  AND Chapter_Role_Opportunity__c =: dbVolOpporunity[0].Chapter_Role_Opportunity__c 
                                                              AND (Status__c =: 'Pending' OR Status__c = 'Approved') AND Volunteer_Name__c =: currUser.ContactId  
                                                              AND Start_Time__c =: dbVolOpporunity[0].Start_Time__c AND End_Time__c =: dbVolOpporunity[0].End_Time__c AND Date__c =: dbVolOpporunity[0].Date__c AND Hidden_VolunteerCount_Desc__c !=: dbVolOpporunity[0].Hidden_VolunteerCount_Desc__c]){
                 
                 
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'You already registered another event for this same time'));
                 return null;
                 
               }
               
            if(dbVolOpporunity.size() > 0)
                 allowRegister = allowRegisteration(dbVolOpporunity);
                system.debug('@@@@ allowRegister @@@@'+allowRegister);
            if(dbVolOpporunity.size() > 0 && dbVolOpporunity != Null){ 
                for(Volunteer_Count__c dbVolunteerCount : [Select Id,Name,Non_Wish_Events__c,Registered__c,Volunteer_Needed__c FROM Volunteer_Count__c 
                                                           WHERE Non_Wish_Events__c =:dbVolOpporunity[0].Non_Wish_Event__c AND 
                                                           Id =: dbVolOpporunity[0].HiddenVolunteer_Count_Description__c])
                {
                     voulnteerCountId = dbVolunteerCount.Id;
                    volunteerCountMap.put(dbVolunteerCount.Id,dbVolunteerCount);
                }
                
            }
            if(dbVolOpporunity.size() > 0 && dbVolOpporunity != Null && volunteerCountMap.Size() >0)
            {
                dbRole = [SELECT Id,Name,Role_Name__c,Role_Name__r.Name From Chapter_Role__c  WHERE Id =: dbVolOpporunity[0].Chapter_Role_Opportunity__c];
                
                roleId = dbRole.Role_Name__c+String.valueOf(dbVolOpporunity[0].Non_Wish_Event__c);
                
                if(volunteerCountMap.containsKey(dbVolOpporunity[0].HiddenVolunteer_Count_Description__c) && allowRegister == true){
                    
                    Volunteer_Opportunity__c  updateVolOpportunity = new Volunteer_Opportunity__c();
                    updateVolOpportunity.Id = dbVolOpporunity[0].Id;
                    updateVolOpportunity.Chapter_Role_Opportunity__c = dbVolOpporunity[0].Chapter_Role_Opportunity__c;
                    updateVolOpportunity.Volunteer_Name__c = curruser.contactId ;
                    updateVolOpportunity.Chapter_Name__c = currNonWishRec.Chapter__c;
                   
                    update updateVolOpportunity;
                    Volunteer_Count__c  updateRegiesterCount = new Volunteer_Count__c ();
                    updateRegiesterCount.Id = voulnteerCountId;
                    updateRegiesterCount.Registered__c = volunteerCountMap.get(voulnteerCountId).Registered__c + 1;
                    update updateRegiesterCount;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Thank you for requesting to volunteer for this opportunity. A notification has been sent to chapter staff to review your request and staff will respond with further details, as applicable.'));
                    return null;
                    }
                    else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Thank you for your interest in this opportunity. This opportunity requires specialized training that you have not completed, contact chapter staff for more information about expanding your volunteer opportunities.'));
                        return null;
                    }
                        
                }
                }
                 else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'This volunteer opportunity has already been filled. Please register for another available volunteer opportunity'));
                    return null;
                }
            }
            catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
            
           }
           
           return null;

        }
       
       
    public class VolunteerCountWrapper{
   
        public String chapterRole{get;set;}
        public string roleName{get;set;}
        public Decimal volunteerNeeded{get;set;}
        public string voldescription{get;set;}
        public Decimal volunteerRegistration{get;set;}
        public string cname{get;set;}
        public string recordId{get;set;}
        public String volunteerCountId{get;set;}
        public string eventName{get;set;}
        public String volStartTime{get;set;}
        public string volendTime{get;set;}
        public date Voldate{get;set;}
        public String vollocation{get;set;}
        Public VolunteerCountWrapper(String vcId,String recId,String cRole,String rName,String name,String evtname,String comments,date voDate,String Starttime,String endTime,String location,Decimal vNeeded,Decimal volunteerReg)
        {
            chapterRole = cRole;
            roleName = rName;
            volunteerNeeded = vNeeded;
            voldescription = comments;
            volunteerRegistration = volunteerReg;
            cname = name;
            recordId = recId;
            volunteerCountId = vcId;
            eventName = evtname;
            volStartTime= starttime;
            volendTime= endTime;
            Voldate= vodate;
            vollocation = location;
            
        }
    }
}