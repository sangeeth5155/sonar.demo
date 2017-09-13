/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Chandrasekar Nallusamy
Date        : 7/4/2016
Description : 
1. This controller is used in the VolunteerProfile_VF page. Once volunteer is converted into Acive Volunteer Portal,
They can have a option for updating their profile details. This updated details will reflect in Volunteer Co
*******************************************************************************************************************/

public class VolunteerProfile_AC{
    public User userIns;
    public Boolean PersonalInfoSave{get;set;}
    public Boolean PersonalInfoEdit{get;set;}
    public Boolean employeeInfoSave{get;set;}
    public Boolean employeeInfoEdit{get;set;}
    public Boolean emergencyInfoSave{get;set;}
    public Boolean emergencyInfoEdit{get;set;}
    Public list<Contact> contactInstance{get;set;}
    public list<Background_check__c> backgroundCheckList{get;set;}
    public list<Conflict_Of_Interest__c> coiList{get;set;}
    Public list<classofferingwrapper> orientationList{get;set;}
    public list<classofferingwrapper> trainingList{get;set;}
    public list<awardsWrapper> awardsList{get;set;}
    public list<Awards_Recognition__c> awardsRecognitionList{get;set;}  
    public Map<string,integer> birthMonthMap = new Map<string,integer>();
    public list<string> raceEthinicityList{get;set;}
    public list<String> professionalSkillsList{get;set;}
    public list<String> langToRead{get;set;}
    public list<String> langToWrite{get;set;}
    public list<String> langToSpeak{get;set;}
    public list<String> langToUndetstand{get;set;}
    public list<String> languagesList{get;set;}
    Public Map<String, String> otherCountriesMap = new Map<String,String>();
    Public Map<String, String> otherStatesMap = new Map<String,String>();
    Public Map<String, String> mailingCountriesMap = new Map<String,String>();
    Public Map<String, String> mailingStatesMap = new Map<String,String>();
    public boolean isDisabled;
    public boolean isAwardEmpty{get;set;}  
    public Date COIExpirationDate{get;set;}
    public Date bcExpirationDate{get;set;}  
          
    
    public String lMSCourseId {get;set;}
    public String sSOUrl{get;set;}
    public String courseURL{get;set;}
    private LMS_Credentials__c lMSCredential;
    public LMSSSORespose lMSSSOResponse;
    public Id userRelatedContactId;
     List<User> getUserRelatedContact;
    // Initialyzing variables.
    public VolunteerProfile_AC(){
        PersonalInfoSave = true;
        PersonalInfoEdit = false;
        employeeInfoSave = true;
        employeeInfoEdit = false;
        emergencyInfoSave = true;
        emergencyInfoEdit = false;
        /*
         getUserRelatedContact = [SELECT Id,contact.Region_Chapter__c,contact.Region_Chapter__r.Chapter_Id__c,Username, LMS_Login__c, LMS_Id__c, ContactId, LMS_User_Code__c,FirstName,LastName,Email FROM User WHERE Id=:currentUserId];
        lMSCredential = LMS_Credentials__c.getValues('LMS Integration');
        userRelatedContactId = getUserRelatedContact.get(0).ContactId;*/
        
        userIns  = [SELECT Id,ContactId FROM User WHERE Id =: userInfo.getUserId() Limit 1];
        getUserRelatedContact = [SELECT Id,contact.Region_Chapter__c,contact.Region_Chapter__r.Chapter_Id__c,Username, LMS_Login__c, LMS_Id__c, ContactId, LMS_User_Code__c,FirstName,LastName,Email FROM User WHERE Id=:userIns.Id];
         lMSCredential = LMS_Credentials__c.getValues('LMS Integration');
         
          userRelatedContactId = getUserRelatedContact.get(0).ContactId;
          
         if(ApexPages.currentPage().getParameters().get('PersonalInfo') != Null)
                PersonalInfoSave= Boolean.valueOf(ApexPages.currentPage().getParameters().get('PersonalInfo'));
        
         if(PersonalInfoSave == false)
             personalInfoEdit = true;
         else
             PersonalInfoSave = true;
         
         if(ApexPages.currentPage().getParameters().get('employeeInfo') != Null)
                employeeInfoSave = Boolean.valueOf(ApexPages.currentPage().getParameters().get('employeeInfo'));
        
         if(employeeInfoSave == false)
             employeeInfoEdit = true;
         else
             employeeInfoSave = true;
             
         if(ApexPages.currentPage().getParameters().get('emergencyInfo') != Null)
                emergencyInfoSave = Boolean.valueOf(ApexPages.currentPage().getParameters().get('emergencyInfo'));
        
         if(emergencyInfoSave == false)
             emergencyInfoEdit = true;
         else
             emergencyInfoSave = true;    
            
         
        
        isDisabled = true;
        isAwardEmpty = false;
        langToRead = new List<String>();
        langToSpeak = new List<String>();
        langToWrite = new List<String>();
        langToUndetstand = new List<String>();
        languagesList  = new List<String>();
        raceEthinicityList= new List<String>();
        professionalSkillsList = new List<String>();
        
        birthMonthMap.put('January',1);
        birthMonthMap.put('February',2);
        birthMonthMap.put('March',3);
        birthMonthMap.put('April',4);
        birthMonthMap.put('May',5);
        birthMonthMap.put('June',6);
        birthMonthMap.put('July',7);
        birthMonthMap.put('August',8);
        birthMonthMap.put('September',9);
        birthMonthMap.put('October',10);
        birthMonthMap.put('November',11);
        birthMonthMap.put('December',12);
        
        
        
        
        orientationList = new List<classofferingwrapper>();
        trainingList = new list<classofferingwrapper>();
        awardsList = new list<awardsWrapper>();
        
        
        for(Volunteer_Orientation_Training__c currentRecord : [SELECT Id,Volunteer__c,Volunteer_Attendance__c,Hidden_O_T_Id__c, Orientation_Training_Hidden__c, 
                                                               /*Orientation_Training__r.RecordType.Name,*/ Class_Offering__r.Type__c,Class_Offering__r.Location__c,
                                                               Class_Offering__r.Date__c,Class_Offering__r.Start_Time__c,Class_Offering__r.End_Time__c,Type__c,
                                                               Class_Offering__r.Chapter__c,class_Offering__r.RecordType.name,Class_Offering__r.course_Id__c
                                                               FROM Volunteer_Orientation_Training__c WHERE Volunteer__c =:userIns.ContactId AND
                                                               (Volunteer_Attendance__c ='completed' )]){
            if(currentRecord.Type__c == 'Orientation'){
               classofferingwrapper orientation = new classofferingwrapper();
               orientation.OrientationName = currentRecord.Orientation_Training_Hidden__c;
               orientation.chapterName = currentRecord.Class_Offering__r.Chapter__c;
               orientation.orientationDate = currentRecord.Class_Offering__r.Date__c;
               orientation.startTime = currentRecord.Class_Offering__r.Start_Time__c;
               orientation.endTime = currentRecord.Class_Offering__r.End_Time__c;
               orientation.location = currentRecord.Class_Offering__r.Location__c;
               orientation.recordTypeName = currentRecord.Class_Offering__r.RecordType.name;
               orientation.attendance = currentRecord.Volunteer_Attendance__c;
               
               orientationList.add(orientation);
            }
            
            if(currentRecord.Type__c == 'Training'){
               
                classofferingwrapper training = new classofferingwrapper();
                training.OrientationName = currentRecord.Orientation_Training_Hidden__c;
                training.chapterName = currentRecord.Class_Offering__r.Chapter__c;
                training.orientationDate = currentRecord.Class_Offering__r.Date__c;
                training.startTime = currentRecord.Class_Offering__r.Start_Time__c;
                training.endTime = currentRecord.Class_Offering__r.End_Time__c;
                training.location = currentRecord.Class_Offering__r.Location__c;
                training.recordTypeName = currentRecord.Class_Offering__r.RecordType.name;
                training.attendance = currentRecord.Volunteer_Attendance__c;
                training.courseId = currentRecord.Class_Offering__r.course_Id__c;
                trainingList.add(training);
            }
        }
        
        
        contactInstance = new list<Contact>();
        backgroundCheckList = new list<Background_check__c>();
        coiList = new list<Conflict_Of_Interest__c>();
        
        backgroundCheckList = [SELECT ID,date__c,Volunteer__c FROM Background_check__c WHERE Volunteer__c =: userIns.ContactId Order by CreatedDate DESC Limit 1 ];
        coiList = [SELECT ID,Expiration_Date__c,Volunteer_Contact__c FROM Conflict_Of_Interest__c  WHERE Volunteer_Contact__c =: userIns.ContactId Order by CreatedDate DESC Limit 1];
        
        if(coiList.size() > 0)
           COIExpirationDate = coiList[0].Expiration_Date__c;
        if(backgroundCheckList.size() > 0)
           bcExpirationDate = backgroundCheckList[0].date__c;
        
        contactInstance = [SELECT id,Name,Gender__c,Birth_Day__c,County__c,Salutation,Title,Birth_Month__c,Birth_Year__c,Birthdate,Current_Age__c,Work_Phone__c,Phone,HomePhone,MobilePhone,Preferred_Phone_Types__c,What_is_your_race_ethnicity__c,RecordTypeId,FirstName,Middle_Name__c,LastName,
                           Email,MailingStreet,MailingCity,mailingstatecode,mailingstate,MailingCountrycode,MailingPostalCode,Race_Ethnicity__c,Emergency_Contact_Relationship__c,
                           Employer__c,Street_Employer__c,City_Employer__c,npe01__HomeEmail__c,State_Employer__c,Fax,Professional_Skills__c,Language__c,npe01__AlternateEmail__c,npe01__PreferredPhone__c,npe01__Preferred_Email__c,Zip_Employer__c,May_We_Contact_You_at_Work__c,Interested_involved_with_Make_A_Wish__c,
                           Emergency_Contact__c,Emergency_Contact_Phone__c,npe01__Primary_Address_Type__c,Read__c, Write__c,Understand__c, Speak__c, Language_Notes__c,otherPhone,Alternate_Phone_Type__c,
                           OtherCountryCode,OtherStateCode,OtherCity,Professional_Skills_Other_Notes__c,OtherCountry,OtherStreet,OtherPostalCode,OtherState FROM Contact WHERE Id =: userIns.ContactId];
      
          
          if(contactInstance[0].read__c!= Null)
            {
                for(String read: contactInstance[0].read__c.split(';'))
                {
                    langToRead.add(read);
                }
            }
            else
            {
            
                langToRead.add('English');

            }
            if(contactInstance[0].Speak__c!= Null)
            {
                for(String speak: contactInstance[0].Speak__c.split(';'))
                {
                    langToSpeak.add(speak);
                }
            }
            else
            {
                langToSpeak.add('English');
            }
            
            if(contactInstance[0].Write__c != Null)
            {
                for(String write : contactInstance[0].Write__c.split(';'))
                {
                    langToWrite.add(write);
                }
            }
            else
            {
               langToWrite.add('English');
            }
          
            if(contactInstance[0].Understand__c != Null)
            {
                for(String understand : contactInstance[0].Understand__c.split(';'))
                {
                    langToUndetstand.add(understand);
                }
            }
            else
            {
                langToUndetstand.add('English');
            }
            
            if(contactInstance[0].Language__c != Null)
            {
                for(String lang: contactInstance[0].Language__c.split(';'))
                {
                    languagesList.add(lang);
                }
            }
            else
            {
                 languagesList.add('English');
            }
          
            if(contactInstance[0].Professional_Skills__c!= Null)
            {
                for(String mwa: contactInstance[0].Professional_Skills__c.split(';'))
                {
                    professionalSkillsList.add(mwa);
                }
            }
        
           if(contactInstance[0].Race_Ethnicity__c != Null)
            {
                for(String mwa: contactInstance[0].Race_Ethnicity__c.split(';'))
                {
                    raceEthinicityList.add(mwa);
                }
            }
            
        //Used to display volunteer award details       
        awardsRecognitionList = [SELECT Award_Name__c,Award_Type__c,Chapter_Name__r.Name,Comment__c,Date_Field__c FROM Awards_Recognition__c WHERE Volunteer_Contact__c =: userIns.ContactId ];
        
        if(awardsRecognitionList.size() > 0)
        {
           for(Awards_Recognition__c  currRec : awardsRecognitionList)
           {
              awardsList.add(new awardsWrapper(currRec.Chapter_Name__r.Name,currRec.Award_Type__c,currRec.Award_Name__c,currRec.Date_Field__c));
           }
        }
    
    
    }
    
