/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Vennila Paramasivam
Date        : 7/28/2016
Description : It will display all the Required and Non Required Training(Chapter Role based Training) on Active Portal
Which are not completed by the volunteer. If user tries to register same training for different timing, It will 
throw an error message. And also If the User register for multiple training at same timing that time also It will
throw an error message. Once the user registered for the training then VolunteerOpportunity Orientation and Training 
Record will create with Registered status. If user cancelled the registered training then the status would update as 
Cancelled. 
*******************************************************************************************************************/

public class VolunteerActiveTraining_AC {
    
    public List<Volunteer_Orientation_Training__c> volunteerRelatedTrainingsList;
    public List<Orientation_Training__c> volunteerTrainingsList{get;set;}
    public Id trainingId {get;set;}
    public Id userRelatedContactId;
    public Id currentUserId;
    public Id chapterId;
    public String lMSCourseId {get;set;}
    public String sSOUrl{get;set;}
    public String courseURL{get;set;}
    public Id classOffereningRecordtypeId{get;set;}
    public Map<Id,Volunteer_Orientation_Training__c> trainingsMap;
    public List<Volunteer_Orientation_Training__c> checkExistingTrainingRecords;
    public List<Volunteer_Orientation_Training__c> checkExistingCanceledRecords;
    Constant_AC  constant = new Constant_Ac(); 
    public Id trainingRecordTypeId = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();
    public Map<String, Integer> startTimeMap;
    public Map<String, Integer> endTimeMap;
    Public Id primaryChapterId ;
    Public String orientationContent{get;set;}
    Public Boolean checkExistProgram {get;set;}
    private integer counter=0;  //keeps track of the offset
    private integer list_size=20; //sets the page size or number of rows
    public integer total_size{get;set;} //used to show user the total size of the list
    public List<Volunteer_Orientation_Training__c> dupCheckList;
    List<User> getUserRelatedContact;
    public boolean isTrainingExist{get;set;}
    public Boolean isCancelled {get;set;}
    Public Boolean isCompleted {get;set;}
    public Map<Id,Class_Offering__c> registeredClassOfferingMap = new Map<Id,Class_Offering__c>();
    public Map<Id,Class_Offering__c> classOfferingMap;
    public boolean bgTabPermission{get;set;}
    public boolean trainingTabVisible{get;set;} 
    public LMSSSORespose lMSSSOResponse;
    private String endPointURL;
    private String username;
    private String password;
    private LMS_Credentials__c lMSCredential;
     
    public VolunteerActiveTraining_AC() {  
        System.debug('VA Load Begin 1');
        isCompleted = False;
        dupCheckList = new List<Volunteer_Orientation_Training__c>();
        checkExistingTrainingRecords = new List<Volunteer_Orientation_Training__c>();
        currentUserId = userInfo.getUserId();
        classOffereningRecordtypeId = Schema.Sobjecttype.Class_Offering__c.getRecordTypeInfosByName().get(constant.classOfferingRecordTypeId).getRecordTypeId();
        getUserRelatedContact = [SELECT Id,contact.Region_Chapter__c,contact.Region_Chapter__r.Chapter_Id__c,Username, LMS_Login__c, LMS_Id__c, ContactId, LMS_User_Code__c,FirstName,LastName,Email FROM User WHERE Id=:currentUserId];
        lMSCredential = LMS_Credentials__c.getValues('LMS Integration');
        userRelatedContactId = getUserRelatedContact.get(0).ContactId;
        System.debug('VA Load Begin 2');
        String nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.nationalRT).getRecordTypeId();
        
