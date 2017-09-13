@isTest
public class TestClassUtil{
    
    public static List<Account> chapterAccountList = new List<Account>(); 
    public static User newProspectiveVolunteerUser;   
    public Static void createTestQueueData(){
        
        Group leadalabamaGroup = new Group(Type='Queue', Name='Alabama');
        insert leadalabamaGroup ;
        
        QueueSObject leadalabamaQueue = new QueueSObject(SobjectType='Lead', QueueId=leadalabamaGroup.Id);
        insert leadalabamaQueue ;
        
        QueueSObject volunteeralabamaQueue = new QueueSObject(SobjectType='Volunteer_Opportunity__c', QueueId=leadalabamaGroup .Id);
        insert volunteeralabamaQueue ;
        
        Group leadarizonaGroup = new Group(Type='Queue', Name='Arizona');
        insert leadarizonaGroup ;
        
        QueueSObject leadarizonaQueue = new QueueSObject(SobjectType='Lead', QueueId=leadarizonaGroup.Id);
        insert leadarizonaQueue ;
        
        QueueSObject volunteerarizonaQueue = new QueueSObject(SobjectType='Volunteer_Opportunity__c', QueueId=leadarizonaGroup.Id);
        insert volunteerarizonaQueue ;
        
        
    }
    
    
    
    public static void createUser(){
        UserRole newUserRole = new UserRole();
        newUserRole.Name  = 'Arizona - Chapter';
        Insert newUserRole;
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User tuser = new User(  firstname = 'Test FirstName',
                              lastName = 'Test LastName',
                              email = uniqueName + '@test' + orgId + '.org',
                              Username = uniqueName + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = pf.Id,
                              isActive = true,
                              UserRoleId = newUserRole.Id);
        insert tuser;
        
    }
    
    public static void createchapterAccount(Integer count){
        Constant_AC  constant = new Constant_AC();
        Id ChapterRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        
        
        for(Integer i=0; i<= count; i++){
            
            Account newchapterAccount = new Account();
            newchapterAccount .Name = 'Arizona - Chapter';
            newchapterAccount.RecordTypeId = ChapterRecordTypeId;
            chapterAccountList .add(newchapterAccount );
            
        }
        insert chapterAccountList ;
        
    }
    
      public static Id createArizonaChapter(){
            Constant_AC  constant = new Constant_AC();
            Id ChapterRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
            
            Account newchapterAccount = new Account();
            newchapterAccount .Name = 'Arizona - Chapter';
            newchapterAccount.RecordTypeId = ChapterRecordTypeId;
            
            
            insert newchapterAccount;
            return newchapterAccount.id;
            
        }
    
    public static void createOrganizationAccount(Integer count){
        Constant_AC  constant = new Constant_AC();
        Id organizationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.OrganizationRT).getRecordTypeId();
        List<Account> orgAccountTestDataList = new List<Account>();
        
        for(Integer i=0; i<= count; i++){
            
            Account newOrgAccount = new Account();
            newOrgAccount.Name = 'Moss Hart AC two';
            newOrgAccount.RecordTypeId = organizationRecordTypeId;
            orgAccountTestDataList.add(newOrgAccount);
        }
        