    // Getting State picklist value.
    public List<SelectOption> getStates(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.State_Picklist__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
      
        options.add(new SelectOption('', 'None'));
        for(Schema.PicklistEntry currVal : picklistValues)
        { 
            mailingCountriesMap.put(currVal.getLabel(),currVal.getValue());
            options.add(new SelectOption(String.valueOf(currVal.getLabel()), currVal.getValue())); 
         
        }  
        return options;
     }  
    
   
   // Fetching Gender picklist values. 
    public List<SelectOption> getGender(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Gender__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None'));
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
     // Fetching Year picklist value.
    public List<SelectOption> getBirthDay(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Birth_Day__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Day' ));
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    // Fetching Year picklist value.
    public List<SelectOption> getBirthYear()
    {
    
       integer year = Date.Today().Year();
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('', 'Year' ));
       for(integer i = 1900; i<= (year-18);i++)
       {
         options.add(new SelectOption(String.valueOf(i), String.valueOf(i))); 
       }
      return options;
    
    }
    // Fetching month picklist value.
    public List<SelectOption> getBirthMonth(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Birth_Month__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Month' ));
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    
    // Fetching picklist value of Race/Ethnicity.
    public List<SelectOption> getRaceEthnicity(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Race_Ethnicity__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    // Fetching the picklist value of Preferred Phone Type.
    public List<SelectOption> getPreferedPhoneType(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.npe01__PreferredPhone__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None' ));
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    
    // Fetching picklist value of Preferred Email.
    public List<SelectOption> getPreferedEmail(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.npe01__Preferred_Email__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None' ));
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    
    // Fetching picklist value of Professional skills.
    public List<SelectOption> getProfessionalSKills(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Professional_Skills__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None' ));
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }   
    
    // Fetching picklist value of Language.
    public List<SelectOption> getLanguages(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Language__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    
    // Fetching picklist value of Primary Address Type.
    public List<SelectOption> getAddType(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.npe01__Primary_Address_Type__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
       // if(contactInstance[0].npe01__Primary_Address_Type__c == Null || contactInstance[0].npe01__Primary_Address_Type__c =='')
            options.add(new SelectOption('', 'None'));
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    
   
    // Fetching picklist value of state field.
    public List<SelectOption> getOtherState(){
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =  Lead.State_Picklist__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None'));
        for( Schema.PicklistEntry currVal : picklistValues)
        { 
            otherStatesMap.put(currVal.getLabel(),currVal.getValue());
            options.add(new SelectOption(currVal.getLabel(),currVal.getvalue())); 
         
        }  
        return options;
    }    
    
     // Fetching picklist value of Interested involved with Make A wish field.
    public List<SelectOption> getMake_A_Wish(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Interested_involved_with_Make_A_Wish__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    
    // Fetching picklist value of May we contact you at work custom field.
    public List<SelectOption> getConatctAtWork(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.May_We_Contact_You_at_Work__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    
    // Getting Employeer State picklist values.
    public List<SelectOption> getEmpState(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.State_Employer__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(),currVal.getValue())); 
         
        }  
        return options;
    }    
    
    // Fetching Relationship picklist values.
    public List<SelectOption> getRelationShip(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Emergency_Contact_Relationship__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'None'));
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    
    
    
    // It will update personal information in volunteer contact record then will display output mode of Personal information.
    public PageReference SavePersonalInfo(){
        
        string birthMonth;
        string birthDay;
        string birthYear;
         if(raceEthinicityList != Null)
            {
               
                String race='';
                for(String s : (raceEthinicityList))
                {
                  race+=s+';';
                }
                contactInstance[0].Race_Ethnicity__c = race.removeEnd(';');
            }
               
            if(languagesList != Null)
            {
              
                String language ='';
                for(String s : (languagesList))
                {
                  language+=s+';';
                }
                contactInstance[0].Language__c  = language.removeEnd(';');
            }
            
            if(langToRead!= Null)
            {
                String read ='';
                for(String s : langToRead)
                {
                  read+=s+';';
                }
                contactInstance[0].read__c= read.removeEnd(';');
            }
            if(langToWrite != Null)
            {
                String write ='';
                for(String s : langToWrite)
                {
                  write+=s+';';
                }
                contactInstance[0].write__c = write.removeEnd(';');
            }
            if(langToSpeak!= Null)
            {
               
                String speak='';
                for(String s : langToSpeak)
                {
                  speak+=s+';';
                }
                contactInstance[0].speak__c= speak.removeEnd(';');
            }
            if(langToUndetstand!= Null)
            {
              
                String understand='';
                for(String s : (langToUndetstand))
                {
                  understand+=s+';';
                }
                contactInstance[0].Understand__c= understand.removeEnd(';');
            }
            if(professionalSkillsList != Null)
            {
              
                String skill ='';
                for(String s : (professionalSkillsList))
                {
                  skill+=s+';';
                }
                contactInstance[0].Professional_Skills__c= skill.removeEnd(';');
            }
            
        /*    if(contactInstance[0].Preferred_Phone_Types__c == 'Home' && contactInstance[0].Alternate_Phone_Type__c == 'Mobile'){
                contactInstance[0].HomePhone = contactInstance[0].HomePhone;
                contactInstance[0].MobilePhone  = contactInstance[0].MobilePhone ;
                if(contactInstance[0].OtherPhone != Null)
                contactInstance[0].OtherPhone = Null;
            }
            
            if(contactInstance[0].Preferred_Phone_Types__c == 'Home' && contactInstance[0].Alternate_Phone_Type__c == Null){
                contactInstance[0].HomePhone = contactInstance[0].HomePhone;
                contactInstance[0].MobilePhone  = Null ;
                if(contactInstance[0].OtherPhone != Null)
                contactInstance[0].OtherPhone = Null;
            }
            
             if(contactInstance[0].Preferred_Phone_Types__c == 'Mobile' && contactInstance[0].Alternate_Phone_Type__c == Null){
                contactInstance[0].MobilePhone  = contactInstance[0].HomePhone;
                contactInstance[0].HomePhone = Null ;
                if(contactInstance[0].OtherPhone != Null)
                contactInstance[0].OtherPhone = Null;
            }
            
            if(contactInstance[0].Preferred_Phone_Types__c == 'Mobile' && contactInstance[0].Alternate_Phone_Type__c == 'Home'){
                String mobileNo = contactInstance[0].MobilePhone;
                contactInstance[0].MobilePhone = contactInstance[0].HomePhone;
                contactInstance[0].HomePhone = mobileNo;
                if(contactInstance[0].OtherPhone != Null)
                contactInstance[0].OtherPhone = Null;
            }
            
            
            if(contactInstance[0].Preferred_Phone_Types__c == 'Home' && contactInstance[0].Alternate_Phone_Type__c == 'Home'){
                contactInstance[0].HomePhone = contactInstance[0].HomePhone;
                contactInstance[0].OtherPhone = contactInstance[0].MobilePhone;
                contactInstance[0].MobilePhone = Null;
                
            }
            
             if(contactInstance[0].Preferred_Phone_Types__c == 'Mobile' && contactInstance[0].Alternate_Phone_Type__c == 'Mobile'){
                contactInstance[0].MobilePhone = contactInstance[0].MobilePhone ;
                contactInstance[0].OtherPhone = contactInstance[0].HomePhone;
                contactInstance[0].HomePhone = Null;
            } */
           
        if((contactInstance[0].Name== Null || contactInstance[0].Name == '') || (contactInstance[0].Email == Null || contactInstance[0].Email == '')
           || (contactInstance[0].Birth_Month__c == Null || contactInstance[0].Birth_Month__c == '') || (contactInstance[0].Birth_Day__c == '' || contactInstance[0].Birth_Day__c == '') ||
           (contactInstance[0].MailingStreet == NULL || contactInstance[0].MailingStreet == '') || (contactInstance[0].MailingCity == NULL || contactInstance[0].MailingCity == '') || 
           (contactInstance[0].MailingPostalCode== NULL || contactInstance[0].MailingPostalCode == '') ||  (contactInstance[0].County__c == NULL || contactInstance[0].County__c == '')
           || (contactInstance[0].mailingstate == NULL || contactInstance[0].mailingstate == '') || (contactInstance[0].Understand__c == NULL || contactInstance[0].Understand__c == '') ||
           (contactInstance[0].Read__c == NULL || contactInstance[0].Read__c == '') || (contactInstance[0].write__c == NULL || contactInstance[0].write__c == '') || 
           (contactInstance[0].speak__c == NULL || contactInstance[0].speak__c == '') || (contactInstance[0].language__c == NULL || contactInstance[0].language__c == ''))
               
        {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all the mandatory fields');
             ApexPages.addMessage(myMsg);
        }
        
        else
        {
        
         
        if(contactInstance[0].Birth_Month__c != Null && birthMonthMap.containskey(contactInstance[0].Birth_Month__c ) && contactInstance[0].Birth_Day__c != Null && contactInstance[0].Birth_Year__c != Null){
            birthMonth = string.Valueof(birthMonthMap.get(contactInstance[0].Birth_Month__c));
            birthDay = contactInstance[0].Birth_Day__c;
            birthYear = contactInstance[0].Birth_Year__c;
            if(birthYear != Null && birthMonth != Null && birthDay != Null)
            {
                String s = birthYear+'-'+birthMonth+'-'+birthDay;
                if(!(contactInstance[0].Birth_Year__c.isNumeric())){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'The value for Birth Year should be number'));
                    return null;
                }else {
                    contactInstance[0].Birthdate = Date.valueOf(s);
                }
            }
        }
        
        Integer currentAge;
        if(contactInstance[0].Birthdate != Null)
            currentAge = contactInstance[0].Birthdate.monthsBetween(system.today()) / 12;
        
        
        if(currentAge < 18){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'The volunteer age should be greater than 18'));
        }
        else{
            PersonalInfoSave = true;
            PersonalInfoEdit = false;
           try{
              update contactInstance[0];
              PageReference pr = new PageReference('/apex/VolunteerProfile_VF?PersonalInfo='+PersonalInfoSave+'&employeeInfo='+employeeInfoSave+'&emergencyInfo='+emergencyInfoSave);
              pr.setRedirect(true); 
              return pr;
            
            }
           catch(Exception ex){
           }
               
        }
      } 
      return null; 
    }
    
    // It will display personal information as Edit mode.
    public PageReference EditPersonalInfo(){
       PersonalInfoSave = false;
       PageReference pr = new PageReference('/apex/VolunteerProfile_VF?PersonalInfo='+PersonalInfoSave+'&employeeInfo='+employeeInfoSave+'&emergencyInfo='+emergencyInfoSave);
       pr.setRedirect(true); 
       return pr;
    }
    
    // Cancel Functionality for Personal info section.
    public pageReference CancelPersonalInfo(){
       PersonalInfoSave = true;
       PageReference pr = new PageReference('/apex/VolunteerProfile_VF?PersonalInfo='+PersonalInfoSave+'&employeeInfo='+employeeInfoSave+'&emergencyInfo='+emergencyInfoSave);
       pr.setRedirect(true); 
       return pr;
    }
    
    // update employee details in volunteer contact and display employee section as output mode.
    public PageReference SaveEmployeeInfo(){
        
        employeeInfoSave = true;
        employeeInfoEdit = false;
        system.debug('!!!!!!!!!!!!!! contactInstance'+ contactInstance);
        update contactInstance[0];
        PageReference pr = new PageReference('/apex/VolunteerProfile_VF?PersonalInfo='+PersonalInfoSave+'&employeeInfo='+employeeInfoSave+'&emergencyInfo='+emergencyInfoSave);
        pr.setRedirect(true); 
        return pr;
        
    }
    
    // Will Display Employee section as input mode.
    public PageReference EditEmployeeInfo(){
        employeeInfoSave = false;
        employeeInfoEdit = true;
        PageReference pr = new PageReference('/apex/VolunteerProfile_VF?PersonalInfo='+PersonalInfoSave+'&employeeInfo='+employeeInfoSave+'&emergencyInfo='+emergencyInfoSave);
        pr.setRedirect(true); 
        return pr;
    }
    
    // Cancel Functionality for employee info section.
    public PageReference CancelEmpInfo(){
        employeeInfoSave = true;
        employeeInfoEdit = false;
        PageReference pr = new PageReference('/apex/VolunteerProfile_VF?PersonalInfo='+PersonalInfoSave+'&employeeInfo='+employeeInfoSave+'&emergencyInfo='+emergencyInfoSave);
        pr.setRedirect(true); 
        return pr;
    }
    
    // Update Emergency Details and Display Emergency Info as output mode.
    public PageReference SaveEmergencyInfo(){
        
      
        if((contactInstance[0].Emergency_Contact_Relationship__c == Null || contactInstance[0].Emergency_Contact_Relationship__c == '') || 
           (contactInstance[0].Emergency_Contact__c == Null || contactInstance[0].Emergency_Contact__c == '') || (contactInstance[0].Emergency_Contact_Phone__c == Null || contactInstance[0].Emergency_Contact_Phone__c == ''))
        {
        
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all the mandatory fields');
             ApexPages.addMessage(myMsg);
             return null;
        }
       else
        {
            emergencyInfoSave = true;
            emergencyInfoEdit = false;
            update contactInstance[0];
            PageReference pr = new PageReference('/apex/VolunteerProfile_VF?PersonalInfo='+PersonalInfoSave+'&employeeInfo='+employeeInfoSave+'&emergencyInfo='+emergencyInfoSave);
            pr.setRedirect(true); 
            return pr;
        }
         return null;
    }
    
    // Display Emergency info as a input mode.
    public PageReference  EditEmergencyInfo(){
        emergencyInfoSave = false;
        emergencyInfoEdit = true;
        PageReference pr = new PageReference('/apex/VolunteerProfile_VF?PersonalInfo='+PersonalInfoSave+'&employeeInfo='+employeeInfoSave+'&emergencyInfo='+emergencyInfoSave);
        pr.setRedirect(true); 
        return pr;
    }
    
    // Cancel Functionality for Emergency info section.
    public PageReference CancelEmergencyInfo(){
        emergencyInfoSave = true;
        emergencyInfoEdit = false;
        PageReference pr = new PageReference('/apex/VolunteerProfile_VF?PersonalInfo='+PersonalInfoSave+'&employeeInfo='+employeeInfoSave+'&emergencyInfo='+emergencyInfoSave);
        pr.setRedirect(true); 
        return pr;
    }
    
   
   
    public class classofferingwrapper
    {
        public string orientationName{get;set;}
        public string chapterName{get;set;}
        public Date orientationDate{get;set;}
        public string startTime{get;set;}
        public string endTime{get;set;}
        public string location{get;set;}
        public string recordTypeName{get;set;}
        public string attendance{get;set;}
        public String courseId{get;set;}
    
    }
    
    public class AwardsWrapper
    {
        public string chapterName{get;set;}
        public string awardType{get;set;}
        public string awardName{get;set;}
        public Date awardDate{get;set;}
        
        public awardsWrapper(String name, String type, String aName, Date aDate)
        {
           chapterName = name;
           awardType = type;
           awardName = aName;
           awardDate = aDate;
        }
    
    }
    
      /*To display title values for current logged in volunteer contact in community.*/
    public List<SelectOption> getTitles(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select Title')); 
        options.add(new SelectOption('Mr.','Mr.')); 
        options.add(new SelectOption('Mrs.','Mrs.'));
        options.add(new SelectOption('Miss','Miss'));
        options.add(new SelectOption('Master','Master'));
        options.add(new SelectOption('Dr.','Dr.'));
        options.add(new SelectOption('Prof.','Prof.'));
        return options;
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
    
}