        // Displaying the Dynamic content on the portal.
        List<Dynamic_Content__c> dynamicContent = [SELECT Id, Training_Additional_Info__c,Chapter_Name__c FROM Dynamic_Content__c WHERE  RecordTypeId = :nationalRT AND Active__c = True];
        if(dynamicContent.size() >0) {
            orientationContent = dynamicContent.get(0).Training_Additional_Info__c;
        }
        checkRegisteredProgram();
        System.debug('VA Load Begin 3');
    }
    
    // It will check the registered program on Volunteer Orientatoin and Training, If training is available then it will display
    // the registered training in a separate block. 
    public Boolean checkRegisteredProgram() 
    {
        List<Volunteer_Orientation_Training__c> exVolList = [SELECT Id, Hidden_O_T_Id__c, Volunteer__c, Volunteer_Attendance__c 
                                                             FROM Volunteer_Orientation_Training__c WHERE Volunteer__c =:userRelatedContactId AND Type__c = 'Training' 
                                                             AND (Volunteer_Attendance__c = 'Registered' OR Volunteer_Attendance__c = 'Completed')
                                                            ];
        if(exVolList.size() > 0) {
            checkExistProgram = false;
        } else {
            checkExistProgram = true;
        }
        return checkExistProgram;
    }
    
    // Fetching all the chapter role based training for the volunteer chapter and It will display on the Training page
    // If that training not done by Volunteer.
    public List<classOfferingWrapper> getTrainingRecordList() 
    {
        
        classOfferingMap = new Map<Id,Class_Offering__c>();
        Set<Id> chapterIds = new Set<Id>();
        userRelatedContactId = getUserRelatedContact.get(0).ContactId;
        
        for(Volunteer_Roles__c currRec : [SELECT id, Chapter_Role__c,Chapter_Role__r.Chapter_Name__c FROM Volunteer_Roles__c WHERE Volunteer_Name__c = :userRelatedContactId]) 
        {
            chapterIds.add(currRec.Chapter_Role__r.Chapter_Name__c);
        }
        
        Set<Id> completedTrainingsSet = new Set<Id>();
        for(Volunteer_Orientation_Training__c checkTrainingDetails : [SELECT Id, class_Offering__c, class_Offering__r.Chapter_Role_O_T__c, Volunteer__c, Volunteer_Attendance__c FROM Volunteer_Orientation_Training__c WHERE Volunteer__c =:userRelatedContactId AND Type__c = 'Training']) {
            if(checkTrainingDetails.Volunteer_Attendance__c == 'Completed') {
                completedTrainingsSet.add(checkTrainingDetails.class_Offering__r.Chapter_Role_O_T__c);
            }
        }
        
        
        if(chapterIds.size() > 0)
        {
            classOfferingMap.putAll([SELECT id,Name,Chapter__c,Date__c,End_Time__c,Course_ID__c,recordtypeid, recordtype.name,Chapter_Role_O_T__c,Chapter_Role_O_T__r.Orientation_Training__r.Name,
                                     Location__c,max_capacity__c,Start_Time__c,Type__c,Orientation_and_Training__c,Registered_Seats__c, AvailableSeats__c, Chapter_Role_O_T__r.Orientation_Training__c,
                                     (SELECT Id, Name, Volunteer_Attendance__c FROM Volunteer_Orientation_Trainings__r WHERE Volunteer__c =: getUserRelatedContact.get(0).ContactId)  FROM 
                                     Class_Offering__c WHERE 
                                     Chapter_Role_O_T__r.Chapter_Role__r.chapter_name__c IN :chapterIds AND Chapter_Role_O_T__r.Orientation_Training__r.RecordTypeId =: trainingRecordTypeId   AND  ((Date__c >= :Date.Today() AND Date__c <= :Date.today().addMonths(6)) OR Date__c = Null) ORDER BY Name limit :list_size offset :counter]);
            
            List<AggregateResult> countAgg = [SELECT count(Id) FROM Class_Offering__c  WHERE Chapter_Role_O_T__r.Required__c = True AND 
                                              Chapter_Role_O_T__r.Chapter_Role__r.chapter_name__c  IN :chapterIds AND Chapter_Role_O_T__r.Orientation_Training__r.RecordTypeId =: trainingRecordTypeId  AND Date__c = NEXT_N_DAYS:180];                 
            
            total_size = (countAgg != null && countAgg.size() > 0) ? (Integer) countAgg[0].get('expr0') : 0;                     
        }
        List<classOfferingWrapper> classOfferingList = new List<classOfferingWrapper>();  
        for(Class_Offering__c currRec : classOfferingMap.values())
        {
            classOfferingWrapper newWrapper = new classOfferingWrapper();
            newWrapper.orientationName = currRec.Orientation_and_Training__c;
            newWrapper.chapterName = currRec.Chapter__c;
            newWrapper.orientationDate = currRec.Date__c;
            newWrapper.startTime = currRec.Start_Time__c;
            newWrapper.endTime= currRec.End_Time__c;
            newWrapper.location = currRec.Location__c;
            newWrapper.maxCapacity = integer.valueOf(currRec.max_capacity__c);
            newWrapper.avilableSheets = integer.valueOf(currRec.AvailableSeats__c);
            newWrapper.recordType = currRec.recordType.name;
            newWrapper.recordId = currRec.id;
            newWrapper.volOppSize = currRec.Volunteer_Orientation_Trainings__r.size();
            newWrapper.courseId = currRec.course_Id__c;
            newWrapper.recordTypeId = currRec.RecordTypeid;
            if( currRec.Volunteer_Orientation_Trainings__r.size() > 0)
                newWrapper.status= currRec.Volunteer_Orientation_Trainings__r[0].Volunteer_Attendance__c;
            if(((currRec.max_capacity__c == Null) || (currRec.max_capacity__c >0 && currRec.max_capacity__c > currRec.Registered_Seats__c))
               && ((newWrapper.volOppSize > 0 && newWrapper.status == 'Volunteer Cancelled') || newWrapper.volOppSize == 0))
                newWrapper.displayRec = true;
            else
                newWrapper.displayRec = false;
            classOfferingList.add(newWrapper);
        }   
        
        isTrainingExist = false;
        isCancelled = false;
        TimingInfo();
        
        checkRegisteredProgram();
        return classOfferingList;
    }
    
    // Mapping some additional key value for Start and End Time. Using this value, we can prevent the volunteer training time conflict.
    Public void TimingInfo() {
        
        startTimeMap = new Map<String, Integer>();
        endTimeMap = new Map<String, Integer>();
        Schema.DescribeFieldResult startTimeResult = Class_Offering__c.Start_Time__c.getDescribe();
        List<Schema.PicklistEntry> startTimeValues = startTimeResult.getPicklistValues();
        Integer i = 0;
        for( Schema.PicklistEntry startTime : startTimeValues){
            startTimeMap.put(startTime.getValue(),i);
            i++;
        }
        Schema.DescribeFieldResult endTimeResult = Class_Offering__c.End_Time__c.getDescribe();
        List<Schema.PicklistEntry> endTimeValues = endTimeResult.getPicklistValues();
        Integer j = 0;
        for( Schema.PicklistEntry endTime : endTimeValues){
            endTimeMap.put(endTime.getValue(),j);
            j++;
        }
    }
    // It will create a new Volunteer Orientation Training for the Class Offering. 
    // Suppose cancelled volunteer Orientation & Training record available for the class offering,
    // Then it will update the existing cancelled record status as Registered.
    // If the volunteer registered the training same time for two diferent training, then it will throw and error message.
    public void Register() {
        
        LMSUserResponse currLMSUserResponse = new LMSUserResponse();
        Set<String> checkDupSets = new Set<String>();
        List<Class_Offering__c> classOfferingDetails = new List<Class_Offering__c>();
        
        
        if(classOfferingMap.containsKey(trainingId))
        {
            classOfferingDetails.add(classOfferingMap.get(trainingId));
        }
        
        
        List<Volunteer_Orientation_Training__c> existingRecList= [SELECT Id, class_offering__c, class_offering__r.Start_Time__c, class_offering__r.End_Time__c,FORMAT(class_offering__r.Date__c),  class_offering__r.Chapter__c, Volunteer__c, Volunteer_Attendance__c 
                                                                  FROM Volunteer_Orientation_Training__c WHERE Volunteer__c =:userRelatedContactId AND Hidden_O_T_Id__c=:classOfferingMap.get(trainingId).Chapter_Role_O_T__r.Orientation_Training__c AND  (Volunteer_Attendance__c = 'Completed' Or Volunteer_Attendance__c = 'Registered') AND Type__c = 'Training'];
        
        if(existingRecList.size() > 0 && !isCompleted)
        {
          
           /* ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have already registered for a training.');
            ApexPages.addMessage(myMsg);*/
             for(Volunteer_Orientation_Training__c currRec : existingRecList){
                 if(currRec.Volunteer_Attendance__c == 'Completed'){
                     isCompleted = True;
                 }
             }
             if(!(isCompleted)){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have already registered for a training.');
                 ApexPages.addMessage(myMsg);
             }
        }
        
        else {
            if(classOfferingDetails.size() > 0) {
                Map<Id, List<Volunteer_Orientation_Training__c>> trainingMaps = new Map<Id, List<Volunteer_Orientation_Training__c>>();
                checkExistingCanceledRecords = [SELECT Id, class_offering__c, class_offering__r.Start_Time__c, class_offering__r.recordtypeid, class_offering__r.End_Time__c,FORMAT(class_offering__r.Date__c),  class_offering__r.Chapter__c, Volunteer__c, Volunteer_Attendance__c 
                                                FROM Volunteer_Orientation_Training__c WHERE Volunteer__c =: userRelatedContactId AND class_offering__c = :trainingId AND Hidden_O_T_Id__c=:classOfferingMap.get(trainingId).Chapter_Role_O_T__r.Orientation_Training__c AND Volunteer_Attendance__c = 'Volunteer Cancelled'];
                if(checkExistingCanceledRecords.size()>0) {
                    if(checkExistingCanceledRecords.get(0).class_offering__r.recordtypeid == classOffereningRecordtypeId){
                        if(getUserRelatedContact.size() > 0 && lMSCredential != Null){
                            User currVolunteerUser = getUserRelatedContact.get(0); 
                            currLMSUserResponse = LMSHttpRequest.createOrActivateLMSUser(currVolunteerUser,lMSCredential);            
                        }
                        LMSOrientationRegistrationResponse currLMSOrientationRegistrationResponse = new LMSOrientationRegistrationResponse();
                        currLMSOrientationRegistrationResponse = LMSHttpRequest.createOrUpdateEnrollment(lMSCredential,classOfferingMap.get(trainingId).Course_ID__c,currLMSUserResponse.login,'in-progress');
                    }
                    
                    List<Volunteer_Orientation_Training__c> updateList = new List<Volunteer_Orientation_Training__c>();
                    Set<String> c = new Set<String>();
                    List<Volunteer_Orientation_Training__c> checkforExistingBeforeRegister = [SELECT Id, FORMAT(class_Offering__r.Date__c), class_Offering__c, class_Offering__r.Start_Time__c, class_Offering__r.End_Time__c, class_Offering__r.Chapter__c, Volunteer__c, Volunteer_Attendance__c FROM Volunteer_Orientation_Training__c WHERE Type__c = 'Training'  AND Volunteer__c =:userRelatedContactId AND class_offering__r.Date__c =: checkExistingCanceledRecords.get(0).class_offering__r.Date__c AND (Volunteer_Attendance__c != 'Volunteer Cancelled' AND Volunteer_Attendance__c != 'Completed')];
                    if(checkforExistingBeforeRegister.size()>0) {
                        for(Volunteer_Orientation_Training__c checkExistingTrainings : checkforExistingBeforeRegister) {
                            
                            if( ((Integer.valueOf(startTimeMap.get(checkExistingCanceledRecords.get(0).class_offering__r.Start_Time__c))) >= (Integer.valueOf(startTimeMap.get(checkExistingTrainings.class_offering__r.Start_Time__c)))) && ((Integer.valueOf(startTimeMap.get(checkExistingCanceledRecords.get(0).class_offering__r.Start_Time__c))) >= (Integer.valueOf(startTimeMap.get(checkExistingTrainings.class_offering__r.End_Time__c)))) 
                               || ((Integer.valueOf(startTimeMap.get(checkExistingCanceledRecords.get(0).class_offering__r.End_Time__c))) <= (Integer.valueOf(startTimeMap.get(checkExistingTrainings.class_offering__r.Start_Time__c)))) && ((Integer.valueOf(startTimeMap.get(checkExistingCanceledRecords.get(0).class_offering__r.End_Time__c))) <= (Integer.valueOf(startTimeMap.get(checkExistingTrainings.class_offering__r.End_Time__c))))) {
                                   checkExistingCanceledRecords.get(0).Volunteer_Attendance__c = 'Registered';
                                   checkExistingCanceledRecords.get(0).class_offering__c = trainingId;
                                   updateList.add(checkExistingCanceledRecords[0]);
                                   
                                   
                               } else {
                                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have already registered for a training on the same day at this time');
                                   ApexPages.addMessage(myMsg);
                                   // return null;
                               }
                        }
                        if(updateList.size()>0) {
                            update updateList;
                            isCancelled = false;
                            isTrainingExist = true;
                            isCompleted = False;
                            checkRegisteredProgram();
                        }
                        
                    } else {
                        checkExistingCanceledRecords.get(0).Volunteer_Attendance__c = 'Registered';
                        checkExistingCanceledRecords.get(0).class_offering__c = trainingId;
                        update checkExistingCanceledRecords;
                        isCancelled = false;
                        isCompleted = False;
                        isTrainingExist = true;
                        checkRegisteredProgram();
                    }
                }          
                
                else 
                {
                    Set<String> existingTrainingSet = new Set<String>();
                    for(Volunteer_Orientation_Training__c checkExistingTrainings : [SELECT Id, FORMAT(class_offering__r.Date__c), class_offering__c, class_offering__r.Start_Time__c, class_offering__r.End_Time__c, class_offering__r.Chapter__c, Volunteer__c, Volunteer_Attendance__c FROM Volunteer_Orientation_Training__c WHERE Type__c = 'Training' AND class_offering__r.Date__c =: classOfferingDetails.get(0).Date__c AND (Volunteer_Attendance__c != 'Volunteer Cancelled' AND Volunteer_Attendance__c != 'Completed') AND Volunteer__c =:userRelatedContactId]) {
                        
                        if(!existingTrainingSet.contains(startTimeMap.get(checkExistingTrainings.class_offering__r.Start_Time__c)+'-'+endTimeMap.get(checkExistingTrainings.class_offering__r.End_Time__c))) {
                            existingTrainingSet.add(startTimeMap.get(checkExistingTrainings.class_offering__r.Start_Time__c)+'-'+endTimeMap.get(checkExistingTrainings.class_offering__r.End_Time__c));
                        }
                    }
                    for(String iterateExistingValues : existingTrainingSet) {
                        if(classOfferingDetails.get(0).Start_Time__c !=null  && classOfferingDetails.get(0).End_Time__c !=null ){  
                            if((Integer.valueOf(startTimeMap.get(classOfferingDetails.get(0).Start_Time__c))>=Integer.valueOf(iterateExistingValues.split('-')[0])) && (Integer.valueOf(startTimeMap.get(classOfferingDetails.get(0).Start_Time__c))>=Integer.valueOf(iterateExistingValues.split('-')[1]))
                               || (Integer.valueOf(startTimeMap.get(classOfferingDetails.get(0).End_Time__c))<=Integer.valueOf(iterateExistingValues.split('-')[0])) && (Integer.valueOf(startTimeMap.get(classOfferingDetails.get(0).End_Time__c))<=Integer.valueOf(iterateExistingValues.split('-')[1]))) {
                                   
                               } else {
                                   checkDupSets.add(iterateExistingValues);
                               }
                        }      
                    }
                    if(checkDupSets.size()>0) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have already registered for a training on the same day at this time');
                        ApexPages.addMessage(myMsg);
                        isCancelled = false;
                        isTrainingExist = false;
                        isCompleted = False;
                    }  
                    
                    else
                    {
                        Volunteer_Orientation_Training__c newTrainingRegistration = new Volunteer_Orientation_Training__c();
                        newTrainingRegistration.Class_Offering__c = trainingId;
                        newTrainingRegistration.Volunteer__c = userRelatedContactId;
                        newTrainingRegistration.Type__c = 'Training';
                        newTrainingRegistration.Registered_Date__c = System.today();
                        newTrainingRegistration.Volunteer_Attendance__c = 'Registered';
                        newTrainingRegistration.Hidden_O_T_Id__c= classOfferingMap.get(trainingId).Chapter_Role_O_T__r.Orientation_Training__c;
                        
                        
                        if(classOfferingMap.get(trainingId).recordtypeid == classOffereningRecordtypeId ){
                            if(getUserRelatedContact.size() > 0 && lMSCredential != Null){
                                User currVolunteerUser = getUserRelatedContact.get(0);
                                currLMSUserResponse = LMSHttpRequest.createOrActivateLMSUser(currVolunteerUser,lMSCredential);            
                            } 
                            LMSOrientationRegistrationResponse currLMSOrientationRegistrationResponse = new LMSOrientationRegistrationResponse();
                            
                            currLMSOrientationRegistrationResponse = LMSHttpRequest.createOrUpdateEnrollment(lMSCredential,classOfferingMap.get(trainingId).Course_ID__c,currLMSUserResponse.login,'in-progress');
                            if(currLMSOrientationRegistrationResponse.status != Null && currLMSOrientationRegistrationResponse.status.equalsIgnoreCase('in-progress')){
                                newTrainingRegistration.LMS_Enrollment_Id__c = (currLMSOrientationRegistrationResponse.id != null) ? String.valueOf(currLMSOrientationRegistrationResponse.id) : Null;
                                
                            }
                        }
                        
                        try{
                            insert newTrainingRegistration;
                            isCancelled = false;
                            isTrainingExist = true;
                            isCompleted = False;
                        }catch(Exception ex){
                            System.debug('ex'+ex.getmessage());
                            //return 'Exception caused, Please retry again or contact System Adminstrator'; 
                        }
                        checkRegisteredProgram();
                    }
                }
            }
        }
        PageReference pg = new PageReference('/VolunteerTraining_VF');
        // return pg;
    }
    
    
    // Volunteer have a option to cancel their registered trainig program in the Registered Training table.
    public Void Cancel() {
        LMSUserResponse currLMSUserResponse = new LMSUserResponse();
        List<Class_Offering__c> orientationDetails = [SELECT Id, Course_ID__c, recordtypeid, Chapter__c FROM Class_Offering__c WHERE Id =:trainingId];
        if(orientationDetails.size()>0) {
            List<Volunteer_Orientation_Training__c> cancelRegistrationList = [SELECT Id, Class_Offering__c /*,Orientation_Training__r.Chapter_Name__c*/ FROM Volunteer_Orientation_Training__c WHERE Class_Offering__c =:trainingId AND Volunteer__c =: userRelatedContactId AND Class_Offering__r.Chapter__c =: orientationDetails.get(0).Chapter__c AND Type__c = 'Training'];
            if(cancelRegistrationList.size()>0) {
                if(getUserRelatedContact.size() > 0 && lMSCredential != Null){
                    
                    User currVolunteerUser = getUserRelatedContact.get(0);
                    cancelRegistrationList.get(0).Volunteer_Attendance__c = 'Volunteer Cancelled';
                    cancelRegistrationList.get(0).LMS_Enrollment_Id__c = '';
                    /*Added by Sailappa Vignesh PG
Description : To Update the Course enrollment status to 'dropped' in LMS*/
                    if(orientationDetails[0].recordtypeid == classOffereningRecordtypeId){                                  
                        currLMSUserResponse = LMSHttpRequest.createOrActivateLMSUser(currVolunteerUser,lMSCredential);  
                        LMSOrientationRegistrationResponse currLMSOrientationRegistrationResponse = new LMSOrientationRegistrationResponse();
                        currLMSOrientationRegistrationResponse = LMSHttpRequest.createOrUpdateEnrollment(lMSCredential,classOfferingMap.get(trainingId).Course_ID__c,currLMSUserResponse.login,'dropped');
                    }   
                    try{
                        update cancelRegistrationList;
                        isTrainingExist = false;
                        isCancelled = true;
                    }catch(Exception ex){
                        System.debug('Canceled ex'+ex.getmessage());
                        //return 'Exception caused, Please retry again or contact System Adminstrator'; 
                    }
                }
                checkRegisteredProgram();
            }
        }        
    }
    
    //Pagination
    public PageReference Beginning() { //user clicked beginning
        counter = 0;
        VolunteerTraining_AC vol = new VolunteerTraining_AC();
        return null;
    }
    
    public PageReference Previous() { //user clicked previous button
        counter -= list_size;
        VolunteerTraining_AC vol = new VolunteerTraining_AC();
        return null;
    }
    
    public PageReference Next() { //user clicked next button
        counter += list_size;
        VolunteerTraining_AC vol = new VolunteerTraining_AC();
        return null;
    }
    
    public PageReference End() { //user clicked end
        counter = total_size - math.mod(total_size, list_size);
        VolunteerTraining_AC vol = new VolunteerTraining_AC();
        return null;
    }
    
    public Boolean getDisablePrevious() { 
        //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }
    
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_size < total_size) return false; else return true;
    }
    // Displaying current page number.
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }
    
    public PageReference No(){
     PageReference pg = new PageReference('/VolunteerActiveTraining_VF');
     return pg;
    }
    // Calculating total pages based on the total number of records.
    public Integer getTotalPages() {
        try{
            if (math.mod(total_size, list_size) > 0) {
                return total_size/list_size + 1;
            } else {
                return (total_size/list_size);
            }
        }catch(Exception e){
            return 0;
        }
    }
    // Its redirecting to LMS page.
    public Void viewLMS() {
        
        LMSUserResponse currLMSUserResponse = new LMSUserResponse();        
        if(getUserRelatedContact.size() > 0 && lMSCredential != Null){
            User currVolunteerUser = getUserRelatedContact.get(0);            
            currLMSUserResponse = LMSHttpRequest.createOrActivateLMSUser(currVolunteerUser,lMSCredential);            
        }
        
        System.debug('The course id is'+lMSCourseId);
        /*Description : To get a access URL from the LMS*/
        if(currLMSUserResponse != Null && currLMSUserResponse.code != Null ){
            lMSSSOResponse = LMSHttpRequest.getLMSSSODetails(lMSCredential,currLMSUserResponse.code,lMSCourseId); 
            sSOUrl = lMSSSOResponse.login_url;
            //courseURL = 'https://wish.exceedlms-staging.com/student/home/show_enrollment/50174731';  
            courseURL =  lMSSSOResponse.enrollment_url;
            
        }
        
    } 
    
    public class classOfferingWrapper
    {
        public string orientationName{get;set;}
        public string chapterName{get;set;}
        public Date orientationDate{get;set;}
        public string startTime{get;set;}
        public string endTime{get;set;}
        public string location{get;set;}
        public integer maxCapacity{get;set;}
        public integer avilableSheets{get;set;}
        public string recordType{get;set;}
        public string status{get;set;}
        public integer volOppSize{get;set;}
        public string recordId{get;set;}
        public string courseId{get;set;}
        public string recordTypeId{get;set;}
        public boolean displayRec{get;set;}
    }  
}