        for(Integer i=0; i<= count; i++){
            
            Account newOrgAccount = new Account();
            newOrgAccount.Name = 'Steve Smith AC two';
            newOrgAccount.RecordTypeId = organizationRecordTypeId;
            orgAccountTestDataList.add(newOrgAccount);
        }
        insert orgAccountTestDataList;
        
    }
    
    public static void createVolunteerContact(Integer count){
        
        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        List<Contact> volunteercontactList  = new List<Contact>();
        for(Integer i =0; i<= count; i++){
            Contact newContact = new Contact();
            newContact.FirstName = 'moss';
            newContact.LastName = 'Smith';
            newContact.Birthdate = System.today()-1;
            newContact.Parent_Guardian_Name__c = 'Steve Smith'; 
            newContact.RecordTypeId = volunteerRecordTypeId;
            volunteercontactList .add(newContact);
        }
        insert volunteercontactList;
    }
    public static void createTestContactDataDupeFirstName(integer count){
        List<Contact> contactTestDataList = new List<Contact>();
        Constant_AC  constant = new Constant_AC();
        Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        for(Integer i = 1; i<= count; i++){
            
            Contact newContact = new Contact();
            newContact.FirstName = 'moss';
            newContact.LastName = 'Smith1';
            newContact.Birthdate = System.today()-1;
            newContact.Parent_Guardian_Name__c ='Steve Smith'; 
            newContact.RecordTypeId = wishChildRecordTypeId ;
            contactTestDataList.add(newContact);
        }
        insert contactTestDataList;
    }
    
    public static void createTestContactDataDupeLastName(integer count){
        List<Contact> contactTestDataList = new List<Contact>();
        Constant_AC  constant = new Constant_AC();
        Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        for(Integer i = 1; i<= count; i++){
            
            Contact newContact = new Contact();
            newContact.FirstName = 'moss1';
            newContact.LastName = 'Smith';
            newContact.Birthdate = System.today()-1;
            newContact.Parent_Guardian_Name__c ='Steve Smith'; 
            newContact.RecordTypeId = wishChildRecordTypeId ;
            contactTestDataList.add(newContact);
        }
        insert contactTestDataList;
    }
    
    public static void createTestMedicalContactData(integer count){
        List<Contact> medicalcontactTestDataList = new List<Contact>();
        Constant_AC  constant = new Constant_AC();
        Id medicalProfessionalRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
        for(Integer i = 1; i<= count; i++){
            
            Contact newContact = new Contact();
            newContact.FirstName = 'moss';
            newContact.LastName = 'hart';
            newContact.Phone = '9600467558';
            newContact.Email = 'testmawa1@gmail.com';
            newContact.Birthdate = System.today() - 1;
            newContact.Parent_Guardian_Name__c = 'Steve Smith'; 
            newContact.RecordTypeId = medicalProfessionalRecordTypeId ;
            medicalcontactTestDataList .add(newContact);
        }
        
        for(Integer i = 1; i<= count; i++){
            
            Contact newContact = new Contact();
            newContact.FirstName = 'Steve';
            newContact.LastName = 'Waugh';
            newContact.Phone = '9600467557';
            newContact.Email = 'testmawa2@gmail.com';
            newContact.Birthdate = System.today()-1;
            newContact.Parent_Guardian_Name__c ='Steve Smith'; 
            newContact.RecordTypeId = medicalProfessionalRecordTypeId ;
            medicalcontactTestDataList .add(newContact);
        }
        
        insert medicalcontactTestDataList ;
    }
    
    
    public static void createTestLeadDataFirstNameDupe(integer count){
        List<Lead> leadTestDataList = new List<Lead>();
        
        for(Integer i = 1; i <= count; i++){
            
            Lead newLead = new Lead();
            newLead.FirstName = 'moss';
            newLead.LastName = 'Smith1 Household';
            newLead.Phone = '9600467559';
            newLead.Email = 'testmawa@gmail.com';
            newLead.State = 'Alabama';
            newLead.DOB__c = System.today() - 1;
            newLead.Parent_Guardian_Name__c = 'Steve Smith'; 
            newLead.company = 'MAWA';
            newLead.Status = 'Open - Not Contacted';
            newLead.Medical_Professional_First_Name__c = 'moss';
            newLead.Medical_Professional_Last_Name__c = 'hart';
            newLead.Medical_Professional_Phone__c = '9600467558';
            newLead.Medical_Professional_Email__c = 'testmawa1@gmail.com';
            newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC';
            newLead.Treating_Medical_Professional_First_Name__c = 'Steve';
            newLead.Treating_Medical_Professional_Last_Name__c = 'Waugh';
            newLead.Treating_Medical_Professional_Phone__c = '9600467557';
            newLead.Treating_Medical_Professional_Email__c = 'testmawa2@gmail.com';
            newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC';
            leadTestDataList.add(newLead);
            
        }
        
        for(Integer i = 1; i <= count; i++){
            
            Lead newLead = new Lead();
            newLead.FirstName = 'moss';
            newLead.LastName = 'Smith1 Household';
            newLead.Phone = '9600467559';
            newLead.Email = 'testmawa@gmail.com';
            newLead.State = 'Alabama';
            newLead.DOB__c = System.today() - 1;
            newLead.Parent_Guardian_Name__c = 'Steve Smith'; 
            newLead.company = 'MAWA';
            newLead.Status = 'Open - Not Contacted';
            newLead.Medical_Professional_First_Name__c = 'moss';
            newLead.Medical_Professional_Last_Name__c = 'hart';
            newLead.Medical_Professional_Phone__c = '9600467558';
            newLead.Medical_Professional_Email__c = 'testmawa1@gmail.com';
            newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC';
            newLead.Treating_Medical_Professional_First_Name__c = 'Steve';
            newLead.Treating_Medical_Professional_Last_Name__c = 'Waugh';
            newLead.Treating_Medical_Professional_Phone__c = '9600467557';
            newLead.Treating_Medical_Professional_Email__c = 'testmawa2@gmail.com';
            newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC';
            newLead.Override_Dupe_Check__c = TRUE;
            leadTestDataList.add(newLead);
            
        }
        insert leadTestDataList;
    }
    
    public static void createTestLeadDataLastNameDupe(integer count){
        List<Lead> leadTestDataList = new List<Lead>();
        
        for(Integer i = 1; i <= count; i++){
            
            Lead newLead = new Lead();
            newLead.FirstName = 'moss1';
            newLead.LastName = 'Smith Household';
            newLead.Phone = '9600467559';
            newLead.Email = 'testmawa@gmail.com';
            newLead.State = 'Alabama';
            newLead.DOB__c = System.today() - 1;
            newLead.Parent_Guardian_Name__c = 'Steve Smith'; 
            newLead.company = 'MAWA';
            newLead.Status = 'Open - Not Contacted';
            newLead.Medical_Professional_First_Name__c = 'moss';
            newLead.Medical_Professional_Last_Name__c = 'hart';
            newLead.Medical_Professional_Phone__c = '9600467558';
            newLead.Medical_Professional_Email__c = 'testmawa1@gmail.com';
            newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC';
            newLead.Treating_Medical_Professional_First_Name__c = 'Steve';
            newLead.Treating_Medical_Professional_Last_Name__c = 'Waugh';
            newLead.Treating_Medical_Professional_Phone__c = '9600467557';
            newLead.Treating_Medical_Professional_Email__c = 'testmawa2@gmail.com';
            newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC';
            leadTestDataList.add(newLead);
            
        }
        
        for(Integer i = 1; i <= count; i++){
            
            Lead newLead = new Lead();
            newLead.FirstName = 'moss1';
            newLead.LastName = 'Smith Household';
            newLead.Phone = '9600467559';
            newLead.Email = 'testmawa@gmail.com';
            newLead.State = 'Alabama';
            newLead.DOB__c = System.today() - 1;
            newLead.Parent_Guardian_Name__c = 'Steve Smith'; 
            newLead.company = 'MAWA';
            newLead.Status = 'Open - Not Contacted';
            newLead.Medical_Professional_First_Name__c = 'moss';
            newLead.Medical_Professional_Last_Name__c = 'hart';
            newLead.Medical_Professional_Phone__c = '9600467558';
            newLead.Medical_Professional_Email__c = 'testmawa1@gmail.com';
            newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC';
            newLead.Treating_Medical_Professional_First_Name__c = 'Steve';
            newLead.Treating_Medical_Professional_Last_Name__c = 'Waugh';
            newLead.Treating_Medical_Professional_Phone__c = '9600467557';
            newLead.Treating_Medical_Professional_Email__c = 'testmawa2@gmail.com';
            newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC';
            newLead.Override_Dupe_Check__c = TRUE;
            leadTestDataList.add(newLead);
            
        }
        insert leadTestDataList;
    }
    
    public static void createTestLeadDataWithoutDupe(integer count){
        List<Lead> leadTestDataList = new List<Lead>();
        
        for(Integer i = 1; i <= count; i++){
            Lead newLead = new Lead();
            newLead.FirstName = 'Robin';
            newLead.LastName ='Wood';
            newLead.Phone = '9600467559';
            newLead.Email = 'testmawa@gmail.com';
            newLead.State = 'Alabama';
            newLead.DOB__c = System.today() - 3;
            newLead.Parent_Guardian_Name__c = 'William Smith'; 
            newLead.company = 'MAWA';
            newLead.Status = 'Open - Not Contacted';
            newLead.isApprove__c = False;
            newLead.Medical_Professional_First_Name__c = 'moss';
            newLead.Medical_Professional_Last_Name__c = 'hartone';
            newLead.Medical_Professional_Phone__c = '9600467554';
            newLead.Medical_Professional_Email__c = 'testmawa11@gmail.com';
            newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC two';
            newLead.Treating_Medical_Professional_First_Name__c = 'Steve';
            newLead.Treating_Medical_Professional_Last_Name__c = 'Waughone';
            newLead.Treating_Medical_Professional_Phone__c = '9600467551';
            newLead.Treating_Medical_Professional_Email__c = 'testmawa21@gmail.com';
            newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC two';
            leadTestDataList.add(newLead);
            
        }
        insert leadTestDataList;
        
    }
    
    public static void createTestLeadDataWithoutDupeone(integer count){
        List<Lead> leadTestDataList = new List<Lead>();
        
        for(Integer i = 1; i <= count; i++){
            Lead newLead = new Lead();
            newLead.FirstName = 'Robinone';
            newLead.LastName ='Woodone';
            newLead.Phone = '9600467559';
            newLead.Email = 'testmawa@gmail.com';
            newLead.State = 'Alabama';
            newLead.DOB__c = System.today() - 3;
            newLead.Parent_Guardian_Name__c = 'William Smith'; 
            newLead.company = 'MAWA';
            newLead.Status = 'Open - Not Contacted';
            newLead.isApprove__c = False;
            newLead.Medical_Professional_First_Name__c =  'moss';
            newLead.Medical_Professional_Last_Name__c =  'hartone';
            newLead.Medical_Professional_Phone__c =  '9600467554';
            newLead.Medical_Professional_Email__c = 'testmawa11@gmail.com';
            newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC two';
            newLead.Treating_Medical_Professional_First_Name__c =  'Steve';
            newLead.Treating_Medical_Professional_Last_Name__c =  'Waugh';
            newLead.Treating_Medical_Professional_Phone__c = '9600467557';
            newLead.Treating_Medical_Professional_Email__c = 'testmawa2@gmail.com';
            newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC two';
            leadTestDataList.add(newLead);
            
        }
        insert leadTestDataList;
        
    }
    
    public static void createTestLeadDataWithDupetwo(integer count){
        
        List<Lead> leadTestDataList = new List<Lead>();
        
        for(Integer i = 1; i <= count; i++){
            Lead newLead = new Lead();
            newLead.FirstName = 'Robin';
            newLead.LastName ='Wood';
            newLead.Phone = '9600467559';
            newLead.Email = 'testmawa@gmail.com';
            newLead.State = 'Alabama';
            newLead.DOB__c = System.today() - 3;
            newLead.Parent_Guardian_Name__c = 'William Smith'; 
            newLead.company = 'MAWA';
            newLead.Status = 'Open - Not Contacted';
            newLead.Medical_Professional_First_Name__c = 'moss';
            newLead.Medical_Professional_Last_Name__c = 'hart';
            newLead.Medical_Professional_Phone__c = '9600467558';
            newLead.Medical_Professional_Email__c = 'testmawa1@gmail.com';
            newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC';
            newLead.Treating_Medical_Professional_First_Name__c =  'Steve';
            newLead.Treating_Medical_Professional_Last_Name__c = 'Waugh';
            newLead.Treating_Medical_Professional_Phone__c = '9600467557';
            newLead.Treating_Medical_Professional_Email__c = 'testmawa2@gmail.com';
            newLead.Hospital_Treatment_Facility_Treating__c =  'Moss Hart AC';
            leadTestDataList.add(newLead);
            
        }
        insert leadTestDataList;
    }
    
    public static Dynamic_Content__c  createDynamicContent()
    {
        Constant_AC constant = new Constant_AC();
        String nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.nationalRT).getRecordTypeId();
        Dynamic_Content__c  newContent = new Dynamic_Content__c();
        newContent.Sign_Up_Page__c = 'Hai';
        newContent.RecordTypeId = nationalRT;
        newContent.Application_Overview__c = 'An interview is a great way to better understand the role(s) and expectations of the volunteer opportunities that you are interested in';
        newContent .Active__c = true;
        newContent.Interview_Additional_Info__c = 'Test';
        newContent.Orientation_Add_l_Info__c = 'Test';
        newContent.Sign_Up_Page__c = 'Test';
        newContent.Training_Additional_Info__c = 'Test';
        newContent.Welcome_Message__c = 'Test';
        newContent.WelcomePage__c = 'Test';
        newContent.Welcome_Text__c = 'Test';
        newContent.Why_Need_Background_Check__c = 'Test';
        
        insert newContent;
        return newContent;
        
        
        
    }
    public static Dynamic_Content__c  createProspectiveDynamicContent()
    {
        Constant_AC constant = new Constant_AC();
        String nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.prospectiveVolunteerRT).getRecordTypeId();
        Dynamic_Content__c  newContent = new Dynamic_Content__c();
        newContent.Sign_Up_Page__c = 'Hai';
        newContent.RecordTypeId = nationalRT;
        newContent.Application_Overview__c = 'An interview is a great way to better understand the role(s) and expectations of the volunteer opportunities that you are interested in';
        newContent .Active__c = true;
        newContent.Interview_Additional_Info__c = 'Test';
        newContent.Orientation_Add_l_Info__c = 'Test';
        newContent.Sign_Up_Page__c = 'Test';
        newContent.Training_Additional_Info__c = 'Test';
        newContent.Welcome_Message__c = 'Test';
        newContent.WelcomePage__c = 'Test';
        newContent.Welcome_Text__c = 'Test';
        newContent.Why_Need_Background_Check__c = 'Test';
        newContent.Chapter_Name__c = createArizonaChapter();
        insert newContent;
        return newContent;
        
        
        
    }
   
    
    public static Account createChapter() {
        Constant_AC constant = new Constant_AC();
        String chapterRT= Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.ChapterRT).getRecordTypeId();
        Account newAccount = new Account();
        newAccount.Name = 'Make-A-Wish America';
        newAccount.RecordTypeId = chapterRT;
        insert newAccount;
        return newAccount;
    }
    
    public static Office__c createOffice() {
        Office__c newOffice = new Office__c();
        newOffice.Name = 'Make-A-Wish Alabama,NY, Inc.';
        newOffice.Office_Id__c = '014-000';
        newOffice.Office_Legal_Name__c = 'Make-A-Wish Alabama,NY, Inc.';
        newOffice.General_Email_Address__c = 'wishmail@suffolk.wish.org';
        newOffice.Website__c = 'http://suffolk.wish.org';
        newOffice.Address_1__c = '1 Comac Loop';
        newOffice.Address_2__c = 'Suite 1A1';
        newOffice.City__c = 'Ronkonkoma';
        newOffice.State__c = 'NY';
        newOffice.Zip_Code__c = '11779';
        newOffice.Country__c = 'US';
        newOffice.Phone_Number__c = '(631) 585-9474';
        return newOffice;
    }
    
    public static Zip_Code__c createZipCode() {
        Zip_Code__c newZipCode = new Zip_Code__c();
        //newZipCode.Name = '35004';
        return newZipCode;
    }
    
    public static Account createVolunteerAccount()
    {
        Constant_AC constant = new Constant_AC();
        String chapterRT= Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.ChapterRT).getRecordTypeId();
        Account newAccount = new Account();
        newAccount.Name = 'Make-A-Wish Alabama';
        newAccount.RecordTypeId = chapterRT;
        insert newAccount;
        system.debug('@@@@@@ newAccount @@@@@@@'+newAccount);
        return newAccount;
        
    }
    
    public static Contact createVolunteerContact(){
        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        Contact newContact = new Contact();
        newContact.FirstName = 'moss';
        newContact.LastName = 'Smith';
        
        newContact.Birth_Month__c = 'January';
        newContact.Birth_Day__c = '30';
        newContact.Birth_Year__c = '1989';
        newContact.Parent_Guardian_Name__c = 'Steve Smith'; 
        newContact.RecordTypeId = volunteerRecordTypeId;
        newContact.Title = 'Mr';
        
        
        newContact.Alternate_Phone_Type__c = 'Home';
        newContact.Preferred_Phone_Types__c = 'Mobile';
        newContact.Phone= '9003910426';
        newContact.I_m_on_LinkedIn__c ='Yes';
        newContact.How_did_you_hear_about_Make_A_Wish__c  = 'Family';
        newContact.MailingStreet  = 'ThillaiNagar';
        newContact.MailingCity = 'Trichy';
        newContact.MailingCountrycode = 'US';
        newContact.MailingPostalCode = '621010';
        newContact.mailingstatecode = 'AZ';
        newContact.Emergency_Contact__c  = 'Test';
        newContact.Emergency_Contact_Relationship__c  = 'Father';
        newContact.Emergency_Contact_Phone__c  = '9003910426';
        newContact.Read__c  = 'English';
        newContact.language__c = 'English';
        newContact.speak__c = 'English';
        newContact.understand__c = 'English';
        newContact.Professional_Skills__c = 'Photography';
        newContact.Language_Notes__c = 'Test';
        newContact.Volunteer_Role__c = 'Special Events';
        newContact.AccountId = TestClassUtil.createVolunteerAccount().Id;
        newContact.isApplication__c = false;
        
        insert newContact;
        system.debug('@@@@@@ newContact @@@@@@@'+newContact);
        return newContact;
        
    } 
    
    public static Contact createVolunteerContacttwo(){
        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        Contact newContact = new Contact();
        newContact.FirstName = 'moss';
        newContact.LastName = 'Smith';
        
        newContact.Birth_Month__c = '';
        newContact.Birth_Day__c = '';
        newContact.Birth_Year__c = '';
        newContact.Parent_Guardian_Name__c = ''; 
        newContact.RecordTypeId = volunteerRecordTypeId;
        newContact.Title = '';
        
       
        newContact.Alternate_Phone_Type__c = '';
        newContact.Preferred_Phone_Types__c = '';
        newContact.Phone= '';
        newContact.I_m_on_LinkedIn__c ='';
        newContact.How_did_you_hear_about_Make_A_Wish__c  = '';
        newContact.MailingStreet  = 'ThillaiNagar';
        newContact.MailingCity = 'Trichy';
        newContact.MailingCountrycode = 'US';
        newContact.MailingPostalCode = '621010';
        newContact.mailingstatecode = 'AZ';
        newContact.Emergency_Contact__c  = '';
        newContact.Emergency_Contact_Relationship__c  = '';
        newContact.Emergency_Contact_Phone__c  = '';
        newContact.Read__c  = '';
        newContact.language__c = '';
        newContact.speak__c = '';
        newContact.understand__c = '';
        newContact.Professional_Skills__c = '';
        newContact.Language_Notes__c = '';
        newContact.Volunteer_Role__c = '';
        newContact.AccountId = TestClassUtil.createVolunteerAccount().Id;
        
        insert newContact;
        system.debug('@@@@@@ newContact @@@@@@@'+newContact);
        return newContact;
        
    } 
    
    
    public static npe5__Affiliation__c createorgAffiliation(){
        
        npe5__Affiliation__c neworgAffiliation = new npe5__Affiliation__c ();
        neworgAffiliation.npe5__Contact__c  = TestClassUtil.createVolunteerContact().Id;
        neworgAffiliation.npe5__Organization__c = TestClassUtil.createVolunteerAccount().Id;
        neworgAffiliation.npe5__Primary__c = true;
        neworgAffiliation.npe5__Status__c = 'Prospective';
        insert neworgAffiliation;
        system.debug('@@@@@@ newOrgAffliation@@@@@@@'+neworgAffiliation);
        return neworgAffiliation;
        
    }
    
    
    public static void createProspectiveVolunteerUser(){ 
        
        
       // Profile volunteerProspectiveProfile = [SELECT Id FROM Profile WHERE Name = 'Prospective Volunteer'];
        String profileId = label.Prospective_Volunteer;
        
        newProspectiveVolunteerUser = new User(  firstname = 'Jonathan',created_from_portal__c = true,lastName = 'Edwards',email = 'jonathan@gmail.com',Username = 'joathanedwards@gmail.com',
                                               EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                               LanguageLocaleKey = 'en_US',ProfileId = profileId,ContactId = TestClassUtil.createVolunteerContact().id,isActive = true,Statecode = 'AZ');
        insert newProspectiveVolunteerUser;
        
    }
    
    public static void createProspectiveVolunteerUsertwo(){ 
        
        
        String profileId = label.Prospective_Volunteer;
        
        newProspectiveVolunteerUser = new User(  firstname = 'David',created_from_portal__c = true,lastName = 'Beckham',email = 'beckham@gmail.com',Username = 'Davidbeckham@gmail.com',
                                               EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                               LanguageLocaleKey = 'en_US',ProfileId = profileId,ContactId = TestClassUtil.createVolunteerContacttwo().id,isActive = true,Statecode = 'AZ');
        insert newProspectiveVolunteerUser;
        
    }
    
    public static void createProspectiveVolunteerUserthree(){ 
        
        
        String profileId = label.Prospective_Volunteer;
        
        newProspectiveVolunteerUser = new User(  firstname = 'David1',created_from_portal__c = true,lastName = 'Beckham1',email = 'beckham@gmail.com',Username = 'Davidbeckham@gmail.com',
                                               EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                               LanguageLocaleKey = 'en_US',ProfileId = profileId,ContactId = TestClassUtil.createVolunteerContacttwo().id,isActive = true,Statecode = 'AZ');
        insert newProspectiveVolunteerUser;
        
    }
    
    public static user createActiveVolunteerUser(){ 
        String profileId = label.Active_Volunteer_Profile;
        User newActiveVolunteerUser = new User(  firstname = 'Jonathan',created_from_portal__c = true,lastName = 'Edwards',email = 'jonathan@gmail.com',Username = 'joathanedwards@gmail.com',
                                               EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                               LanguageLocaleKey = 'en_US',ProfileId = profileId,ContactId = TestClassUtil.createVolunteerContact().id,isActive = true);
        insert newActiveVolunteerUser;
        return newActiveVolunteerUser;
        
    }
    
    public static Background_check__c createBackgroundCheck(Id conId){
        
        Background_check__c backCheck = new Background_check__c();
        backCheck.Date__c = system.today()+ 3;
        backCheck.Volunteer__c = conId;
        backCheck.Status__c = 'Approved w/ Conditions';
        insert backCheck;
        return backCheck;
    }
    public static Background_check__c createBackgroundCheckRec(){
        Background_check__c backCheck = new Background_check__c();
        backCheck.Date__c = system.today() + 3;
        backCheck.Volunteer__c = TestClassUtil.createVolunteerContact().id;
        backCheck.Status__c = '';
        insert backCheck;
        return backCheck;
    }
    
    public static void createCOI(Id conId){
        Conflict_Of_Interest__c newCOI = new Conflict_Of_Interest__c();
        newCOI.Volunteer_Contact__c = conId;
        newCOI.Expiration_Date__c = system.today() + 3;
        insert newCOI;
    }
    
    public Static Role__c createRole()
    {
        Role__c newRole = new Role__c();
        newRole.Name = 'WishGranter';
        insert newRole;
        return newRole;
    }
    
    public static Chapter_Role__c createchapterRole()
    {
        Chapter_Role__c newchapterRole = new Chapter_Role__c();
        newchapterRole.Chapter_Name__c = TestClassUtil.createVolunteerAccount().Id;
        newchapterRole.Role_Name__c = TestClassUtil.createRole().Id;
        insert newchapterRole;
        return newchapterRole;
    }
    public static Chapter_Role__c createchapterRoleone(Id accId,Id roleId)
    {
        Chapter_Role__c newchapterRole = new Chapter_Role__c();
        newchapterRole.Chapter_Name__c = accId;
        newchapterRole.Role_Name__c = roleId;
        insert newchapterRole;
        return newchapterRole;
    }
    public static Volunteer_Roles__c createVolunteerRole(){
        Volunteer_Roles__c newVolRole = new Volunteer_Roles__c();
        newVolRole.Chapter_Role__c = TestClassUtil.createchapterRole().Id;
        newVolRole.Volunteer_Name__c = TestClassUtil.createVolunteerContact().Id;
        insert newVolRole;
        return newVolRole;
    }
    
    public static Volunteer_Roles__c createVolunteerRoleone(Id conId,Id chapterRoleId){
        Volunteer_Roles__c newVolRole = new Volunteer_Roles__c();
        newVolRole.Chapter_Role__c = chapterRoleId;
        newVolRole.Volunteer_Name__c = conId;
        insert newVolRole;
        return newVolRole;
    }
    
    public static Orientation_Training__c createOrientationForProfile(){
        Constant_AC  constant = new Constant_AC();
        Id volunteerOrientationRecordTypeId = Schema.SObjectType.Orientation_Training__c.getRecordTypeInfosByName().get(constant.OrientationRT).getRecordTypeId();
        Orientation_Training__c newOrientation = new Orientation_Training__c();
        newOrientation.Name = 'Test Orienatation';
        newOrientation.RecordTypeId = volunteerOrientationRecordTypeId;
      
        insert newOrientation;
        return newOrientation;
    }
    
    public static Chapter_Role_O_T__c chapterRoleRT(Id chapterRoleId){
        Chapter_Role_O_T__c newchapterRole = new Chapter_Role_O_T__c();
        newchapterRole.Chapter_Role__c = chapterRoleId;
        newchapterRole.Orientation_Training__c = TestClassUtil.createTrainingForProfile().id;
        insert newchapterRole;
        return newchapterRole;
    }
    
    public static Volunteer_Orientation_Training__c createVolOandTringing(Id ConId){
        
        
        Volunteer_Orientation_Training__c newVol = new Volunteer_Orientation_Training__c();
        newVol.Hidden_O_T_Id__c = TestClassUtil.createTrainingForProfile().id;
        newVol.Volunteer__c = ConId;
        newVol.Volunteer_Attendance__c = 'Registered';
        newVol.Type__c = 'Training';
        insert newVol;
        return newVol;
    }
    
    public static void createVolOandOrientation(Id conId){
        Volunteer_Orientation_Training__c newVol = new Volunteer_Orientation_Training__c();
        newVol.Hidden_O_T_Id__c = TestClassUtil.createTrainingForProfile().id;
        newVol.Volunteer__c = conId;
        newVol.Volunteer_Attendance__c = 'Registered';
        newVol.Type__c = 'Orientation';
        insert newVol;
    }
    
    
    public static void CreateVolunteerOrientationTraining(Integer recordCount){
        
        Constant_AC  constant = new Constant_AC();
        Id volunteerOrientationRecordTypeId = Schema.SObjectType.Orientation_Training__c.getRecordTypeInfosByName().get(constant.OrientationRT).getRecordTypeId();
        Id volunteerTrainingRecordTypeId = Schema.SObjectType.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();
        List<Orientation_Training__c> newOrientationTraining = new List<Orientation_Training__c>();
        for(Integer i=1; i<=recordCount; i++) {
            Orientation_Training__c newOrientation = new Orientation_Training__c();
            if(i<5) {
                newOrientation.Name = 'Orienatation'+i;
                newOrientation.RecordTypeId = volunteerOrientationRecordTypeId;
               
            } else {
                newOrientation.Name = 'Training'+i;
                newOrientation.RecordTypeId = volunteerTrainingRecordTypeId; 
                }
           
            newOrientationTraining.add(newOrientation);
        }
        if(newOrientationTraining.size()>0) {
            insert newOrientationTraining;
        }
    }
    public Static void cretateGroup(){
        Group leadalabamaGroup = new Group(Type='Regular', Name='Arizona');
        insert leadalabamaGroup ;
    }
    public static User createCommunityProspectiveVolunteerUser(){ 
        
        String prospectiveProfileId = label.Prospective_Volunteer;
        newProspectiveVolunteerUser = new User(firstname = 'Jonathan',created_from_portal__c = true,lastName = 'Edwards',email = 'jonathan@gmail.com',Username = 'joathanedwards@gmail.com',
                                               EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                               LanguageLocaleKey = 'en_US',ProfileId = prospectiveProfileId,ContactId = TestClassUtil.createVolunteerContact().id,isActive = true);
        return newProspectiveVolunteerUser;
    }
    
    public static npe5__Affiliation__c CreateAffiliation() {
        npe5__Affiliation__c newAffiliation = new npe5__Affiliation__c();
        newAffiliation.npe5__Role__c = 'Prospective Volunteer';
        newAffiliation.npe5__Contact__c = TestClassUtil.createVolunteerContact().id;
        newAffiliation.npe5__Primary__c = true;
        newAffiliation.npe5__Organization__c = chapterAccountList.get(0).id;
        return newAffiliation;
    }
    
    
    public static Orientation_Training__c createTrainingForProfile(){
        Constant_AC  constant = new Constant_AC();
        Id volunteerTrainingRecordTypeId = Schema.SObjectType.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();
        Orientation_Training__c newOrientation = new Orientation_Training__c();
        newOrientation.Name = 'Training';
        newOrientation.RecordTypeId = volunteerTrainingRecordTypeId; 
        insert newOrientation;
        return newOrientation;
    }
    
    public static void createVolunteerOrientationForProfile(){
        Volunteer_Orientation_Training__c newVol = new Volunteer_Orientation_Training__c();
        newVol.Hidden_O_T_Id__c = createOrientationForProfile().id;
        newVol.Volunteer__c = createVolunteerContact().id;
        newVol.Volunteer_Attendance__c = 'Registered';
        insert newVol;
    }
    
    public static void createVolunteerTrainingForProfile(){
        Volunteer_Orientation_Training__c newVol = new Volunteer_Orientation_Training__c();
        newVol.Hidden_O_T_Id__c = createTrainingForProfile().id;
        newVol.Volunteer__c = createVolunteerContact().id;
        newVol.Volunteer_Attendance__c = 'Completed';
        insert newVol;
    }
    
    public Static DocuSignCredentialsSetting__c insertDocusignSetting(){
        DocuSignCredentialsSetting__c newSetting = new DocuSignCredentialsSetting__c();
        newSetting.account__c = '0afd45e1-ae2d-468c-a168-b8603dae66a3';
        newSetting.IntegratorKey__c = 'ea6d625f-6c08-4b12-aa2d-554909addb30';
        newSetting.Password__c = 'metasoft100';
        newSetting.Name = 'kanagaraj@mstsolutions.com';
        insert newSetting;
        return newSetting;
    }
    
    public static void createDocusignStatus(Integer count){
        List<dsfs__DocuSign_Status__c> docusignList = new List<dsfs__DocuSign_Status__c>();
        for(Integer i = 0; i<= count;i++){
            dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
            dsfs.dsfs__DocuSign_Envelope_ID__c = '0F31B5A9-DB3A-4D31-8D69-9DE86F2010A8';
            dsfs.dsfs__Contact__c = TestClassUtil.createVolunteerContact().Id;
            dsfs.isConflict__c = false;
            dsfs.dsfs__Envelope_Status__c = 'Deliverd';
            dsfs.Docusign_Hidden_Contact__c = TestClassUtil.createVolunteerContact().id;
            docusignList.add(dsfs);
        }
        Insert docusignList;
    }
    
    public static void createDocusignStatusFalse(Integer count){
        List<dsfs__DocuSign_Status__c> docusignList = new List<dsfs__DocuSign_Status__c>();
        for(Integer i = 0; i<= count;i++){
            dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
            dsfs.dsfs__DocuSign_Envelope_ID__c = '0F31B5A9-DB3A-4D31-8D69-9DE86F2010A8';
            dsfs.dsfs__Contact__c = TestClassUtil.createVolunteerContact().Id;
            dsfs.isConflict__c = true;
            dsfs.dsfs__Envelope_Status__c = 'Deliverd';
            docusignList.add(dsfs);
        }
        Insert docusignList;
    }
    
    public Static Case createWishDetermination(Id accId,Id conId){
        Constant_AC  constant = new Constant_AC();
        Id wishDeterminationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        
        Case newWish = new Case();
        newWish.Wish_type__c = 'Cruise';
        newWish.Status = 'New';
        newWish.Origin = 'Phone';
        newWish.AccountId = accId;
        newWish.ContactId = conId;
        newWish.recordTypeId = wishDeterminationId ;
        
        insert newWish;
        return newWish;
    }
    
    public Static Non_Wish_Events__c createNonWishEvent(Id accId){
        Constant_AC  constant = new Constant_AC();
        Id nonWishEventRTId = Schema.SObjectType.Non_Wish_Events__c.getRecordTypeInfosByName().get(constant.nonWishRT).getRecordTypeId();
        
        Non_Wish_Events__c newEvent = new Non_Wish_Events__c();
        newEvent.Chapter__c = accId;
        newEvent.Event_Date__c = system.today() + 30;
        newEvent.Event_Text__c = 'Test';
        newEvent.RecordTypeId = nonWishEventRTId;
        newEvent.Event_Name__c = 'Test';
        
        insert newEvent ;
        return newEvent ;
    }
    
    public Static List<Volunteer_Opportunity__c>  createWishVolOpportunity(integer count,Id accId,Id conId,Id CaseId){
        List<Volunteer_Opportunity__c> wishVolOppList = new List<Volunteer_Opportunity__c>();
        for(integer i=0;i<=count;i++){
            Volunteer_Opportunity__c newVolOpp = new Volunteer_Opportunity__c();
            newVolOpp.Chapter_Name__c = accId;
            newVolOpp.Volunteer_Name__c =conId; 
            newVolOpp.Wish__c = CaseId;
            newVolOpp.Chapter_Role_Opportunity__c = TestClassUtil.createchapterRole().Id;
            wishVolOppList.add(newVolOpp);
        }
        insert wishVolOppList;
        return wishVolOppList;
    }
    
    
    
    public Static List<Volunteer_Opportunity__c>  createNonWishVolOpportunity(integer count,Id accId,Id conId,Id nonWishId){
        List<Volunteer_Opportunity__c> nonWishVolOpp = new List<Volunteer_Opportunity__c>();
        for(integer i=0;i<=count;i++){
            Volunteer_Opportunity__c newVolOpp = new Volunteer_Opportunity__c();
            newVolOpp.Chapter_Name__c = accId;
            newVolOpp.Volunteer_Name__c =conId; 
            newVolOpp.Non_Wish_Event__c =nonWishId;
            newVolOpp.Chapter_Role_Opportunity__c = TestClassUtil.createchapterRole().Id;
            nonWishVolOpp.add(newVolOpp);
        }
        insert nonWishVolOpp;
        return nonWishVolOpp;
    }
    
    public Static  List<Time_sheet__c> crateWishTimeSheet(Integer count,List<Volunteer_Opportunity__c> wishoppList){
        List<Time_sheet__c> wishDeterminationList = new List<Time_sheet__c>();
        for(Integer i = 0; i< count; i++){
            Time_sheet__c newTimeSheet = new Time_sheet__c();
            newTimeSheet.Date__c = system.today();
            newTimeSheet.Hours_spent__c = 12.50;
            newTimeSheet.Volunteer_Opportunity__c =wishoppList.get(i).Id;
            wishDeterminationList.add(newTimeSheet);
        }
        insert wishDeterminationList ;
        return wishDeterminationList ;
        
    }
    
    public Static  List<Time_sheet__c> crateNonWishTimeSheet(Integer count,List<Volunteer_Opportunity__c> nonWishoppList){
        List<Time_sheet__c> nonwishDeterminationList = new List<Time_sheet__c>();
        for(Integer i = 0; i< count; i++){
            Time_sheet__c newTimeSheet = new Time_sheet__c();
            newTimeSheet.Date__c = system.today();
            newTimeSheet.Hours_spent__c = 12.50;
            newTimeSheet.Volunteer_Opportunity__c =nonWishoppList.get(i).Id;
            nonwishDeterminationList .add(newTimeSheet);
        }
        insert nonwishDeterminationList;
        return nonwishDeterminationList;
        
    }
    
    
    public static Account createchapterAccount(){
        Constant_AC  constant = new Constant_AC();
        Id ChapterRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        Account newchapterAccount = new Account();
        newchapterAccount .Name = 'Arizona - Chapter';
        newchapterAccount.RecordTypeId = ChapterRecordTypeId;
        insert newchapterAccount ;
        return newchapterAccount;
    }
    
    public static Chapter_Action_Track__c CreateChapterActionTrack() {
        Chapter_Action_Track__c newChapterAction = new Chapter_Action_Track__c();
        //newChapterAction.Assigned_To__c = 'Volunteer Manager';
        //newChapterAction.Case_Type_Stage__c = 'Wish Determination';
        
        newChapterAction.Task_Name__c = 'Planning';
        newChapterAction.Sort_Order__c = 1;
        newChapterAction.Wish_type__c = 'Standard';
        //newChapterAction.Recurring__c = true;
        //newChapterAction.Recurring_Frequency__c = 1;
        return newChapterAction;
    }
    
    public static Chapter_Action_Track__c DuplicateChapterActionTrack() {
        Chapter_Action_Track__c newChapterAction = new Chapter_Action_Track__c();
        newChapterAction.Task_Name__c = 'Planning';
        //newChapterAction.Assigned_To__c = 'Volunteer Manager';
        //newChapterAction.Case_Type_Stage__c = 'Wish Determination';
        
        newChapterAction.Wish_type__c = 'Standard';
        //newChapterAction.Recurring__c = true;
        //newChapterAction.Recurring_Frequency__c = 1;
        return newChapterAction;
    }
    
    public static Case CreateParentCase() {
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = Null;
        newParentWish.Subject = 'Parent Wish';
        insert newParentWish;
        return newParentWish;
    }   
    
    public static Contact CreateWishChild() {
        Constant_AC  constant = new Constant_AC();
        Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        Contact newWishChild = new Contact();
        newWishChild.RecordTypeId = wishChildRecordTypeId;
        newWishChild.FirstName = 'John';
        newWishChild.LastName = 'Smith';
        insert newWishChild;
        return newWishChild;
    }
    
    public static Case DeterminationCaseProcess() {
        Constant_AC  constant = new Constant_Ac();    
        Id wishDeterminationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newWishDeterminatonWish = new Case();
        newWishDeterminatonWish.RecordTypeId = wishDeterminationRecordTypeId;
        newWishDeterminatonWish.ChapterName__c = createArizonaChapter();
        newWishDeterminatonWish.Subject = 'Wish Determination';
        newWishDeterminatonWish.Wish_Type__c = 'Standard';
        return newWishDeterminatonWish;
    }
    
    public static Task CreateNewTask() {
        Task newTask = new Task();
        newTask.Subject = 'Planning';
        newTask.IsRecurrence = false;
        return newTask;
    }
    
    public static List<Dynamic_Content__c> ChapterDynamicContent() {
        List<Dynamic_Content__c> newChapterContentList = new List<Dynamic_Content__c>();
        Dynamic_Content__c newChapterContent = new Dynamic_Content__c();
        newChapterContent.Feature_Quote__c = 'Test Feature Quote';
        newChapterContent.Active__c = true;
        newChapterContent.Welcome_Message__c = 'Test Welcome Page';
        newChapterContent.Heading_Highlight_Text_1__c = 'Test Heightlisght Text';
        newChapterContent.Heading_Highlight_Text_2__c = 'Test Heightlisght Text';
        newChapterContent.Heading_Highlight_Text_3__c = 'Test Heightlisght Text';
        newChapterContent.Heading_Highlight_Title_1__c = 'Test Title';
        newChapterContent.Heading_Highlight_Title_2__c = 'Test Title';
        newChapterContent.Heading_Highlight_Title_3__c = 'Test Title';
        newChapterContentList.add(newChapterContent);
        return newChapterContentList;
    }
    
    public Static HoldCurrentChapter__c CurrentChapter(Id activeuserId) {
        HoldCurrentChapter__c newChapter = new HoldCurrentChapter__c();
        newChapter.CurrentChapter__c = 'Arizona - Chapter';
        newChapter.Name = activeuserId;
        insert newChapter;
        return newChapter;
    }
     /* Date Added : 08/16/2016
    Added by : Sailappa Vignesh PG
    This method will create a LMSCredentials details (Custom setting )*/
    public static LMS_Credentials__c createLMSCredentials(){
        LMS_Credentials__c currLMSCredential = new LMS_Credentials__c();
        currLMSCredential.CourseEndpoint__c = '/course';
        currLMSCredential.End_Point_URL__c = 'www.test.com';
        currLMSCredential.EnrollmentEndPoint__c = '/Enrollment';
        currLMSCredential.Password__c = 'test';
        currLMSCredential.SSOEndPoint__c = '/SSO';
        currLMSCredential.UserCreaationEndpoint__c = '/Usercreation';
        currLMSCredential.User_Name__c = 'Test';
        currLMSCredential.Name = 'LMS Integration';
        try{
            Insert currLMSCredential;
        }catch(exception ex){
            System.debug('Exception ex'+ex.getMessage());
        }
        return currLMSCredential;

    }
    /* Date Added : 08/16/2016
    Added by : Sailappa Vignesh PG
    This method will create a Class_Offering__c record */
    public static Class_Offering__c createClassOffering(){
        Class_Offering__c currClassOffering = new Class_Offering__c();
        currClassOffering.Course_ID__c = 'Test Test';
        try{
                insert currClassOffering;
            } catch(Exception ex){
                system.debug('exception '+ex.getMessage());
            } 
        return currClassOffering;  

    }

}