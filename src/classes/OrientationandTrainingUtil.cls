@isTest
public class OrientationandTrainingUtil{
    
    public static Account createchapterAccount(){
        Constant_AC  constant = new Constant_AC();
        Id ChapterRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        
        Account newchapterAccount = new Account();
        newchapterAccount .Name = 'Make-A-Wish Alabama';
        newchapterAccount.RecordTypeId = ChapterRecordTypeId;
        newchapterAccount.MAC_Email_del__c = 'Test@gmail.com';
        insert newchapterAccount;
        return newchapterAccount;
    }
    
    public static Account HouseHoldAccount(){
        Constant_AC  constant = new Constant_AC();
        Id houseHoldRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.HouseholdRT).getRecordTypeId();
        Account houseHoldAccount = new Account();
        houseHoldAccount.Name = 'TestHouseHoldAccount';
        houseHoldAccount.RecordTypeId = houseHoldRecordTypeId;
        insert houseHoldAccount;
        return houseHoldAccount;
    }
    
    public static id CreateAlabamaAccount(){
        Constant_AC  constant = new Constant_AC();
        Id ChapterRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        Account newchapterAccount = new Account();
        newchapterAccount.Name = 'Make-A-Wish Alabama';
        newchapterAccount.RecordTypeId = ChapterRecordTypeId;
        insert newchapterAccount;
        return newchapterAccount.id;
    }
    public static account CreateAmericaAccount(){
        Constant_AC  constant = new Constant_AC();
        Id ChapterRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        Account newchapterAccount = new Account();
        newchapterAccount.Name = 'Make-A-Wish America';
        newchapterAccount.RecordTypeId = ChapterRecordTypeId;
        newchapterAccount.Wish_Co_ordinator__c = Userinfo.getUserId();
        insert newchapterAccount;
        return newchapterAccount;
    }
    
    public static Account inKindAccount(){
        Constant_AC  constant = new Constant_AC();
        Id inKindDonorsAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('In Kind Donors').getRecordTypeId();
        
        Account newchapterAccount = new Account();
        newchapterAccount .Name = 'InKind Account';
        newchapterAccount.RecordTypeId = inKindDonorsAccountRTId;
        //insert newchapterAccount;
        return newchapterAccount;
    }
    
    public static Account inKindAccountWithStatus(){
        Constant_AC  constant = new Constant_AC();
        Id inKindDonorsAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('In Kind Donors').getRecordTypeId();
        Account newchapterAccount = new Account();
        newchapterAccount .Name = 'InKind Account';
        newchapterAccount.RecordTypeId = inKindDonorsAccountRTId;
        insert newchapterAccount;
        return newchapterAccount;
    }
    
    public static Account inKindAccountWithSChpater(Id chapterAccountId){
        Id inKindDonorsAccountRTId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('In Kind Donors').getRecordTypeId();
        Account newchapterAccount = new Account();
        newchapterAccount .Name = 'InKind Account';
        newchapterAccount.RecordTypeId = inKindDonorsAccountRTId;
        newchapterAccount.Chapter_Name__c = chapterAccountId;
        insert newchapterAccount;
        return newchapterAccount;
    }
    
    public static void createChapterList(){
        /* Chapter_List__c newChapter = new Chapter_List__c();
newChapter.Name = '35004';
newChapter.chapter_name__c= 'Alabama';
insert newChapter;*/
    }
    
    public static Role__c createRole()
    {
        Role__c newRole = new Role__c();
        newRole.Name = 'Wish Granter';
        newRole.isWishRole__c = true;
        insert newRole;
        return newRole;
    }
    
    public static Role__c createNonWishRole()
    {
        Role__c newRole = new Role__c();
        newRole.Name = 'Water Handler';
        newRole.isWishRole__c = false;
        insert newRole;
        return newRole;
    }
    
    public Static Chapter_Role__c createChapter(String chapterId, String RoleId)
    {
        Chapter_Role__c newChapRole = new Chapter_Role__c();
        newChapRole.Chapter_Name__c = chapterId;
        newChapRole.Role_Name__c = roleId;
        insert newChapRole;
        return newChapRole;
        
    }
    
    public static Volunteer_Roles__c createVolRole(String contactId, String chapterRoleId)
    {
        Volunteer_Roles__c newVolRole = new Volunteer_Roles__c ();
        newVolRole.Chapter_Role__c = chapterRoleId;
        newVolRole.Volunteer_Name__c = contactId;
        newVolRole.Status__c = 'Trained';
        insert newVolRole;
        return newVolRole;
        
    }
    
    public static Orientation_Training__c CreateVolunteerTrainingRecord(){
        Constant_AC  constant = new Constant_AC();
        Id volunteerTrainingRecordTypeId = Schema.SObjectType.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();
        Orientation_Training__c newTraining = new Orientation_Training__c();
        newTraining.Name = 'Trainging1';
        newTraining.RecordTypeId = volunteerTrainingRecordTypeId ;
        
        insert newTraining;
        return newTraining;
    }
    
    public static Orientation_Training__c CreateVolunteerOrientationRecord(){
        Constant_AC  constant = new Constant_AC();
        Id volunteerOrientationRecordTypeId = Schema.SObjectType.Orientation_Training__c.getRecordTypeInfosByName().get(constant.OrientationRT).getRecordTypeId();
        Orientation_Training__c newOrientation = new Orientation_Training__c();
        newOrientation.Name = 'Orienatation1';
        newOrientation.RecordTypeId = volunteerOrientationRecordTypeId;
        
        insert newOrientation;
        return newOrientation;
    }
    
    public static Chapter_Role_O_T__c createChapterOandT(String chapterRole, String OrientationId)
    {
        Chapter_Role_O_T__c  newChapterRoleOandT = new Chapter_Role_O_T__c();
        newChapterRoleOandT.Orientation_Training__c = OrientationId;
        newChapterRoleOandT.Chapter_Role__c = chapterRole;
        newChapterRoleOandT.Required__c = true;
        insert newChapterRoleOandT;
        return newChapterRoleOandT;
    }
    
    public static Class_Offering__c createClassOffering(String chapRoleandId)
    {
        Class_Offering__c newOffering = new Class_Offering__c();
        Constant_AC  constant = new Constant_AC();
        newOffering.Chapter_Role_O_T__c = chapRoleandId;
        newOffering.Date__c = System.Today() +10;
        newOffering.Start_Time__c = '10:00 AM';
        newOffering.End_Time__c = '11:00 AM';
        newOffering.max_capacity__c= 100;
        newOffering.Location__c = 'Test';
        newOffering.RecordTypeId = Schema.SObjectType.Class_Offering__c.getRecordTypeInfosByName().get(constant.classOfferingRecordTypeId).getRecordTypeId();
        insert newOffering;
        return newOffering;
    }
    public static Class_Offering__c createClassOfferingDup(String chapRoleandId)
    {
        Class_Offering__c newOffering = new Class_Offering__c();
        newOffering.Chapter_Role_O_T__c = chapRoleandId;
        newOffering.Date__c = System.Today() +10;
        newOffering.Start_Time__c = '12:00 AM';
        newOffering.End_Time__c = '1:00 AM';
        newOffering.max_capacity__c= 100;
        newOffering.Location__c = 'Test';
        insert newOffering;
        return newOffering;
    }
    public static Account createVolunteerAccount(){
        Constant_AC constant = new Constant_AC();
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        String chapterRT= Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.ChapterRT).getRecordTypeId();
        Account newAccount = new Account();
        newAccount.Name = 'Make-A-Wish Alabama';
        newAccount.RecordTypeId = chapterRT;
        newAccount.Volunteer_Manager__c = currUser.Id;
        insert newAccount;
        return newAccount;
    }
    public static Account createVolunteerAccountwithVolunteerManager(){
        Constant_AC constant = new Constant_AC();
        String chapterRT= Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.ChapterRT).getRecordTypeId();
        Account newAccount = new Account();
        newAccount.Name = 'Make-A-Wish Alabama';
        newAccount.RecordTypeId = chapterRT;
        newAccount.Volunteer_Manager__c=createUser().Id;
        insert newAccount;
        return newAccount;
    }
    
    public static User createUser(){ 
        
        
        Profile volunteerSystemAdministrator = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User newPvolunteerSystemAdministratorUser = new User(  firstname = 'Jon',lastName = 'Edwards',email = 'jon@gmail.com',Username = 'joncena123p0@gmail.com',
                                                             EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                                             LanguageLocaleKey = 'en_US',ProfileId = volunteerSystemAdministrator.Id,isActive = true,Statecode = 'AZ');
        insert newPvolunteerSystemAdministratorUser ;
        return newPvolunteerSystemAdministratorUser ;
        
    }
    
    public static User createUserWithRole(Id roleId){ 
        
        
        Profile volunteerSystemAdministrator = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User newPvolunteerSystemAdministratorUser = new User(  firstname = 'JonJesu',lastName = 'EdwardsJo',email = 'jonemail@gma111il.com',Username = 'jonsamp0@gma11il.com',
                                                             EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                                             LanguageLocaleKey = 'en_US', UserRoleId = roleId, ProfileId = volunteerSystemAdministrator.Id,isActive = true,Statecode = 'AZ');
        insert newPvolunteerSystemAdministratorUser ;
        return newPvolunteerSystemAdministratorUser ;
        
    }
    
    
    public static Account createVolunteerAccountWithWishCoordinatior(Id wishCoordinator){
        Constant_AC constant = new Constant_AC();
        String chapterRT= Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.ChapterRT).getRecordTypeId();
        Account newAccount = new Account();
        newAccount.Name = 'Make-A-Wish Alabama';
        newAccount.RecordTypeId = chapterRT;
        newAccount.Wish_Co_ordinator__c = wishCoordinator;
        newAccount.DevStaffEmail__c = 'chandrasekar@mstsolutions.com';
        insert newAccount;
        return newAccount;
        
    }
    
    
    
    public static Contact createVolunteerContact(Id AccountId){
        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        Contact newContact = new Contact();
        newContact.FirstName = 'moss';
        newContact.LastName = 'Smith';
        newContact.Birthdate = System.today()-1;
        newContact.Parent_Guardian_Name__c = 'Steve Smith'; 
        newContact.RecordTypeId = volunteerRecordTypeId;
        newContact.Title = 'Mr';
        newContact.Birth_Month__c = 'January';
        newContact.Birth_Day__c = '12';
        newContact.Birth_Year__c = '1985';
        newContact.Alternate_Phone_Type__c = 'Home';
        newContact.Preferred_Phone_Types__c = 'Mobile';
        newContact.OtherPhone = '3332211144';
        newContact.HomePhone= '9003910426';
        newContact.MobilePhone= '9003910426';
        newContact.I_m_on_LinkedIn__c ='Yes';
        newContact.How_did_you_hear_about_Make_A_Wish__c  = 'Family';
        newContact.MailingStreet  = 'ThillaiNagar';
        newContact.MailingCity = 'Trichy';
        newContact.MailingCountrycode = 'US';
        newContact.MailingPostalCode = '621010';
        newContact.mailingstatecode = 'AZ';
        newContact.Emergency_Contact__c  = 'Test';
        newContact.Emergency_Contact_Relationship__c= 'Father';
        newContact.Emergency_Contact_Phone__c  = '9003910426';
        newContact.Read__c  = 'English';
        newContact.language__c = 'English';
        newContact.speak__c = 'English';
        newContact.understand__c = 'English';
        newContact.Professional_Skills__c = 'Photography';
        newContact.Language_Notes__c = 'Test';
        newContact.Volunteer_Role__c = 'Special Events';
        newContact.is_Application__c ='Partial Submit';
        newContact.AccountId = AccountId;
        newContact.Volunteer_Role__c = 'Water Handler';
        
        insert newContact;
        return newContact;
    } 
    
    public static Contact createVolunteerContactwithOtherPhone(Id AccountId){
        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        Contact newContact = new Contact();
        newContact.FirstName = 'moss';
        newContact.LastName = 'Smith';
        newContact.Birthdate = System.today()-1;
        newContact.Parent_Guardian_Name__c = 'Steve Smith'; 
        newContact.RecordTypeId = volunteerRecordTypeId;
        newContact.Title = 'Mr';
        newContact.Birth_Month__c = 'January';
        newContact.Birth_Day__c = '12';
        newContact.Birth_Year__c = '1985';
        newContact.Alternate_Phone_Type__c = 'Mobile';
        newContact.Preferred_Phone_Types__c = 'Home';
        newContact.OtherPhone = '3332211144';
        newContact.HomePhone= '9003910426';
        newContact.MobilePhone= '9003910426';
        newContact.I_m_on_LinkedIn__c ='Yes';
        newContact.How_did_you_hear_about_Make_A_Wish__c  = 'Family';
        newContact.MailingStreet  = 'ThillaiNagar';
        newContact.MailingCity = 'Trichy';
        newContact.MailingCountrycode = 'US';
        newContact.MailingPostalCode = '621010';
        newContact.mailingstatecode = 'AZ';
        newContact.Emergency_Contact__c  = 'Test';
        newContact.Emergency_Contact_Relationship__c= 'Father';
        newContact.Emergency_Contact_Phone__c  = '9003910426';
        newContact.Read__c  = 'English';
        newContact.language__c = 'English';
        newContact.speak__c = 'English';
        newContact.understand__c = 'English';
        newContact.Professional_Skills__c = 'Photography';
        newContact.Language_Notes__c = 'Test';
        newContact.Volunteer_Role__c = 'Special Events';
        newContact.is_Application__c ='Partial Submit';
        newContact.AccountId = AccountId;
        newContact.Volunteer_Role__c = 'Water Handler';
        
        insert newContact;
        return newContact;
    } 
    
    
    public static Contact VolunteerContactwithHomePhone(Id AccountId){
        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        Contact newContact = new Contact();
        newContact.FirstName = 'moss';
        newContact.LastName = 'Smith';
        newContact.Birthdate = System.today()-1;
        newContact.Parent_Guardian_Name__c = 'Steve Smith'; 
        newContact.RecordTypeId = volunteerRecordTypeId;
        newContact.Title = 'Mr';
        newContact.Birth_Month__c = 'January';
        newContact.Birth_Day__c = '12';
        newContact.Birth_Year__c = '1985';
        newContact.Alternate_Phone_Type__c = 'Home';
        newContact.Preferred_Phone_Types__c = 'Home';
        newContact.HomePhone= '9003910426';
        newContact.otherPhone= '9003910426';
        newContact.I_m_on_LinkedIn__c ='Yes';
        newContact.How_did_you_hear_about_Make_A_Wish__c  = 'Family';
        newContact.MailingStreet  = 'ThillaiNagar';
        newContact.MailingCity = 'Trichy';
        newContact.MailingCountrycode = 'US';
        newContact.MailingPostalCode = '621010';
        newContact.mailingstatecode = 'AZ';
        newContact.Emergency_Contact__c  = 'Test';
        newContact.Emergency_Contact_Relationship__c= 'Father';
        newContact.Emergency_Contact_Phone__c  = '9003910426';
        newContact.Read__c  = 'English';
        newContact.language__c = 'English';
        newContact.speak__c = 'English';
        newContact.understand__c = 'English';
        newContact.Professional_Skills__c = 'Photography';
        newContact.Language_Notes__c = 'Test';
        newContact.Volunteer_Role__c = 'Special Events';
        newContact.is_Application__c ='Partial Submit';
        newContact.AccountId = AccountId;
        newContact.Volunteer_Role__c = 'Water Handler';
        
        insert newContact;
        return newContact;
    } 
    
    public static Contact VolunteerContactwithMobilePhone(Id AccountId){
        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        Contact newContact = new Contact();
        newContact.FirstName = 'moss';
        newContact.LastName = 'Smith';
        newContact.Birthdate = System.today()-1;
        newContact.Parent_Guardian_Name__c = 'Steve Smith'; 
        newContact.RecordTypeId = volunteerRecordTypeId;
        newContact.Title = 'Mr';
        newContact.Birth_Month__c = 'January';
        newContact.Birth_Day__c = '12';
        newContact.Birth_Year__c = '1985';
        newContact.Alternate_Phone_Type__c = 'Mobile';
        newContact.Preferred_Phone_Types__c = 'Mobile';
        newContact.MobilePhone= '9003910426';
        newContact.otherPhone= '9003910426';
        newContact.I_m_on_LinkedIn__c ='Yes';
        newContact.How_did_you_hear_about_Make_A_Wish__c  = 'Family';
        newContact.MailingStreet  = 'ThillaiNagar';
        newContact.MailingCity = 'Trichy';
        newContact.MailingCountrycode = 'US';
        newContact.MailingPostalCode = '621010';
        newContact.mailingstatecode = 'AZ';
        newContact.Emergency_Contact__c  = 'Test';
        newContact.Emergency_Contact_Relationship__c= 'Father';
        newContact.Emergency_Contact_Phone__c  = '9003910426';
        newContact.Read__c  = 'English';
        newContact.language__c = 'English';
        newContact.speak__c = 'English';
        newContact.understand__c = 'English';
        newContact.Professional_Skills__c = 'Photography';
        newContact.Language_Notes__c = 'Test';
        newContact.Volunteer_Role__c = 'Special Events';
        newContact.is_Application__c ='Partial Submit';
        newContact.AccountId = AccountId;
        newContact.Volunteer_Role__c = 'Water Handler';
        
        insert newContact;
        return newContact;
    } 
    
    public static User createProspectiveVolunteerUser(Id contactId){ 
        
        
        //  Profile volunteerProspectiveProfile = [SELECT Id FROM Profile WHERE Name = 'Prospective Volunteer'];
        
        String prospectiveProfileId = label.Prospective_Volunteer;
        
        User newProspectiveVolunteerUser = new User(  firstname = 'Jonathanan',lastName = 'Edward',email = 'jonathanEdwards@gmail.com',Username = 'joathanedwards@gmail.com',
                                                    EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                                    LanguageLocaleKey = 'en_US',created_from_portal__c = true,ProfileId = prospectiveProfileId,ContactId = contactId,isActive = true,Statecode = 'AZ');
        insert newProspectiveVolunteerUser;
        return newProspectiveVolunteerUser;
        
    }
    
    public static User createUserWithOutContact(){ 
        
        
        //Profile volunteerProspectiveProfile = [SELECT Id FROM Profile WHERE Name = 'Prospective Volunteer'];
        String prospectiveProfileId = label.Prospective_Volunteer;
        
        User newProspectiveVolunteerUser = new User(  firstname = 'Jonathan',lastName = 'Edwards',email = 'jonathan@gmail.com',Username = 'joathanedwards@gmail.com',
                                                    EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                                    LanguageLocaleKey = 'en_US',created_from_portal__c = true,ProfileId = prospectiveProfileId,isActive = true,Statecode = 'AZ');
        insert newProspectiveVolunteerUser;
        return newProspectiveVolunteerUser;
        
    }
    
    public static User CreateActiveVolunteerUser(Id contactId){ 
        //Profile volunteerActiveProfile = [SELECT Id FROM Profile WHERE Name = 'Active Volunteer'];
        
        String activeProfileId = label.Active_Volunteer_Profile;
        
        User newActiveVolunteerUser = new User(  firstname = 'Jonathan',lastName = 'Edwards',email = 'jonathan@gmail.com',Username = 'joathanedwards@gmail.com',
                                               EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                               LanguageLocaleKey = 'en_US',created_from_portal__c = true,ProfileId = activeProfileId ,ContactId = contactId,isActive = true);
        insert newActiveVolunteerUser;
        return newActiveVolunteerUser;
    }
    
    public static Background_check__c createBackgroundCheck(Id ContactId){
        Background_check__c backCheck = new Background_check__c();
        backCheck.Date__c = system.today();
        backCheck.Volunteer__c = ContactId;
        backCheck.Date_Completed__c = System.Today().AddYears(-3);
        backCheck.Status__c = 'Test';
        insert backCheck;
        system.debug('@@@@@@@@@@@@ backCheck  ############'+backCheck );
        return backCheck;
    }
    
    public static Conflict_Of_Interest__c createCOI(Id conId){
        Conflict_Of_Interest__c newCOI = new Conflict_Of_Interest__c();
        newCOI.Volunteer_Contact__c = conId;
        newCOI.Expiration_Date__c = system.today() + 3;
        insert newCOI;
        return newCOI;
    }
    
    public static npe5__Affiliation__c CreateAffiliation(Id contactId)
    {
        
        npe5__Affiliation__c neworgAffiliation = new npe5__Affiliation__c ();
        neworgAffiliation.npe5__Contact__c  = contactId;
        neworgAffiliation.npe5__Organization__c = TestClassUtil.createVolunteerAccount().Id;
        neworgAffiliation.npe5__Primary__c = true;
        neworgAffiliation.npe5__Status__c = 'Prospective';
        neworgAffiliation.Constituent_code__c = 'Board Member';
        insert neworgAffiliation;
        return neworgAffiliation;
        
    }
    
    
    public static Volunteer_Orientation_Training__c createVolTraining(Id OrienationId, Id ClassOfferingId,Id volunteer,string status)
    {
        Volunteer_Orientation_Training__c createNewVol = new Volunteer_Orientation_Training__c();
        createNewVol.class_offering__c = ClassOfferingId;
        createNewVol.Hidden_O_T_Id__c= OrienationId;
        createNewVol.Registered_Date__c = Date.Today();
        createNewVol.Volunteer__c = volunteer;
        createNewVol.Volunteer_Attendance__c = status;
        createNewVol.Type__c = 'Training';
        createNewVol.RE_Completed_Date__c=String.ValueOf(system.today());
        insert createNewVol;
        return createNewVol;
    }
    public static Volunteer_Orientation_Training__c createVolOrientation(Id OrienationId, Id ClassOfferingId,Id volunteer,string status)
    {
        Volunteer_Orientation_Training__c createNewVol = new Volunteer_Orientation_Training__c();
        createNewVol.class_offering__c = ClassOfferingId;
        createNewVol.Hidden_O_T_Id__c = OrienationId;
        createNewVol.Registered_Date__c = Date.Today();
        createNewVol.Volunteer__c = volunteer;
        createNewVol.Volunteer_Attendance__c = status;
        createNewVol.Type__c = 'Orientation';
        insert createNewVol;
        return createNewVol;
    }
    public static Contact CreateWishChild(){
        ICD_Codes__c obj=new ICD_Codes__c();
        obj.Name='Q917';
        insert obj;
        Constant_AC  constant = new Constant_AC();
        Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();            
        Contact newWishChild = new Contact();
        newWishChild.FirstName = 'Steven';
        newWishChild.LastName = 'Smith';
        newWishChild.Parent_Guardian_Name__c ='Jonathan Edwards'; 
        newWishChild.RecordTypeId = wishChildRecordTypeId ;
        newWishChild.ICD_10_Code__c = obj.Id;
        insert newWishChild;
        return newWishChild;
    }
    public static Dynamic_Content__c ChapterDynamicContent(String chapterId) {
        
        Constant_AC constant = new Constant_AC();
        String activeRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.activeVolRT).getRecordTypeId();
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
        newChapterContent.RecordTypeId = activeRT;
        newChapterContent.Chapter_Name__c = chapterId;
        insert newChapterContent;
        return newChapterContent;
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
    
    public Static DocuSignCredentialsSetting__c insertDocusignSetting(){
        DocuSignCredentialsSetting__c newSetting = new DocuSignCredentialsSetting__c();
        newSetting.account__c = '0afd45e1-ae2d-468c-a168-b8603dae66a3';
        newSetting.IntegratorKey__c = 'ea6d625f-6c08-4b12-aa2d-554909addb30';
        newSetting.Password__c = 'metasoft100';
        newSetting.Name = 'kanagaraj@mstsolutions.com';
        insert newSetting;
        return newSetting;
    }
    
    public static Case CreateDiagnosisNewCase(){
        Constant_AC  constant = new Constant_Ac();
        Account chapterAccount = createchapterAccount();
        Lead newLead = createTestLeadRec(chapterAccount.Id);
        Contact newContact = CreateMedicalProfContact();
        Id diagnosisVerificationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.partARecordTypeId).getRecordTypeId();
        Case newDiagnosis = new Case();
        newDiagnosis.Lead__c = newLead.id;
        newDiagnosis.Local_MCA_Team__c = newContact.id;
        newDiagnosis.MAC_Email__c = 'chandrasekar@mstsolutions.com';
        newDiagnosis.RecordTypeId = diagnosisVerificationRecordTypeId;
        insert newDiagnosis;
        return newDiagnosis;
        
    }
    
    public static ICD_Codes__c createICDCode(Id conditionDescId){
        ICD_Codes__c  newICD = new ICD_Codes__c ();
        newICD.Name = 'C43.30';
        newICD.Condition_Description__c = conditionDescId;
        newICD.Group1__c = true;
        newICD.Short_Description__c = 'Malignant melanoma of unspecified part of face';
        newICD.Long_Description__c = 'Malignant melanoma of unspecified part of face';
        return newICD;
    }
    
    public static case CreateParentCase( Id wishChildId) {
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = CreateAlabamaAccount();
        newParentWish.Subject = 'Parent Wish';
        newParentWish.Interview_date__c = System.today();
        newParentWish.Wish_Type__c = 'Disney World';
        newParentWish.Start_Date__c = System.today();
        newParentWish.End_Date__c = System.today();
        newParentWish.ContactId = wishChildId;
        newParentWish.Update_Wish_Child_Form_Info__c  = false;
        newParentWish.Status = 'New';
        newParentWish.Anticipated_Start_Date__c = System.today();
        newParentWish.LiabilitySignerMapKeyPair__c = 'Vennila';
        newParentWish.Budget_Submitted_Date__c = system.today();
        newParentWish.Budget_Approved_Date__c = system.today();
        insert newParentWish;
        return newParentWish;
    }
    
    public static case CreateParentCaseWithStatus() {
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = CreateAlabamaAccount();
        newParentWish.Subject = 'Parent Wish';
        newParentWish.Interview_date__c = System.today();
        newParentWish.Status = 'Completed';
        newParentWish.Wish_Type__c = 'Disney World';
        newParentWish.Start_Date__c = System.today();
        newParentWish.End_Date__c = System.today();
        newParentWish.Referral_Date__c = Date.today();
        newParentWish.Diagnosis_Verification_Receive_Date__c = System.today();
        newParentWish.Anticipated_Start_Date__c = System.today();
        return newParentWish;
    }
    
    public static case createEligibilityReviewCase() {
        Constant_AC  constant = new Constant_Ac();    
        Id eligibilityRT = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.partARecordTypeId).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = eligibilityRT;
        newParentWish.Subject = 'Eligibility Review';
        insert newParentWish;
        return newParentWish;
    }
    
    public static case CreateParentCaseWithTravel( Id wishChildId) {
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = CreateAlabamaAccount();
        newParentWish.Subject = 'Parent Wish';
        newParentWish.Interview_date__c = System.today();
        newParentWish.Wish_Type__c = 'Disney World';
        newParentWish.ContactId = wishChildId;
        newParentWish.wish_involves_air_travel__c = 'Yes';
        newParentWish.Start_Date__c = System.today();
        insert newParentWish;
        return newParentWish;
    }
    
    public static case CreateParentCaseWithAnticipatedStartDate( Id wishChildId) {
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = CreateAlabamaAccount();
        newParentWish.Subject = 'Parent Wish';
        newParentWish.Interview_date__c = System.today();
        newParentWish.Anticipated_Start_Date__c = System.today()-23;
        newParentWish.Wish_Type__c = 'Disney World';
        newParentWish.ContactId = wishChildId;
        insert newParentWish;
        return newParentWish;
    }
    //This method used to crate parentcase without value for interview date  
    public static case CreateParentCaseWithoutInterviewDate( Id wishChildId) {
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = CreateAlabamaAccount();
        newParentWish.Subject = 'Parent Wish';
        newParentWish.Wish_Type__c = 'Disney World';
        newParentWish.ContactId = wishChildId;
        insert newParentWish;
        return newParentWish;
    }
    //This method used to crate wishdetermination case with the past created date value  
    public static case createWishDeterminationCaseWithOldDate(Id wishChildId, Id parentCaseId) {
        Constant_AC  constant = new Constant_Ac();   
        Contact newCon = CreateWishChild(); 
        Id determinationtWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        
        Case newDeterminationtWish = new Case();
        newDeterminationtWish.RecordTypeId = determinationtWishRecordTypeId;
        newDeterminationtWish.ChapterName__c = CreateAlabamaAccount();
        newDeterminationtWish.Subject = 'Parent Wish';
        newDeterminationtWish.ContactId = wishChildId;
        newDeterminationtWish.ParentId = CreateParentCaseWithoutInterviewDate(newCon.Id).Id;
        
        insert newDeterminationtWish;
        Datetime oldDate = Datetime.now().addDays(-21);
        Test.setCreatedDate(newDeterminationtWish.id, oldDate);
        
        return newDeterminationtWish;
        
    }
    
    public static case createWishDeterminationCase(Id wishChildId, Id parentCaseId) {
        Constant_AC  constant = new Constant_Ac();   
        Contact newCon = CreateWishChild(); 
        Id determinationtWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        
        Case newDeterminationtWish = new Case();
        newDeterminationtWish.RecordTypeId = determinationtWishRecordTypeId;
        newDeterminationtWish.ChapterName__c = CreateAlabamaAccount();
        newDeterminationtWish.Subject = 'Parent Wish';
        newDeterminationtWish.ContactId = wishChildId;
        newDeterminationtWish.ParentId = CreateParentCaseWithoutInterviewDate(newCon.Id).Id;
        insert newDeterminationtWish;
        return newDeterminationtWish;
        
    }
    
    public static case createWishPlanningCase(Id wishChildId, Id parentCaseId) {
        Constant_AC  constant = new Constant_Ac();    
        Id planningWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();
        
        Case newPlanningtWish = new Case();
        newPlanningtWish.RecordTypeId = planningWishRecordTypeId;
        newPlanningtWish.ChapterName__c = CreateAlabamaAccount();
        newPlanningtWish.Subject = 'Wish Planning & Anticipation';
        newPlanningtWish.ParentId = parentCaseId;
        newPlanningtWish.ContactId = wishChildId;
        insert newPlanningtWish;
        return newPlanningtWish;
        
    }
    
    public static case createWishAssistCase(Id wishChildId, Id parentCaseId) {
        Constant_AC  constant = new Constant_Ac();    
        Id assistWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishAssistRT).getRecordTypeId();
        
        Case newAssistWish = new Case();
        newAssistWish.RecordTypeId = assistWishRecordTypeId;
        newAssistWish.ChapterName__c = CreateAlabamaAccount();
        newAssistWish.Subject = 'Wish Assist';
        newAssistWish.ContactId = wishChildId;
        insert newAssistWish;
        return newAssistWish;
        
    }
    
    public static case createWishGrantCase(Id wishChildId, Id parentCaseId) {
        Constant_AC  constant = new Constant_Ac();    
        Id grantWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
        
        Case newGrantWish = new Case();
        newGrantWish.RecordTypeId = grantWishRecordTypeId;
        newGrantWish.ChapterName__c = CreateAlabamaAccount();
        newGrantWish.Subject = 'Wish Grant';
        newGrantWish.ContactId = wishChildId;
        newGrantWish.ParentId = parentCaseId;
        insert newGrantWish;
        return newGrantWish;
        
    }
    
    public static Volunteer_Opportunity__c CreateNewWishVolunteerOpportunity(Id chapterId, Id roleId, Id wishId) {
        Constant_AC  constant = new Constant_Ac();    
        Id wishVolunteerOpportunityRecordTypeId = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        
        Volunteer_Opportunity__c newWishOpportunity =  new Volunteer_Opportunity__c();
        newWishOpportunity.Chapter_Role_Opportunity__c = roleId;
        newWishOpportunity.Wish__c = wishId;
        newWishOpportunity.Chapter_Name__c = chapterId;
        newWishOpportunity.RecordTypeId = wishVolunteerOpportunityRecordTypeId;
        insert newWishOpportunity;
        return newWishOpportunity;
        
    }
    
    public static Volunteer_Opportunity__c createDuplicateNewWishVolunteerOpportunity(Id chapterId, Id roleId, Id wishId) {
        Constant_AC  constant = new Constant_Ac();    
        Id wishVolunteerOpportunityRecordTypeId = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        
        Volunteer_Opportunity__c newWishOpportunity =  new Volunteer_Opportunity__c();
        newWishOpportunity.Chapter_Role_Opportunity__c = roleId;
        //newWishOpportunity.Volunteer_Name__c = volunteerId;
        newWishOpportunity.Wish__c = wishId;
        newWishOpportunity.Chapter_Name__c = chapterId;
        newWishOpportunity.RecordTypeId = wishVolunteerOpportunityRecordTypeId;
        insert newWishOpportunity;
        return newWishOpportunity;
        
    }
    
    
    public static Non_Wish_Events__c CreateEvent(Id ChapterId) {
        Constant_AC  constant = new Constant_Ac();    
        Id EventRecTypeId = Schema.Sobjecttype.Non_Wish_Events__c.getRecordTypeInfosByName().get(constant.events).getRecordTypeId();
        Non_Wish_Events__c newEvent = new Non_Wish_Events__c();
        newEvent.Event_Name__c = 'Send Off';
        newEvent.Event_Date__c = System.Today()+5;
        newEvent.Event_Text__c = 'Sending Wish Child';
        newEvent.RecordTypeId =  EventRecTypeId;
        insert newEvent;
        return newEvent;
    }
    public static Non_Wish_Events__c CreateEventinPastDate(Id ChapterId) {
        Constant_AC  constant = new Constant_Ac();    
        Id EventRecTypeId = Schema.Sobjecttype.Non_Wish_Events__c.getRecordTypeInfosByName().get(constant.events).getRecordTypeId();
        Non_Wish_Events__c newEvent = new Non_Wish_Events__c();
        newEvent.Event_Name__c = 'Send Off';
        newEvent.Event_Date__c = System.Today()-5;
        newEvent.Event_Text__c = 'Sending Wish Child';
        newEvent.RecordTypeId =  EventRecTypeId;
        insert newEvent;
        return newEvent;
    }
    public static Non_Wish_Events__c CreateEventRec(Id chaterRoleId,Id chaterId) {
        Constant_AC  constant = new Constant_Ac();    
        Id EventRecTypeId = Schema.Sobjecttype.Non_Wish_Events__c.getRecordTypeInfosByName().get(constant.events).getRecordTypeId();
        Non_Wish_Events__c newEvent = new Non_Wish_Events__c();
        newEvent.Event_Name__c = 'Send Off';
        newEvent.Event_Date__c = System.Today()+5;
        newEvent.Event_Text__c = 'Sending Wish Child';
        newEvent.RecordTypeId =  EventRecTypeId;
        newEvent.Volunteer_Need__c = 3;
        newEvent.Chapter_Role__c = chaterRoleId;
        newEvent.Chapter__c = chaterId;
        insert newEvent;
        system.debug('_____ NONWISH EVENTID _____'+newEvent.id);
        return newEvent;
        
    }
    
    public static Volunteer_Count__c  createVolunteerCount(Id nonWishId,Id chapterRoleId,Integer count){
        Volunteer_Count__c newVolCount = new Volunteer_Count__c ();
        newVolCount.Volunteer_Needed__c = count;
        newVolCount.Chapter_Role__c = chapterRoleId;
        newVolCount .Non_Wish_Events__c = nonWishId;
        insert newVolCount; 
        system.debug('@@@@@@@ createVolunteerCount @@@@@@@'+newVolCount);
        return newVolCount;
        
    }
    
    public static Volunteer_Opportunity__c CreateNonWishVolunteerOpportunity(Id chapterId, Id roleId, Id eventId) {
        Constant_AC  constant = new Constant_Ac();    
        Id nonWishRT = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.nonWishEventRT).getRecordTypeId();
        Volunteer_Count__c newVolCount = new Volunteer_Count__c ();
        Volunteer_Opportunity__c newNonWishOpportunity =  new Volunteer_Opportunity__c();
        newNonWishOpportunity.Chapter_Role_Opportunity__c = roleId;
        newNonWishOpportunity.Non_Wish_Event__c = eventId;
        newNonWishOpportunity.Chapter_Name__c = chapterId;
        newNonWishOpportunity.RecordTypeId = nonWishRT;
        newNonWishOpportunity.Status__c = 'Pending';
        newNonWishOpportunity.HiddenVolunteer_Count_Description__c = newVolCount.id;
        insert newNonWishOpportunity;
        return newNonWishOpportunity;
        
    }
    public static Volunteer_Opportunity__c CreateNonWishDuplicateVolunteerOpportunity(Id chapterId, Id roleId, Id eventId) {
        Constant_AC  constant = new Constant_Ac();    
        Id nonWishRT = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.nonWishEventRT).getRecordTypeId();
        
        Volunteer_Opportunity__c newNonWishOpportunity =  new Volunteer_Opportunity__c();
        newNonWishOpportunity.Chapter_Role_Opportunity__c = roleId;
        newNonWishOpportunity.Non_Wish_Event__c = eventId;
        newNonWishOpportunity.Chapter_Name__c = chapterId;
        newNonWishOpportunity.RecordTypeId = nonWishRT;
        insert newNonWishOpportunity;
        return newNonWishOpportunity;
        
    }
    
    
    
    public static Dynamic_Content__c  createProspectiveDynamicContent(Id chapterId)
    {
        Constant_AC constant = new Constant_AC();
        String nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.prospectiveVolunteerRT).getRecordTypeId();
        Dynamic_Content__c  newContent = new Dynamic_Content__c();
        newContent.RecordTypeId = nationalRT;
        newContent.How_do_I_Become_a_Volunteer__c = 'Test';
        newContent.Chapter_Name__c = chapterId;
        
        insert newContent;
        return newContent;
        
    }
    
    public static List<Volunteer_Opportunity__c> NewWishVolunteerOpportunityList(Id chapterId, Id roleId, Id wishId,Integer count) {
        Constant_AC  constant = new Constant_Ac();    
        Id wishVolunteerOpportunityRecordTypeId = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        List<Volunteer_Opportunity__c> volunteerOpportunityList = new List<Volunteer_Opportunity__c>();
        for(Integer i = 0; i<= count; i++){
            Volunteer_Opportunity__c newWishOpportunity =  new Volunteer_Opportunity__c();
            newWishOpportunity.Chapter_Role_Opportunity__c = roleId;
            newWishOpportunity.Wish__c = wishId;
            newWishOpportunity.Chapter_Name__c = chapterId;
            newWishOpportunity.RecordTypeId = wishVolunteerOpportunityRecordTypeId;
            volunteerOpportunityList.add(newWishOpportunity);
            
        }
        insert volunteerOpportunityList;
        return volunteerOpportunityList;
        
    }
    
    public static List<Volunteer_Opportunity__c> NewnonWishVolunteerOpportunityList(Id chapterId, Id roleId, Id nonWishId,Integer count) {
        Constant_AC  constant = new Constant_Ac();    
        Id wishVolunteerOpportunityRecordTypeId = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        List<Volunteer_Opportunity__c> volunteerOpportunityList = new List<Volunteer_Opportunity__c>();
        for(Integer i = 1; i<= count; i++){
            Volunteer_Opportunity__c newWishOpportunity =  new Volunteer_Opportunity__c();
            newWishOpportunity.Chapter_Role_Opportunity__c = roleId;
            newWishOpportunity.Non_Wish_Event__c = nonWishId;
            newWishOpportunity.Chapter_Name__c = chapterId;
            newWishOpportunity.RecordTypeId = wishVolunteerOpportunityRecordTypeId;
            volunteerOpportunityList.add(newWishOpportunity);
           
        }
         insert volunteerOpportunityList;
        return volunteerOpportunityList;
        
    }
    
    public Static  List<Time_sheet__c> crateWishTimeSheet(List<Volunteer_Opportunity__c> WishOpportunityList){
        List<Time_sheet__c> nonwishDeterminationList = new List<Time_sheet__c>();
        for(Integer i = 0; i< WishOpportunityList.Size(); i++){
            Time_sheet__c newTimeSheet = new Time_sheet__c();
            newTimeSheet.Date__c = system.today();
            newTimeSheet.Hours_spent__c = 12.50;
            newTimeSheet.Volunteer_Opportunity__c =WishOpportunityList.get(i).Id;
            nonwishDeterminationList .add(newTimeSheet);
        }
        insert nonwishDeterminationList;
        return nonwishDeterminationList;
        
    }
    
    public Static  List<Time_sheet__c> crateNonWishTimeSheet(List<Volunteer_Opportunity__c> nonWishopportunityList,integer a ){
        List<Time_sheet__c> nonwishDeterminationList = new List<Time_sheet__c>();
        for(Integer i = 1; i <=a; i++){
            Time_sheet__c newTimeSheet = new Time_sheet__c();
            newTimeSheet.Date__c = system.today();
            newTimeSheet.Hours_spent__c = 12.50;
            newTimeSheet.Volunteer_Opportunity__c =nonWishopportunityList.get(0).Id;
            nonwishDeterminationList .add(newTimeSheet);
        }
        insert nonwishDeterminationList;
        return nonwishDeterminationList;
        
    }
    
    public static user createrSystemAdminUser(){
        UserRole newUserRole = new UserRole();
        newUserRole.Name  = 'Make A Wish Alabama';
        Insert newUserRole;
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User tuser = new User(  firstname = 'Test FirstName',
                              lastName = 'Test LastName',
                              email = 'testmawa@gmail.com',
                              Username = uniqueName + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = pf.Id,
                              isActive = true,
                              State = 'Arizona',
                              UserRoleId = newUserRole.Id
                             );
        insert tuser;
        
        return tuser;
        
    }
    
    public static user createrSystemAdminUserwithMgr(){
        UserRole newUserRole = new UserRole();
        newUserRole.Name  = 'Make A Wish Alabama';
        Insert newUserRole;
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User user1 = createrSystemAdminUser();
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User tuser = new User(  firstname = 'Test FirstName',
                              lastName = 'Test LastName',
                              email = 'testmawa@gmail.com',
                              Username = uniqueName + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = pf.Id,
                              isActive = true,
                              State = 'Arizona',
                              UserRoleId = newUserRole.Id,
                              ManagerId = user1.id
                             );
        insert tuser;
        
        return tuser;
        
    }
    
    public static npe5__Affiliation__c CreateAffiliationwithAccount(Id contactId,Id AccountId)
    {
        
        npe5__Affiliation__c neworgAffiliation = new npe5__Affiliation__c ();
        neworgAffiliation.npe5__Contact__c  = contactId;
        neworgAffiliation.npe5__Organization__c = AccountId;
        neworgAffiliation.npe5__Primary__c = true;
        neworgAffiliation.npe5__Status__c = 'Prospective';
        insert neworgAffiliation;
        return neworgAffiliation;
        
    }
    
    public static npe5__Affiliation__c CreateAffiliationwithNullStatus(Id AccountId,Id contactId)
    {
        
        npe5__Affiliation__c neworgAffiliation = new npe5__Affiliation__c ();
        neworgAffiliation.npe5__Contact__c  = contactId;
        neworgAffiliation.npe5__Organization__c = AccountId;
        neworgAffiliation.npe5__Primary__c = true;
        //neworgAffiliation.npe5__Status__c = '';
        insert neworgAffiliation;
        return neworgAffiliation;
        
    }
    
    
    
    public Static void cretateGroup(){
        Group leadalabamaGroup = new Group(Type='Regular', Name='Arizona');
        insert leadalabamaGroup ;
    }
    
    
    public static case ParentCasetoAddCaseMember( Id wishChildId) {
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = CreateAlabamaAccount();
        newParentWish.Subject = 'Parent Wish';
        newParentWish.ContactId = wishChildId;
        insert newParentWish;
        return newParentWish;
    }
    
    public static Chapter_Action_Track__c createChapterActionTrack() {
        Chapter_Action_Track__c newChapterAction = new Chapter_Action_Track__c();
        //newChapterAction.Assigned_To__c = 'Volunteer Manager';
        //newChapterAction.Case_Type_Stage__c = 'Wish Determination';
        
        newChapterAction.Task_Name__c = 'Planning';
        newChapterAction.Sort_Order__c = 1;
        newChapterAction.Wish_type__c = 'Standard';
       // newChapterAction.Recurring__c = true;
        newChapterAction.Wish_Type__c = 'Disney World';
        //newChapterAction.Recurring_Frequency__c = 1;
        newChapterAction.Months__c = 2;
        newChapterAction.Weeks__c = 2;
        return newChapterAction;
    }
    
    
    public static Chapter_Action_Track__c otherActionTrack() {
        Chapter_Action_Track__c newChapterAction = new Chapter_Action_Track__c();
        //newChapterAction.Assigned_To__c = 'Volunteer Manager';
        //newChapterAction.Case_Type_Stage__c = 'Wish Determination';
        
        newChapterAction.Task_Name__c = 'Planning';
        newChapterAction.Sort_Order__c = 1;
        newChapterAction.Wish_type__c = 'Standard';
       // newChapterAction.Recurring__c = true;
        newChapterAction.Wish_Type__c = 'Other';
       // newChapterAction.Recurring_Frequency__c = 1;
        newChapterAction.Months__c = 2;
        newChapterAction.Weeks__c = 2;
        return newChapterAction;
    }
    
    public static Group createChatterGroup() {
        Group alabamaGroup = new Group();
        alabamaGroup.Name = 'Make-A-Wish Alabama';
        alabamaGroup.DeveloperName = 'ABC';
        insert alabamaGroup;
        return  alabamaGroup;
    }
    
    public static CaseTeamMember createCaseTeamMember(Id parentId, Id wishId, Id roleId) {
        CaseTeamMember caseMember = new CaseTeamMember();
        caseMember.ParentId = parentId;
        caseMember.memberId = wishId;
        caseMember.TeamRoleId = roleId;
        insert caseMember;
        return caseMember;
    }
    
    public static CollaborationGroup createCollaborationGroup(string chapterName){
        CollaborationGroup newGroup = new CollaborationGroup();
        newGroup.name = chapterName;
        newGroup.CollaborationType = 'Public';
        insert newGroup;
        return newGroup;
        
    }
    
    public static CollaborationGroupMember createCollabrationGroupMember(Id collabrationId,Id sysUserId){
        CollaborationGroupMember newGroupMember = new CollaborationGroupMember();
        newGroupMember.CollaborationGroupId = collabrationId;
        newGroupMember.MemberId = sysUserId;
        insert newGroupMember;
        return newGroupMember;
    }
    
    public static Background_check__c createBackgroundCheckFasleRec(Id contactId){
        Background_check__c backCheck = new Background_check__c();
        backCheck.Date__c = system.today() + 3;
        backCheck.Volunteer__c = contactId;
        backCheck.Date_Completed__c = system.today() + 3;
        backCheck.Status__c = 'test';
        backCheck.current__c = false;
        insert backCheck;
        return backCheck;
    }
    
    public static Background_check__c createBackgroundCheckRec(Id contactId){
        Background_check__c backCheck = new Background_check__c();
        backCheck.Date__c = system.today() + 3;
        backCheck.Volunteer__c = contactId;
        backCheck.Status__c = 'test';
        backCheck.current__c = true;
        backCheck.Date_Completed__c = system.today() + 9;
        insert backCheck;
        return backCheck;
    }
    
    public static Background_check__c createBackgroundCheckActiveRec(Id contactId){
        Background_check__c backCheck = new Background_check__c();
        backCheck.Date__c = system.today() + 3;
        backCheck.Volunteer__c = contactId;
        backCheck.Status__c = 'test';
        backCheck.current__c = true;
        backCheck.Date_Completed__c = system.today() + 9;
        insert backCheck;
        return backCheck;
    }
    
    public static Account AlabamaAccount(){
        Constant_AC  constant = new Constant_AC();
        Id ChapterRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        
        Account newchapterAccount = new Account();
        newchapterAccount .Name = 'Make-A-Wish Alabama';
        newchapterAccount.RecordTypeId = ChapterRecordTypeId;
        insert newchapterAccount;
        return newchapterAccount;
    }
    
    public static Office__c createOffice(Id AccountId) {
        Office__c newOffice = new Office__c();
        newOffice.Chapter__c = AccountId;
        newOffice.Name = 'Make-A-Wish Alabama';
        newOffice.Office_Id__c = '014-000';
        newOffice.Office_Legal_Name__c = 'Make-A-Wish Alabama,NY, Inc.';
        newOffice.General_Email_Address__c = 'wishmail@suffolk.wish.org';
        newOffice.Website__c = 'http://suffolk.wish.org';
        newOffice.Address_1__c = '1 Comac Loop';
        newOffice.Address_2__c = 'Suite 1A1';
        newOffice.City__c = 'Ronkonkoma';
        newOffice.State__c = 'NY';
        newOffice.Zip_Code__c = '32193';
        newOffice.Country__c = 'US';
        newOffice.Phone_Number__c = '(631) 585-9474';
        
        return newOffice;
    }
    
    public static Zip_Code__c createZipcode(Id officeId){
        Zip_Code__c  newZip = new Zip_Code__c ();
        newZip.Name = '32193';
        newZip.Office__c  = officeId;
        return newZip;
    }
    
    
    public static user createChapterUser(){
        UserRole newUserRole = new UserRole();
        newUserRole.Name  = 'Make A Wish Alabama';
        Insert newUserRole;
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'Chapter Dev/Fin Staff'];
        
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User tuser = new User(  firstname = 'Test FirstName',
                              lastName = 'Test LastName',
                              email = 'test123@gmail.com',
                              Username = uniqueName + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = pf.Id,
                              isActive = true,
                              State = 'Alabama',
                              UserRoleId = newUserRole.Id);
        insert tuser;
        
        return tuser;
        
    }
    
    public static Lead createTestLeadRec(Id chapterAccountId){
        
        Lead newLead = new Lead();
        newLead.FirstName = 'moss';
        newLead.LastName = 'Smith Household';
        newLead.Phone = '9600467559';
        newLead.Email = 'testmawa@gmail.com';
        newLead.Street = 'KuttaiKarai Street';
        newLead.StateCode = 'AZ';
        newLead.city = 'Trichy';
        newLead.Postalcode = '6201717';
        newLead.CountryCode = 'US';
        newLead.DOB__c = System.today() - 1435;
        newLead.company = 'MAWA';
        newLead.Status = 'Inquiry';
       // newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        newLead.Gender__c = 'Male';
        newLead.ChapterName__c = chapterAccountId;
        newLead.Referrer_FirstName__c = 'Sudhar';
        newLead.Referrer_Last_Name__c = 'test';
        newLead.Referrer_Email__c = 'sudhar1@gmail.com';
        newLead.Referrer_Phone__c = '0600467559';
        newLead.Referrer_City__c = 'Trichy';
        newLead.Referrer_Zip__c = '6210';
        newLead.Sibling_Detail__c = 'aa | aaab | 14 bbb | bbbc | 15';
        newLead.PD_Condition_Description__c = 'Test Diagnosis';
        newLead.Parent_First_Name__c = 'MAWAFirstJune';
        newLead.Parent_Last_Name__c = 'MAWALastJune';
        newLead.Medical_Professional_First_Name__c = 'mossJune';
        newLead.Medical_Professional_Last_Name__c = 'hartJune';
        newLead.Medical_Professional_Phone__c = '9600467559';
        newLead.Medical_Professional_Email__c = 'testmawa1s@gmail.com';
        newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC';
        newLead.Treating_Medical_Professional_First_Name__c = 'SteveJune';
        newLead.Treating_Medical_Professional_Last_Name__c = 'Waughone';
        newLead.Treating_Medical_Professional_Phone__c = '9600467578';
        newLead.Treating_Medical_Professional_Email__c = 'testmawa2d@gmail.com';
        newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC';
        newLead.is_Family_Aware_of_Referral__c = 'Yes';
        newLead.Medical_Questions__c = 'Test Diagnosis';
         ICD_Codes__c obj=new ICD_Codes__c();
        obj.Name='C120';
        insert obj;
        newLead.PD_ICD_Code__c  = obj.id;
        newLead.Lung_Disease__c = 'Test1;Test2';
        newLead.Angina__c = 'Test1;Test2';
        newLead.Ventilator__c = 'Test1;Test2';
        newLead.Arrhythmia__c = 'Test1;Test2';
        newLead.Heart_Failure__c = 'Test1;Test2';
        newLead.Congenital_Heart_Disease__c = 'Test1;Test2';
        newLead.Chronic_Hepatitis__c = 'Test1;Test2';
        newLead.Convulsive_Disorders__c = 'Test1;Test2';
        newLead.Pulmonary_Hypertension__c = 'Test1;Test2';
        newLead.Strokes__c = 'Test1;Test2';
        newLead.Chronic_Heart_Failure__c = 'Test1;Test2';
        newLead.isSign__c = true;
        //newLead.Communication__c = 'Non-Verbal';
        newLead.Travel_algorithm__c = 'Test1;Test2;';
        return newLead;
        
    }
    
    public Static List<Medical_Questions__c> CreateMedicalQuestion(Id ConditionDesc) {
        Constant_AC  constant = new Constant_AC();
        Id algorithmRecordTypeId = Schema.SObjectType.Medical_questions__c.getRecordTypeInfosByName().get(constant.travelAlgmRT).getRecordTypeId();
        list<Medical_Questions__c> medicalQuestionList = new List<Medical_Questions__c>();
        Medical_Questions__c newQuestionsOne = new Medical_Questions__c();
        newQuestionsOne.Question__c = 'Is child currently or within one year of completing treatment for this condition?';
        newQuestionsOne.Picklist_values__c = 'Yes,No';
        newQuestionsOne.Data_Type__c = 'Picklist';
        newQuestionsOne.RecordTypeId = algorithmRecordTypeId;
        newQuestionsOne.Wrapper_Variable__c = 'TestWrapperone';
        newQuestionsOne.Current_Condition__c = 'Testone';
        newQuestionsOne.Recommendation_to_Chapter__c = 'None Apply';
        newQuestionsOne.Condition_Description__c = ConditionDesc;
        newQuestionsOne.Sort_Order__c = 1;
        medicalQuestionList.add(newQuestionsOne);
        Medical_Questions__c newQuestionsTwo = new Medical_Questions__c();
        newQuestionsTwo.Question__c = 'Is child currently or within one year of completing treatment for this condition?';
        newQuestionsTwo.Picklist_values__c = 'Yes,No';
        newQuestionsTwo.Epilepsy_picklist__c = 'Yes,No';
        newQuestionsTwo.Data_Type__c = 'Picklist';
        newQuestionsTwo.RecordTypeId = algorithmRecordTypeId;
        newQuestionsTwo.Wrapper_Variable__c = 'TestWrappertwo';
        newQuestionsTwo.Current_Condition__c = 'Testtwo';
        newQuestionsTwo.Recommendation_to_Chapter__c = 'None Apply';
        newQuestionsTwo.Condition_Description__c = ConditionDesc;
        newQuestionsOne.Sort_Order__c = 2;
        Medical_Questions__c newQuestionsThree = new Medical_Questions__c();
        newQuestionsThree.Question__c = 'Is child currently or within one year of completing treatment for this condition?';
        newQuestionsThree.Picklist_values__c = 'Yes,No';        
        newQuestionsThree.Data_Type__c = 'Comment box';
        newQuestionsThree.RecordTypeId = algorithmRecordTypeId;
        newQuestionsThree.Wrapper_Variable__c = 'TestWrapperthree';
        newQuestionsThree.Current_Condition__c = 'Testthree';
        newQuestionsThree.Recommendation_to_Chapter__c = 'None Apply';
        newQuestionsThree.Condition_Description__c = ConditionDesc;
        newQuestionsOne.Sort_Order__c = 3;
        medicalQuestionList.add(newQuestionsTwo);
        return medicalQuestionList;
    }
    

    
    public static contact CreateTreatingMedicalProfContact(){
        Constant_AC  constant = new Constant_AC();
        Id medicalProfessionalRecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
        Contact treatingProfContact = new Contact();
        treatingProfContact.FirstName = 'Steveone';
        treatingProfContact.LastName = 'Waughone';
        treatingProfContact.Email = 'testmawa2@gmail.com';
        treatingProfContact.Phone =  '9600467554';
        treatingProfContact.MailingStreet ='KuttaiKarai Street';
        treatingProfContact.MailingCity = 'Trichy';
        treatingProfContact.MailingStateCode = 'AZ';
        treatingProfContact.MailingPostalCode  = '6201717';
        treatingProfContact.MailingCountryCode = 'US';
        treatingProfContact.RecordTypeId = medicalProfessionalRecordTypeId;
        insert treatingProfContact;
        return treatingProfContact;
        
    }
    
    
    
    public static contact CreateMedicalProfContact(){
        Constant_AC  constant = new Constant_AC();
        Id medicalProfessionalRecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
        Contact medicalProfContact = new Contact();
        medicalProfContact .FirstName = 'mosstest';
        medicalProfContact .LastName = 'harttest';
        medicalProfContact .Email = 'testmawa1@gmail.com';
        medicalProfContact .Phone =  '9600467554';
        medicalProfContact .MailingStreet ='KuttaiKarai Street';
        medicalProfContact .MailingCity = 'Trichy';
        medicalProfContact .MailingStateCode = 'AZ';
        medicalProfContact .MailingPostalCode  = '6201717';
        medicalProfContact .MailingCountryCode = 'US';
        medicalProfContact .RecordTypeId = medicalProfessionalRecordTypeId;
        insert medicalProfContact;
        return medicalProfContact;
        
    }
    
    
    
    public static contact CreateWishFamily(){
        Constant_AC  constant = new Constant_AC();
        Id wishFamilyRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        Contact wishFamilyCon = new Contact();
        wishFamilyCon.FirstName = 'MAWAFirstName';
        wishFamilyCon.LastName = 'MAWALastName';
        wishFamilyCon.Email = 'testmawa@gmail.com';
        wishFamilyCon.Phone = '9600467559';
        wishFamilyCon.MailingStreet ='KuttaiKarai Street';
        wishFamilyCon.MailingCity = 'Trichy';
        wishFamilyCon.MailingStateCode = 'AZ';
        wishFamilyCon.MailingPostalCode  = '6201717';
        wishFamilyCon.MailingCountryCode = 'US';
        wishFamilyCon.RecordTypeId = wishFamilyRecordTypeId ;
        wishFamilyCon.IsParentGuardian__c  = 'ParentGuardian';
        wishFamilyCon.Region_Chapter__c=createchapterAccount().id;
        insert wishFamilyCon ;
        return wishFamilyCon ;
        
    }
    
    public static contact CreateWishFamilyForRelationship(){
        Constant_AC  constant = new Constant_AC();
        Id wishFamilyRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        Contact wishFamilyCon = new Contact();
        wishFamilyCon.FirstName = 'MAWAFirstName';
        wishFamilyCon.LastName = 'MAWALastName';
        wishFamilyCon.Email = 'testmawa@gmail.com';
        wishFamilyCon.Phone = '9600467559';
        wishFamilyCon.MailingStreet ='KuttaiKarai Street';
        wishFamilyCon.MailingCity = 'Trichy';
        wishFamilyCon.MailingStateCode = 'AZ';
        wishFamilyCon.MailingPostalCode  = '6201717';
        wishFamilyCon.MailingCountryCode = 'US';
        wishFamilyCon.RecordTypeId = wishFamilyRecordTypeId ;
        wishFamilyCon.Region_Chapter__c=createchapterAccount().id;
        insert wishFamilyCon ;
        return wishFamilyCon ;
        
    }
    
    /*   public static Constituent_Code__c createWishChildContituentCode(){
Constituent_Code__c  cc = new Constituent_Code__c ();
cc.Name='Wish Child';
Insert cc;
return cc;
}
public static Constituent_Code__c createWishParentGuardiansContituentCode(){
Constituent_Code__c  cc = new Constituent_Code__c ();
cc.Name='Wish Parent/Guardians';
Insert cc;
return cc;
}*/
    //public static npe5__Affiliation__c 
    public static contact CreateWishChildCon(){
        
        Constant_AC  constant = new Constant_AC();
        Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        Contact wishChildCon = new Contact();
        wishChildCon.FirstName = 'moss';
        wishChildCon.LastName = 'Smith Household';
        wishChildCon.Email = 'testmawa@gmail.com';
        wishChildCon.Phone = '9600467559';
        wishChildCon.MailingCity = 'Trichy';
        wishChildCon.MailingStateCode = 'AZ';
        wishChildCon.MailingPostalCode  = '6201717';
        wishChildCon.MailingCountryCode = 'US';
        wishChildCon.RecordTypeId = wishChildRecordTypeId;
        wishChildCon.MobilePhone = '9900220022';
        wishChildCon.Primary_Diagnosis_Condition_Description__c = 'Test';
        wishChildCon.Diagnosis__c = 'test';
        insert wishChildCon;
        return wishChildCon;
        
    }
    
    
    public static Condition_Description__c createConditionDesCription(){        
        Condition_Description__c newDesc = new Condition_Description__c();
        newDesc.Name = 'Malignant Melanoma';
        newDesc.Treatment_Subspecialty__c = 'Oncology';
        newDesc.Code_To_Use__c = 'C43.30';
        newDesc.MAW_Name__c = 'Malignant Melanoma';
        newDesc.Group1__c = true;        
        return newDesc;
    }
    
    
    public static Diagnosis_Verification__c  createDiagnosis(Id leadId){
        Diagnosis_Verification__c newDiagVf = new Diagnosis_Verification__c();
        newDiagVf.ICD_Code__c = 'CRO13';
        newDiagVf.Lead__c = leadId;
        newDiagVf.Order__c = 2;
        newDiagVf.Primary_Diagnosis__c= 'test';
        return newDiagVf ;
        
    }
    
    public static dsfs__DocuSign_Status__c createDocusignStatus(Id LeadId){
        
        dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
        dsfs.dsfs__DocuSign_Envelope_ID__c = '0F31B5A9-DB3A-4D31-8D69-9DE86F2010A8';
        dsfs.dsfs__Lead__c= LeadId;
        dsfs.isConflict__c = false;
        dsfs.dsfs__Envelope_Status__c  = 'Sent';
        Insert dsfs;
        return dsfs;
    }
    
    public static case CreatePartAWish(Id LeadId){
        case newPartACase= new Case();
        newPartACase.Origin = 'Email';
        newPartACase.Lead__c = LeadId;
        newPartACase.Status = 'Open';
        insert newPartACase;
        return newPartACase;
    }
    public static case CreatePartAWishRec(){
        Constant_AC  constant = new Constant_Ac(); 
        Id partARecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(constant.partARecordTypeId).getRecordTypeId();   
        case newPartAcase = new Case();
        newPartAcase.Origin = 'Email';
        newPartAcase.Status = 'Open';
        newPartACase.RecordTypeId = partARecordTypeId; 
        return newPartAcase;
    }
    
    public static Account MakeAWishAmericaAcc(){
        Constant_AC  constant = new Constant_AC();
        Id ChapterRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        Account newchapterAccount = new Account();
        newchapterAccount .Name = 'Make-A-Wish America';
        newchapterAccount.RecordTypeId = ChapterRecordTypeId;
        newchapterAccount.MAC_Email_del__c = 'testMAC@gmail.com';
        insert newchapterAccount;
        return newchapterAccount;
    }
    
    /* public static Lead_File__c createLeadFileRec(Id LeadId);

Lead_File__c  newLeadFile = new Lead_File__c ();
//newLeadFile.Content_Type__c = text/plain;
//newLeadFile.Description__c =
//newLeadFile.File_Name__c = 'Tes2.txt';
//newLeadFile.File_Size_in_Bytes__c = 
//newLeadFile.Is_Latest_Version__c = 
//newLeadFile.Key__c = '00Q11000008CXBp/a1Q11000001HtJ9EAK/Tes2.txt';
newLeadFile.Parent__c = LeadId;
//newLeadFile.Private__c = 
//newLeadFile.Version_Description__c = 
//newLeadFile.Version_Id__c = 
//newLeadFile.WIP__c = 
insert newLeadFile;
retrun newLeadFile;*/
    //This method is used to create reimbursement record with record type of reimbursement
    public static In_Kind_Donation_Reimbursement__c createReImbursementRecord(){
        Constant_AC newConstant =  new Constant_AC();
        Id inKindRtId = Schema.Sobjecttype.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get(newConstant.InKind).getRecordTypeId();
        Id reImbursementRtId = Schema.Sobjecttype.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
        In_Kind_Donation_Reimbursement__c newReimbursement = new In_Kind_Donation_Reimbursement__c();
        Contact newContact = CreateWishChild();
        Case newCase = ParentCasetoAddCaseMember(newContact.Id);
        newReimbursement.Wish__c = newCase.Id;
        newReimbursement.RecordTypeId = reImbursementRtId;
        insert newReimbursement;
        return newReimbursement;
        
    }
    
    //Used to create checkin task for wish child family.
    public static Task createFamilyCheckinTask(Id parentWishId) {
        Task checkinTask = new Task();
        checkinTask.ActivityDate = System.today() + 30;
        checkinTask.Subject = 'Check in with the family every 30 days';
        checkinTask.Status = 'Not Started';
        checkinTask.WhatId = parentWishId;
        insert checkinTask;
        return checkinTask;
    }
    
    //Used to create checkin task for wish child family.
    public static List<Task> CreateObtainitinerary(Id parentWishId) {
        List<Task> taskList = new List<Task>();
            for(Integer i=0; i<10; i++) {
                Task itinerary = new Task();
                itinerary.ActivityDate = Date.today().addDays(i);
                itinerary.Subject = 'Obtain itinerary and/or wish packet';
                itinerary.Status = 'Not Started';
                itinerary.WhatId = parentWishId;
                taskList.add(itinerary);
            }
        
        return taskList;
    }
    
    //Used to create Flights booked task for wish child family.
    public static Task createFightBookingTask(Id parentWishId) {
        Task checkinTask = new Task();
        checkinTask.ActivityDate = System.today() + 30;
        checkinTask.Subject = 'Flights booked';
        checkinTask.Status = 'Not Started';
        checkinTask.WhatId = parentWishId;
        insert checkinTask;
        return checkinTask;
    }
    
    //Used to create sneak Peek booked task for wish child family.
    public static Task createSneakPeek(Id parentWishId) {
        Task checkinTask = new Task();
        checkinTask.ActivityDate = System.today() + 30;
        checkinTask.Subject = 'Sneak Peek Letter';
        checkinTask.Status = 'Not Started';
        checkinTask.WhatId = parentWishId;
        insert checkinTask;
        return checkinTask;
    }
    
    
    //Used to create Budget task for wish child family.
    public static Task createBudgetTask(Id parentWishId) {
        Task checkinTask = new Task();
        checkinTask.ActivityDate = System.today() + 30;
        checkinTask.Subject = 'Budget';
        checkinTask.Status = 'Not Started';
        checkinTask.WhatId = parentWishId;
        insert checkinTask;
        return checkinTask;
    }
    //Used to create followup activities task
    public static Task createFollupActivitiesTask(Id ParentWishId, Id OwnerId) {
        Task checkinTask = new Task();
        checkinTask.ActivityDate = System.today() + 30;
        checkinTask.Subject = 'Volunteer wish follow-up activities not complete';
        checkinTask.Status = 'Not Started';
        checkinTask.WhatId = parentWishId;
        checkinTask.OwnerId = OwnerId;
        insert checkinTask;
        return checkinTask;
    }
    
    //Used to create followup activities task
    public static Task reviewPhotos(Id ParentWishId) {
        Task checkinTask = new Task();
        checkinTask.ActivityDate = System.today() + 30;
        checkinTask.Subject = 'Review photos/videos';
        checkinTask.Status = 'Not Started';
        checkinTask.WhatId = parentWishId;
        insert checkinTask;
        return checkinTask;
    }
    
    public static Task passportRequestTask(Id parentWishId) {
        Task checkinTask = new Task();
        checkinTask.ActivityDate = System.today() + 30;
        checkinTask.Subject = 'Request Passports from family';
        checkinTask.Status = 'Not Started';
        checkinTask.WhatId = parentWishId;
        insert checkinTask;
        return checkinTask;
    }
    
    //Wish Presentation Date not set
    public static Task presentationTask(Id parentWishId) {
        Task checkinTask = new Task();
        checkinTask.ActivityDate = System.today() + 30;
        checkinTask.Subject = 'wish presentation date entered';
        checkinTask.Status = 'Not Started';
        checkinTask.WhatId = parentWishId;
        insert checkinTask;
        return checkinTask;
    }
    //Wish granted Task
    public static Task wishGrantedTask(Id parentWishId) {
        Constant_AC  constant = new Constant_Ac(); 
        Id wishGrantTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
        Task checkinTask = new Task();
        checkinTask.ActivityDate = System.today() + 30;
        checkinTask.Subject = 'Granted Task';
        checkinTask.Status = 'Not Started';
        checkinTask.WhatId = parentWishId;
        checkinTask.RecordTypeId = wishGrantTaskRT;
        insert checkinTask;
        return checkinTask;
    }
    
    
    public static npe4__Relationship__c CreateRelationshipRec(Id wishChildId,Id wishFamilyId){
        npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
        newRelationShip.npe4__Contact__c = wishChildId;
        newRelationShip.npe4__RelatedContact__c = wishFamilyId;
        newRelationShip.npe4__Status__c = 'Active';
        newRelationShip.npe4__Type__c = 'Father';
        insert newRelationShip;
        return newRelationShip;
    }
    
    public static CaseTeamRole CreateCaseTeamRole(){
        CaseTeamRole  newRole = new CaseTeamRole();
        newRole.Name = 'Wish Granter';
        newRole.PreferencesVisibleInCSP = true;
        newRole.AccessLevel = 'Edit';
        insert newRole;
        return newRole;
    }     
    //This method is used to create test record with inkind record type
    public static In_Kind_Donation_Reimbursement__c CreateInkindRecord(Id ParentId){
        Constant_AC newConstant =  new Constant_AC();
        Id inkindgRecordTypeId = Schema.SObjectType.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get(newConstant.InKind).getRecordTypeId();
        In_Kind_Donation_Reimbursement__c newinkind = new In_Kind_Donation_Reimbursement__c();
        newinkind.Date_of_Gift__c = system.today()+2;
        newinkind.Gift_Type__c = 'Goods';
        newinkind.Gift_Value__c = 123456;
        newinkind.Documentation__c = 'Not available';
        newinkind.RecordTypeId = inkindgRecordTypeId;
        newinkind.Make_check_payable_to_me__c = true;
        newinkind.Wish__c = ParentId;
        insert newinkind;
        return newinkind;
        
    }
    //This method is used to create inkind  record without any attachment
    public static In_Kind_Donation_Reimbursement__c CreateInkindRecord(){
        Constant_AC newConstant =  new Constant_AC();
        Id inkindgRecordTypeId = Schema.SObjectType.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get(newConstant.InKind).getRecordTypeId();
        In_Kind_Donation_Reimbursement__c newinkindRecord = new In_Kind_Donation_Reimbursement__c();
        newinkindRecord.Date_of_Gift__c = system.today()+2;
        newinkindRecord.Gift_Type__c = 'Goods';
        newinkindRecord.Gift_Value__c = 123456;
        newinkindRecord.Documentation__c = 'Not available';
        newinkindRecord.RecordTypeId = inkindgRecordTypeId;
        newinkindRecord.Make_check_payable_to_me__c = true;
        insert newinkindRecord;
        return newinkindRecord;
        
    }
    //This method is used to create inkind  record without any attachment
    public static In_Kind_Donation_Reimbursement__c CreateInkindRecordWithOutAttachment(){
        Constant_AC newConstant =  new Constant_AC();
        Id inkindgRecordTypeId = Schema.SObjectType.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get(newConstant.InKind).getRecordTypeId();
        In_Kind_Donation_Reimbursement__c newinkindRecord = new In_Kind_Donation_Reimbursement__c();
        newinkindRecord.Date_of_Gift__c = system.today()+2;
        newinkindRecord.Gift_Type__c = 'Goods';
        newinkindRecord.Gift_Value__c = 123456;
        newinkindRecord.Documentation__c = 'Will Attach';
        newinkindRecord.RecordTypeId = inkindgRecordTypeId;
        newinkindRecord.Make_check_payable_to_me__c = true;
        insert newinkindRecord;
        return newinkindRecord;
        
    }
    //This method is used to create reimbursement record with make check payable field valu as true 
    public static In_Kind_Donation_Reimbursement__c CreateReimbursRecord(){
        Constant_AC newConstant =  new Constant_AC();
        Id reimbursementRecordTypeId = Schema.SObjectType.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get(newConstant.Reimbursement).getRecordTypeId();
        In_Kind_Donation_Reimbursement__c newReimbursement = new In_Kind_Donation_Reimbursement__c();
        newReimbursement.Documentation__c = 'Not available';
        newReimbursement.RecordTypeId = reimbursementRecordTypeId;
        newReimbursement.Make_check_payable_to_me__c = true;
        insert newReimbursement;
        return newReimbursement;
        
    } 
    //This method is used to create reimbursement record without any attachment 
    public static In_Kind_Donation_Reimbursement__c CreateReimbursRecordWithOutAttachment(){
        Constant_AC newConstant =  new Constant_AC();
        Id reimbursementRecordTypeId = Schema.SObjectType.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get(newConstant.Reimbursement).getRecordTypeId();
        In_Kind_Donation_Reimbursement__c newReimbursement = new In_Kind_Donation_Reimbursement__c();
        newReimbursement.Documentation__c = 'Will Attach';
        newReimbursement.RecordTypeId = reimbursementRecordTypeId;
        newReimbursement.Make_check_payable_to_me__c = true;
        insert newReimbursement;
        return newReimbursement;
        
    } 
    
    //This method is used to create reimbursement record with make check payable field valu as false 
    public static In_Kind_Donation_Reimbursement__c CreateReimbursRecordwithFalse(){
        Constant_AC newConstant =  new Constant_AC();
        Id reimbursementRecordTypeId = Schema.SObjectType.In_Kind_Donation_Reimbursement__c.getRecordTypeInfosByName().get(newConstant.Reimbursement).getRecordTypeId();
        In_Kind_Donation_Reimbursement__c newReimbursement = new In_Kind_Donation_Reimbursement__c();
        newReimbursement.Documentation__c = 'Not available';
        newReimbursement.RecordTypeId = reimbursementRecordTypeId;
        newReimbursement.Make_check_payable_to_me__c = false;
        insert newReimbursement;
        return newReimbursement;
        
    }  
    
    
    public static CaseTeamMember createWishTeamMember(Id parentId, Id wishId) {
        CaseTeamMember caseMember = new CaseTeamMember();
        caseMember.ParentId = parentId;
        caseMember.memberId = wishId;
        //caseMember.TeamRoleId = roleId;
        insert caseMember;
        return caseMember;
    }
    
    
    public static User createVolunteerUser(Id contactId){ 
        //Profile volunteerProspectiveProfile = [SELECT Id FROM Profile WHERE Name = 'Prospective Volunteer'];
        
        String profileId  = label.Prospective_Volunteer;
        
        User newProspectiveVolunteerUser = new User(  firstname = 'Jonathan1',created_from_portal__c = true,lastName = 'Edwards1',email = 'jonathan@gmail1.com',Username = 'joathanedwards1@gmail.com',
                                                    EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                                    LanguageLocaleKey = 'en_US',ProfileId = profileId ,ContactId = contactId,isActive = true,Statecode = 'AZ');
        insert newProspectiveVolunteerUser;
        return newProspectiveVolunteerUser;
        
    }
    
    public static Lead_File__c createLeadFileRecord(Id LeadId) {
        Lead_File__c newLeadFile = new Lead_File__c();
        newLeadFile.File_Name__c = 'MedicalSummary.txt';
        newLeadFile.Parent__c = LeadId;
        newLeadFile.Content_Type__c = 'text/plain';
        insert newLeadFile;
        return newLeadFile;
    }
    
    public static cg__CaseFile__c createCaseFileRecord(Id caseId) {
        cg__CaseFile__c newCaseFile = new cg__CaseFile__c();
        newCaseFile.cg__File_Name__c = 'MedicalSummary.txt';
        newCaseFile.cg__Case__c = caseId;
        newCaseFile.cg__Content_Type__c = 'text/plain';
        insert newCaseFile;
        return newCaseFile;
    }
    
    public static cg__contactFile__c createContactFileRecord(Id contactId) {
        cg__ContactFile__c newContactFile = new cg__ContactFile__c();
        newContactFile.cg__File_Name__c = 'MedicalSummary.txt';
        newContactFile.cg__Contact__c = contactId;
        newContactFile.cg__Content_Type__c = 'text/plain';
        insert newContactFile;
        return newContactFile;
    }
    
    
    public static dsfs__DocuSign_Status__c createDocusignStatuswithCon(Id contactId){
        dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
        dsfs.dsfs__DocuSign_Envelope_ID__c = '0F31B5A9-DB3A-4D31-8D69-9DE86F2010A8';
        dsfs.dsfs__Contact__c = contactId;
        dsfs.dsfs__Envelope_Status__c  = 'Sent';
        Insert dsfs;
        return dsfs;
    }
    
    public static Wish_Expense__c createWishExpenceRecord(Id parentCaseId) {
        Wish_Expense__c newExpence = new Wish_Expense__c();
        newExpence.Case__c = parentCaseId;
        return newExpence;
    }
    
    public Static Wish_Child_Form__c createWishChildForm(Id ParentWishId){
        Wish_Child_Form__c newChildForm = new Wish_Child_Form__c();
        newChildForm.Actor_Actress__c = 'James';
        newChildForm.Additional_Requests__c = 'test';
        newChildForm.Already_wish_granted_by_MAW_Other_Org__c = 'Yes';
        newChildForm.Any_impact_your_ability_to_join_wish__c = 'Yes';
        newChildForm.Automobile_insurance_provide_coverage__c = 'Yes';
        newChildForm.Availability_Time_Period_1__c =' Apr/2019';
        newChildForm.Hidden_Wish_Fmaily_Contact_Email__c = 'Vennila  Paramasivam - mcavennila@gmail.com, chandrasekar - chandru@mstsolutions.com';
        newChildForm.Hidden_Contact_Name__c = 'Vennila Paramasivam';
        newChildForm.Hidden_Wish_Fmaily_Contact_Name__c = 'Vennila Paramasivam, chandrasekar ';
        newChildForm.Case__c = ParentWishId;
        newChildForm.Wish_Family_Contact__c = '[{"workTelephone":"","tshirtSize":null,"residingWishMedical":null,"relId":"0035B000004R9vwQAC","relationship":"Father","mobileTelephone":"(878) 787-8787","MiddleName":"","medicalNeeds":null,"lastName":"Test12","homeTelephone":"","firstName":"Test12","Email":"kanagaraj@mstsolutions.com","dob":"2016-11-29"},{"workTelephone":"","tshirtSize":null,"residingWishMedical":null,"relId":"0035B000004R9vuQAC","relationship":"Mother","mobileTelephone":"(878) 787-8787","MiddleName":"","medicalNeeds":null,"lastName":"TestPL1","homeTelephone":"","firstName":"TestPF1","Email":"kanagu431@gmail.com","dob":"2016-11-28"}]';
        newChildForm.Participant_Contacts__c = '[{"workTelephone":null,"tshirtSize":"","residingWishMedical":"Yes","relId":null,"relationship":"Father","mobileTelephone":null,"MiddleName":"","medicalNeeds":"Yes","lastName":"Test12","homeTelephone":null,"firstName":"Test12","Email":"kanagaraj@mstsolutions.com","dob":null},{"workTelephone":null,"tshirtSize":"","residingWishMedical":"Yes","relId":null,"relationship":"Mother","mobileTelephone":null,"MiddleName":"","medicalNeeds":"Yes","lastName":"TestPL1","homeTelephone":null,"firstName":"TestPF1","Email":"kanagu431@gmail.com","dob":null}]';
        
        //newChildForm.Wish_Family_Contact__c = 'Vennila | | Paramasivam | Spouse | 8220708920 | 8220708920 | 8220708920 | mcavennila@gmail.com | 2016-11-6';
        //newChildForm.Participant_Contacts__c = 'Vennila | | karur | Child | 2016-11-01 00:00:00 | asdfasdfdsafasfdsa@12gmail.com | 12 | true | true sathis Kumar | | def | Friend | - | vi@gmail.com | | false | false';
        newChildForm.Driver_Name__c = 'Vennila karur |';
        newChildForm.Driver_Details__c = '[{"type":"Potential","state":"Alaska","licenseNum":"Tamil Nadu","expirationDate":"2017-01-04","driverName":"Test12 Test12"}]';
        newChildForm.Availability_Time_Period_2__c = 'Feb/2016';
        newChildForm.Availability_Time_Period_3__c = 'Feb/2018';
        newChildForm.Participant_Name_for_Dietary_Restriction__c = 'test';
        newChildForm.Requested_Participant_Name_forWheelchair__c = 'test';
        newChildForm.Requested_Participant_Name_for_OtherNeed__c= 'test';
        newChildForm.Requested_Participant_Name_for_Oxygen__c = 'test';
        newChildForm.Requested_Participant_Name_for_Allergies__c = 'test';
        newChildForm.Bringing_Own_Wheel_Chair__c = 'test';
        newChildForm.Name_of_wheelchair_collapsible__c = 'test;test';
        newChildForm.Pariticipant_name_havingWheelchair_Power__c = 'test;test';
        newChildForm.Medication_require_refrigeration_name__c = 'test;test';
        newChildForm.Names_for_receiving_nursing_care__c = 'test;test';
        newChildForm.Participant_Details__c  = 'Participant Participant2-joserathi@mstsolutions.com-26';
        newChildForm.Participant_Name__c = 'Participant Participant2-26';
        newChildForm.Hidden_Wish_Fmaily_Contact_Name__c= 'Parent1 Parent2,parent3 parent4';
        newChildForm.Hidden_Wish_Fmaily_Contact_Email__c = 'Parent1 Parent2-kanagu431@gmail.com,parent3 parent4-kanagaraj@mstsolutions.com';
        //Insert  newChildForm;
        return newChildForm;
        
    }
    
    public Static npe4__Relationship__c relationshipChild(Id FamilyContactId,id ChildContactid){
        npe4__Relationship__c newRelationForm = new npe4__Relationship__c();
        newRelationForm.npe4__Contact__c = ChildContactid;
        newRelationForm.npe4__RelatedContact__c = FamilyContactId;
        newRelationForm.Parent_Legal_Guardian__c = true;
        Insert  newRelationForm;
        return newRelationForm;
    }
    
    public Static npe4__Relationship__c relationshipChildWithFalse(Id FamilyContactId,id ChildContactid){
        npe4__Relationship__c newRelationForm = new npe4__Relationship__c();
        newRelationForm.npe4__Contact__c = ChildContactid;
        newRelationForm.npe4__RelatedContact__c = FamilyContactId;
        newRelationForm.Parent_Legal_Guardian__c = false;
        newRelationForm.npe4__Type__c = 'Medical Professional';
        newRelationForm.Qualifying_Medical_Professional__c = true;
        newRelationForm.npe4__Status__c = 'Active';
        Insert  newRelationForm;
        return newRelationForm;
    }
    
    public static List<WishDeterminationSubCaseTaskList__c> createDeterminationTask(Integer n){
        List<WishDeterminationSubCaseTaskList__c> wishDeterminationTaskList = new List<WishDeterminationSubCaseTaskList__c>();
        
        for(Integer i=1; i<n; i++) {
            if(i==1) {
                WishDeterminationSubCaseTaskList__c wishDetermination = new WishDeterminationSubCaseTaskList__c();
                wishDetermination.Name = 'Task'+i;
                wishDetermination.Due_Date__c = 100 + i;
                wishDetermination.Task_Subject__c = 'Contact Wish Partner & coordinate for wish visit';
                wishDeterminationTaskList.add(wishDetermination);
            } else if(i==2) {
                WishDeterminationSubCaseTaskList__c wishDetermination = new WishDeterminationSubCaseTaskList__c();
                wishDetermination.Name = 'Task'+i;
                wishDetermination.Due_Date__c = 100 + i;
                wishDetermination.Task_Subject__c = 'Contact Wish Family to Schedule Initial Visit (interview)';
                wishDeterminationTaskList.add(wishDetermination);
            } else if(i==3) {
                WishDeterminationSubCaseTaskList__c wishDetermination = new WishDeterminationSubCaseTaskList__c();
                wishDetermination.Name = 'Task'+i;
                wishDetermination.Due_Date__c = 100 + i;
                wishDetermination.Task_Subject__c = 'Enter interview date';
                wishDeterminationTaskList.add(wishDetermination);
            } else if(i==4) {
                WishDeterminationSubCaseTaskList__c wishDetermination = new WishDeterminationSubCaseTaskList__c();
                wishDetermination.Name = 'Task'+i;
                wishDetermination.Due_Date__c = 100 + i;
                wishDetermination.Task_Subject__c = 'Procure Icebreaker Gift';
                wishDeterminationTaskList.add(wishDetermination);
            } else if(i==5) {
                WishDeterminationSubCaseTaskList__c wishDetermination = new WishDeterminationSubCaseTaskList__c();
                wishDetermination.Name = 'Task'+i;
                wishDetermination.Due_Date__c = 100 + i;
                wishDetermination.Task_Subject__c = 'Conduct Interview';
                wishDeterminationTaskList.add(wishDetermination);
            } else if(i==6) {
                WishDeterminationSubCaseTaskList__c wishDetermination = new WishDeterminationSubCaseTaskList__c();
                wishDetermination.Name = 'Task'+i;
                wishDetermination.Due_Date__c = 100 + i;
                wishDetermination.Task_Subject__c = 'Complete /upload wish family packet';
                wishDeterminationTaskList.add(wishDetermination);
            } else if(i==7) {
                WishDeterminationSubCaseTaskList__c wishDetermination = new WishDeterminationSubCaseTaskList__c();
                wishDetermination.Name = 'Task'+i;
                wishDetermination.Due_Date__c = 100 + i;
                wishDetermination.Task_Subject__c = 'Submit wish family packet to chapter approval';
                wishDeterminationTaskList.add(wishDetermination);
            } else if(i==8) {
                WishDeterminationSubCaseTaskList__c wishDetermination = new WishDeterminationSubCaseTaskList__c();
                wishDetermination.Name = 'Task'+i;
                wishDetermination.Due_Date__c = 100 + i;
                wishDetermination.Task_Subject__c = 'Check in with the family every 30 days';
                wishDeterminationTaskList.add(wishDetermination);
            }
            i++;
            
        }
        insert wishDeterminationTaskList;
        return wishDeterminationTaskList;
    }
    
    public Static Case createParentCase(){
        Case newCase = new Case();
        return newCase;
    }
    
    
    public static List<contact> CreateWishFamilyList(integer count){
        Constant_AC  constant = new Constant_AC();
        Id wishFamilyRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        List<Contact> wishFamilyConList = new List<Contact>();
        for(integer I = 0;i<=count;i++){
            
            Contact wishFamilyCon = new Contact();
            wishFamilyCon.FirstName = 'MAWAFirstName';
            wishFamilyCon.LastName = 'MAWALastName'+i;
            wishFamilyCon.Email = 'kanagaraj@mstsolutions.com';
            wishFamilyCon.Phone = '9600467559';
            wishFamilyCon.MailingStreet ='KuttaiKarai Street';
            wishFamilyCon.MailingCity = 'Trichy';
            wishFamilyCon.MailingStateCode = 'AZ';
            wishFamilyCon.MailingPostalCode  = '6201717';
            wishFamilyCon.MailingCountryCode = 'US';
            if(I == 0){
                wishFamilyCon.IsParentGuardian__c = 'ParentGuardian';
                
            }
            wishFamilyCon.IsParentGuardian__c = 'Participant';
            wishFamilyCon.RecordTypeId = wishFamilyRecordTypeId ;
            wishFamilyConList.add(wishFamilyCon);
            
        }
        return wishFamilyConList;
        
    }
    
    public Static List<npe4__Relationship__c> relationshipChildList(List<Contact> FamilyContactIdList,id ChildContactid,Integer count){
        List<npe4__Relationship__c> relationShipList = new List<npe4__Relationship__c>();
        for(Integer i = 0; i<=count; i++){
            npe4__Relationship__c newRelationForm = new npe4__Relationship__c();
            newRelationForm.npe4__Contact__c = ChildContactid;
            newRelationForm.npe4__RelatedContact__c = FamilyContactIdList.get(i).Id;
            newRelationForm.Parent_Legal_Guardian__c = true;
            relationShipList.add(newRelationForm);
        }
        
        return relationShipList;
    }
    
    public static dsfs__DocuSign_Status__c createDocusignStatuswithCase(Id caseId){
        
        dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
        dsfs.dsfs__DocuSign_Envelope_ID__c = '0204C9DD-B8B3-4D7D-B9C5-F88B921E1511';
        dsfs.dsfs__Case__c = caseId;
        dsfs.isConflict__c = false;
        dsfs.dsfs__Envelope_Status__c  = 'Sent';
        dsfs.dsfs__Subject__c = 'Signature Required - Liability And Publicity Release Form';
        insert dsfs;
        return dsfs;
    }
    
    public Static dsfs__DocuSign_Recipient_Status__c CreatedsfsRec(Id dsfsStatusId){
        dsfs__DocuSign_Recipient_Status__c newdsfs = new dsfs__DocuSign_Recipient_Status__c();
        newdsfs.dsfs__Parent_Status_Record__c = dsfsStatusId;
        newdsfs.dsfs__DocuSign_Recipient_Email__c =  'testmawa@gmail.com';
        newdsfs.Name = 'vennila';
        newdsfs.dsfs__DocuSign_Recipient_Id__c = '98D97010-2A0B-4714-B9AE-494B74BD287F';
        newdsfs.dsfs__Envelope_Id__c = '0204C9DD-B8B3-4D7D-B9C5-F88B921E1511';
        
        insert newdsfs;
        return newdsfs;
        
    }
    
    //Wish concept approval task creation
    public static Task wishConceptApproval(Id parentWishId) {
        Task concept = new Task();
        concept.ActivityDate = System.today() + 30;
        concept.Subject = 'Wish concept approval';
        concept.Status = 'Not Started';
        concept.WhatId = parentWishId;
        insert concept;
        return concept;
    }
    
    //Wish presentation not set
    public static Task wishPresentationNotSet(Id parentWishId) {
        Task presentation = new Task();
        presentation.ActivityDate = System.today() + 30;
        presentation.Subject = 'Wish Presentation not set';
        presentation.Status = 'Not Started';
        presentation.WhatId = parentWishId;
        insert presentation;
        return presentation;
    }
    
    //Wish not closed
    public static Task wishNotClosed(Id parentWishId) {
        Task notClosed = new Task();
        notClosed.ActivityDate = System.today() + 30;
        notClosed.Subject = 'Wish not closed';
        notClosed.Status = 'Not Started';
        notClosed.WhatId = parentWishId;
        insert notClosed;
        return notClosed;
    }
    
    public static cg__accountFile__c createAccountFileRecord(Id accountId) {
        cg__AccountFile__c newAccountFile = new cg__AccountFile__c();
        newAccountFile.cg__File_Name__c = 'MedicalSummary.txt';
        newAccountFile.cg__Account__c = accountId;
        newAccountFile.cg__Content_Type__c = 'text/plain';
        insert newAccountFile;
        return newAccountFile;
    }
    
    public static Background_check__c createBackgroundRecord(Id volunteerId) {
        Background_check__c newBackground = new Background_check__c();
        newBackground.Volunteer__c = volunteerId;
        newBackground.Resided_in_US_for_past_7_years__c = 'Yes';
        insert newBackground;
        return newBackground;
    }
    
    public static Background_Check_File__c createBackgroundFileRecord(Id backgrounId) {
        Background_Check_File__c newBackground = new Background_Check_File__c();
        newBackground.Parent__c = backgrounId;
        newBackground.File_Name__c = 'MedicalSummary.txt';
        newBackground.Content_Type__c = 'text/plain';
        insert newBackground;
        return newBackground;
    }
    
    public static In_Kind_Donation_Reimbursement_File__c  createInkindDonaReimbFileRecord(Id ikdrId) {
        In_Kind_Donation_Reimbursement_File__c  newikdrFile = new In_Kind_Donation_Reimbursement_File__c  ();
        newikdrFile.Parent__c = ikdrId;
        newikdrFile.File_Name__c = 'MedicalSummary.txt';
        newikdrFile.Content_Type__c = 'text/plain';
        insert newikdrFile;
        return newikdrFile;
    }
    
    public static  Wish_Expense_Type__c CreateWishExpenseTypeRecord(){
        
        Wish_Expense_Type__c  currType= new  Wish_Expense_Type__c();
        currType.Name='Airfare';
        return currType;
    }  
    
    public static Wish_Expense_Transaction_Code__c CreateWishExpenseTransactionCodeRecord( ID wishtypeId){
        
        Wish_Expense_Transaction_Code__c  currtransactionCode= new Wish_Expense_Transaction_Code__c();
        currtransactionCode.Name='Airfare Other';
        currtransactionCode.Wish_Expense_Type__c=wishtypeId;
        currtransactionCode.Is_Active__c=true;
        return currtransactionCode;
    } 
    
    public static dsfs__DocuSign_Status__c CreateDocusignRecord(){
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
        dsfs__DocuSign_Status__c newDocusign = new dsfs__DocuSign_Status__c();
        newDocusign.dsfs__Lead__c = newLead.Id;
        newDocusign.dsfs__Envelope_Status__c = 'Completed';
        insert newDocusign;
        return newDocusign;
    }
    
    public static Attachment CreateAttachmentRecord(){
        dsfs__DocuSign_Status__c newDocusign = CreateDocusignRecord();
        Attachment newAttachment =  new Attachment();
        newAttachment.ParentId = newDocusign.id;
        newAttachment.Name = 'Attachment1';
        newAttachment.Body = blob.valueOf('Hi Welcome to body text');
        insert newAttachment;
        return newAttachment;
        
    }
    
    public static Attachment CreateAttachmentRecordWishChild(Id ParentId){
        Attachment newAttachment =  new Attachment();
        newAttachment.ParentId = ParentId;
        newAttachment.Name = 'Attachment1';
        newAttachment.Body = blob.valueOf('Hi Welcome to body text');
        insert newAttachment;
        return newAttachment;
        
    }
    public static Volunteer_Opportunity__c NewnonWishVolunteerOpportunity(Id chapterId,Id contactId) {
        Constant_AC  constant = new Constant_Ac();    
        Id wishVolunteerOpportunityRecordTypeId = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        Volunteer_Opportunity__c newWishOpportunity =  new Volunteer_Opportunity__c();
        newWishOpportunity.Chapter_Name__c = chapterId;
        newWishOpportunity.RecordTypeId = wishVolunteerOpportunityRecordTypeId;
        newWishOpportunity.Volunteer_Name__c=contactId;
        insert newWishOpportunity;
        return newWishOpportunity;
    }
    
    public static Volunteer_Opportunity__c  newVolunteerOpportunityWithCaseandVolunteer(id wishId , id VolunteerId){
        Constant_AC  constant = new Constant_Ac();    
        Id wishVolunteerOpportunityRecordTypeId = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        Volunteer_Opportunity__c newWishOpportunity =  new Volunteer_Opportunity__c();
        newWishOpportunity.Wish__C=wishId;
        newWishOpportunity.RecordTypeId = wishVolunteerOpportunityRecordTypeId;
        newWishOpportunity.Volunteer_Name__c=VolunteerId;
        
        insert newWishOpportunity;
        return newWishOpportunity;
    }
    
    public static Regions__c createRegion(Id AccountId)
    {
        Regions__c newRegion = new Regions__c();
        newRegion.Name = 'Alabama';
        newRegion.Chapter_Name__c = AccountId;
        return newRegion;
    }
  
    public static npe4__Relationship__c CreateMedicalProfessionalRelationshipRec(Id wishChildId,Id medicalProfessionalId)
    {
        npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
        newRelationShip.npe4__Contact__c = wishChildId;
        newRelationShip.npe4__RelatedContact__c = medicalProfessionalId;
        newRelationShip.npe4__Status__c = 'Active';
        newRelationShip.npe4__Type__c = 'Medical Professional';
        newRelationShip.Qualifying_Medical_Professional__c =TRUE; 
        insert newRelationShip;
        return newRelationShip;
    }
    
    public static Chapter_Vs_Role__c createAlabamaChapter(){
        Chapter_Vs_Role__c createRec = new Chapter_Vs_Role__c();
          createRec.Chapter_Name__c = 'Make-A-Wish Alabama';
          createRec.Role_Name__c = 'Alabama - Chapter';
          createRec.Name='Make-A-Wish Alabama';
          return createRec;
    }
    public static Chapter_Vs_Role__c createArizonaChapter(){
        Chapter_Vs_Role__c createRec = new Chapter_Vs_Role__c();
          createRec.Chapter_Name__c = 'Make-A-Wish Alabama';
          createRec.Role_Name__c = 'Alabama - Chapter';
          createRec.Name='Make-A-Wish Alabama';
          return createRec;
    }
    
    
      public static Contact CreateWishChildwithAcc(Id accId){
        Constant_AC  constant = new Constant_AC();
        ICD_Codes__c obj=new ICD_Codes__c();
        obj.Name='Q917';
        insert obj;
        Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();            
        Contact newWishChild = new Contact();
        newWishChild.FirstName = 'Steven';
        newWishChild.LastName = 'Smith';
        newWishChild.Parent_Guardian_Name__c ='Jonathan Edwards'; 
        newWishChild.RecordTypeId = wishChildRecordTypeId ;
        newWishChild.Diagnosis__c = 'Test';
        newWishChild.ICD_10_Code__c = obj.id;
        newWishChild.AccountId = accId;
        insert newWishChild;
        return newWishChild;
    }
    
    public static void checkGovernorLimits () {
        System.assert(Limits.getDMLRows() * 100 / Limits.getLimitDMLRows() < 50);        
        System.assert(Limits.getDMLStatements() * 100 / Limits.getLimitDMLStatements() < 50);
        System.assert(Limits.getAggregateQueries() * 100 / Limits.getLimitAggregateQueries() < 50);
        System.assert(Limits.getQueries() * 100 / Limits.getLimitQueries() < 70);
        System.assert(Limits.getQueryRows() * 100 / Limits.getLimitQueryRows() < 50); 
    }
    
    
    public static contact CreateTreatingMedicalProfContactforMerge(){
        Constant_AC  constant = new Constant_AC();
        Id medicalProfessionalRecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
        Contact treatingProfContact = new Contact();
        treatingProfContact.FirstName = 'Steveone';
        treatingProfContact.LastName = 'Waughone';
        treatingProfContact.Email = 'testmawa2@gmail.com';
        treatingProfContact.Phone =  '9600467554';
        treatingProfContact.MailingStreet ='KuttaiKarai Street';
        treatingProfContact.MailingCity = 'Trichy';
        treatingProfContact.MailingStateCode = 'AZ';
        treatingProfContact.MailingPostalCode  = '6201717';
        treatingProfContact.MailingCountryCode = 'US';
        treatingProfContact.RecordTypeId = medicalProfessionalRecordTypeId;
        
        return treatingProfContact;
        
    }
    
    
    public static Lead createTestLeadRecwithDupe(Id chapterAccountId){
        
        Lead newLead = new Lead();
        newLead.FirstName = 'moss';
        newLead.LastName = 'Smith Household';
        newLead.Phone = '9600467559';
        newLead.Email = 'testmawa@gmail.com';
        newLead.Street = 'KuttaiKarai Street';
        newLead.StateCode = 'AZ';
        newLead.city = 'Trichy';
        newLead.Postalcode = '6201717';
        newLead.CountryCode = 'US';
        newLead.DOB__c = System.today() - 1435;
        newLead.company = 'MAWA';
        newLead.Status = 'Inquiry';
       // newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        newLead.Gender__c = 'Male';
        newLead.ChapterName__c = chapterAccountId;
        newLead.Referrer_FirstName__c = 'SteveJune';
        newLead.Referrer_Last_Name__c = 'Waughone';
        newLead.Referrer_Email__c = 'testmawa2d@gmail.com';
        newLead.Referrer_Phone__c =  '9600467578';
        newLead.Referrer_City__c = 'Trichy';
        newLead.Referrer_Zip__c = '6210';
        newLead.Sibling_Detail__c = 'aa | aaab | 14 bbb | bbbc | 15';
        newLead.PD_Condition_Description__c = 'Test Diagnosis';
        newLead.Parent_First_Name__c = 'MAWAFirstJune';
        newLead.Parent_Last_Name__c = 'MAWALastJune';
        newLead.Medical_Professional_First_Name__c = 'SteveJune';
        newLead.Medical_Professional_Last_Name__c = 'Waughone';
        newLead.Medical_Professional_Phone__c = '9600467578';
        newLead.Medical_Professional_Email__c = 'testmawa2d@gmail.com';
        newLead.Hospital_Treatment_Facility__c = 'Steve Smith AC';
        newLead.Treating_Medical_Professional_First_Name__c = 'SteveJune';
        newLead.Treating_Medical_Professional_Last_Name__c = 'Waughone';
        newLead.Treating_Medical_Professional_Phone__c = '9600467578';
        newLead.Treating_Medical_Professional_Email__c = 'testmawa2d@gmail.com';
        newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC';
        newLead.Best_Contact_for_Physician_First_Name__c = 'SteveJune';
        newLead.Best_Contact_for_Physician_Last_Name__c ='Waughone';
        newLead.Best_contact_for_Physician_Email__c = 'testmawa2d@gmail.com';
        newLead.is_Family_Aware_of_Referral__c = 'Yes';
        newLead.Medical_Questions__c = 'Test Diagnosis';
        //newLead.PD_ICD_Code__c  = 'C12.0';
        newLead.Lung_Disease__c = 'Test1;Test2';
        newLead.Angina__c = 'Test1;Test2';
        newLead.Ventilator__c = 'Test1;Test2';
        newLead.Arrhythmia__c = 'Test1;Test2';
        newLead.Heart_Failure__c = 'Test1;Test2';
        newLead.Congenital_Heart_Disease__c = 'Test1;Test2';
        newLead.Chronic_Hepatitis__c = 'Test1;Test2';
        newLead.Convulsive_Disorders__c = 'Test1;Test2';
        newLead.Pulmonary_Hypertension__c = 'Test1;Test2';
        newLead.Strokes__c = 'Test1;Test2';
        newLead.Chronic_Heart_Failure__c = 'Test1;Test2';
        newLead.isSign__c = true;
       
        //newLead.Communication__c = 'Non-Verbal';
        newLead.Travel_algorithm__c = 'Test1;Test2;';
        return newLead;
        
    }
    
    public static case CreateParentCaseWithClosedStatus( Id wishChildId) {
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = CreateAlabamaAccount();
        newParentWish.Subject = 'Parent Wish';
        newParentWish.Interview_date__c = System.today();
        newParentWish.Wish_Type__c = 'Disney World';
        newParentWish.Start_Date__c = System.today();
        newParentWish.End_Date__c = System.today();
        newParentWish.ContactId = wishChildId;
        newParentWish.Update_Wish_Child_Form_Info__c  = false;
        newParentWish.Status = 'Closed';
        newParentWish.Anticipated_Start_Date__c = System.today();
        newParentWish.LiabilitySignerMapKeyPair__c = 'Vennila';
        newParentWish.Budget_Submitted_Date__c = system.today();
        newParentWish.Budget_Approved_Date__c = system.today();
        insert newParentWish;
        return newParentWish;
    }
    
     public static Lead createAdditionalParentLead(Id chapterAccountId){
        
         Lead newLead = new Lead();
        newLead.FirstName = 'moss';
        newLead.LastName = 'Smith Household';
        newLead.Phone = '9600467559';
        newLead.Email = 'testmawa@gmail.com';
        newLead.Street = 'KuttaiKarai Street';
        newLead.StateCode = 'AZ';
        newLead.city = 'Trichy';
        newLead.Postalcode = '6201717';
        newLead.CountryCode = 'US';
        newLead.DOB__c = System.today() - 1435;
        newLead.company = 'MAWA';
        newLead.Status = 'Inquiry';
       // newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        newLead.Gender__c = 'Male';
        newLead.ChapterName__c = chapterAccountId;
        newLead.Referrer_FirstName__c = 'SteveJune';
        newLead.Referrer_Last_Name__c = 'Waughone';
        newLead.Referrer_Email__c = 'testmawa2d@gmail.com';
        newLead.Referrer_Phone__c =  '9600467578';
        newLead.Referrer_City__c = 'Trichy';
        newLead.Referrer_Zip__c = '6210';
        newLead.Sibling_Detail__c = 'aa | aaab | 14 bbb | bbbc | 15';
        newLead.PD_Condition_Description__c = 'Test Diagnosis';
        newLead.Parent_First_Name__c = 'MAWAFirstJune';
        newLead.Parent_Last_Name__c = 'MAWALastJune';
        newLead.Medical_Professional_First_Name__c = 'SteveJune';
        newLead.Medical_Professional_Last_Name__c = 'Waughone';
        newLead.Medical_Professional_Phone__c = '9600467578';
        newLead.Medical_Professional_Email__c = 'testmawa2d@gmail.com';
        newLead.Hospital_Treatment_Facility__c = 'Steve Smith AC';
        newLead.Treating_Medical_Professional_First_Name__c = 'SteveJune';
        newLead.Treating_Medical_Professional_Last_Name__c = 'Waughone';
        newLead.Treating_Medical_Professional_Phone__c = '9600467578';
        newLead.Treating_Medical_Professional_Email__c = 'testmawa2d@gmail.com';
        newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC';
        newLead.Best_Contact_for_Physician_First_Name__c = 'SteveJune';
        newLead.Best_Contact_for_Physician_Last_Name__c ='Waughone';
        newLead.Best_contact_for_Physician_Email__c = 'testmawa2d@gmail.com';
        newLead.is_Family_Aware_of_Referral__c = 'Yes';
        newLead.Medical_Questions__c = 'Test Diagnosis';
        
        newLead.Lung_Disease__c = 'Test1;Test2';
        newLead.Angina__c = 'Test1;Test2';
        newLead.Ventilator__c = 'Test1;Test2';
        newLead.Arrhythmia__c = 'Test1;Test2';
        newLead.Heart_Failure__c = 'Test1;Test2';
        newLead.Congenital_Heart_Disease__c = 'Test1;Test2';
        newLead.Chronic_Hepatitis__c = 'Test1;Test2';
        newLead.Convulsive_Disorders__c = 'Test1;Test2';
        newLead.Pulmonary_Hypertension__c = 'Test1;Test2';
        newLead.Strokes__c = 'Test1;Test2';
        newLead.Chronic_Heart_Failure__c = 'Test1;Test2';
        newLead.isSign__c = true;
        newLead.Travel_algorithm__c = 'Test1;Test2;';
        newLead.Additional_Parent_First_Name__c = 'MAWAFirstJune';
        newLead.Additional_Parent_Last_Name__c = 'MAWALastJune';
        newLead.Additional_Parent_Phone__c =  '9600467559';
        newLead.Additional_Parent_Email__c = 'testmawa@gmail.com';
        newLead.Additional_Parent_City__c = 'Trichy';
        newLead.Additional_Parent_Postal_Code__c = '6201717';
        return newLead;
    }
    
    
    public static Lead createSameMedicalLead(Id chapterAccountId){
        
         Lead newLead = new Lead();
        newLead.FirstName = 'moss';
        newLead.LastName = 'Smith Household';
        newLead.Phone = '9600467559';
        newLead.Email = 'testmawa@gmail.com';
        newLead.Street = 'KuttaiKarai Street';
        newLead.StateCode = 'AZ';
        newLead.city = 'Trichy';
        newLead.Postalcode = '6201717';
        newLead.CountryCode = 'US';
        newLead.DOB__c = System.today() - 1435;
        newLead.company = 'MAWA';
        newLead.Status = 'Inquiry';
       // newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        newLead.Gender__c = 'Male';
        newLead.ChapterName__c = chapterAccountId;
        newLead.Referrer_FirstName__c = 'SteveJuneone';
        newLead.Referrer_Last_Name__c = 'Waugh';
        newLead.Referrer_Email__c = 'testmawa21d@gmail.com';
        newLead.Referrer_Phone__c =  '9600467579';
        newLead.Referrer_City__c = 'Trichy';
        newLead.Referrer_Zip__c = '6210';
        newLead.Sibling_Detail__c = 'aa | aaab | 14 bbb | bbbc | 15';
        newLead.PD_Condition_Description__c = 'Test Diagnosis';
        newLead.Parent_First_Name__c = 'MAWAFirstJune';
        newLead.Parent_Last_Name__c = 'MAWALastJune';
        newLead.Medical_Professional_First_Name__c = 'SteveJuneone';
        newLead.Medical_Professional_Last_Name__c = 'Waugh';
        newLead.Medical_Professional_Phone__c = '9600467579';
        newLead.Medical_Professional_Email__c = 'testmawa21d@gmail.com';
        newLead.Hospital_Treatment_Facility__c = 'Steve Smith AC';
        newLead.Treating_Medical_Professional_First_Name__c = 'SteveJune';
        newLead.Treating_Medical_Professional_Last_Name__c = 'Waughone';
        newLead.Treating_Medical_Professional_Phone__c = '9600467578';
        newLead.Treating_Medical_Professional_Email__c = 'testmawa2d@gmail.com';
        newLead.Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC';
        newLead.Best_Contact_for_Physician_First_Name__c = 'SteveJune';
        newLead.Best_Contact_for_Physician_Last_Name__c ='Waughone';
        newLead.Best_contact_for_Physician_Email__c = 'testmawa2d@gmail.com';
        newLead.is_Family_Aware_of_Referral__c = 'Yes';
        newLead.Medical_Questions__c = 'Test Diagnosis';
        
        newLead.Lung_Disease__c = 'Test1;Test2';
        newLead.Angina__c = 'Test1;Test2';
        newLead.Ventilator__c = 'Test1;Test2';
        newLead.Arrhythmia__c = 'Test1;Test2';
        newLead.Heart_Failure__c = 'Test1;Test2';
        newLead.Congenital_Heart_Disease__c = 'Test1;Test2';
        newLead.Chronic_Hepatitis__c = 'Test1;Test2';
        newLead.Convulsive_Disorders__c = 'Test1;Test2';
        newLead.Pulmonary_Hypertension__c = 'Test1;Test2';
        newLead.Strokes__c = 'Test1;Test2';
        newLead.Chronic_Heart_Failure__c = 'Test1;Test2';
        newLead.isSign__c = true;
        newLead.Travel_algorithm__c = 'Test1;Test2;';
        newLead.Additional_Parent_First_Name__c = 'MAWAFirstJune';
        newLead.Additional_Parent_Last_Name__c = 'MAWALastJune';
        newLead.Additional_Parent_Phone__c =  '9600467559';
        newLead.Additional_Parent_Email__c = 'testmawa@gmail.com';
        newLead.Additional_Parent_City__c = 'Trichy';
        newLead.Additional_Parent_Postal_Code__c = '6201717';
        return newLead;
    }
    
    public static User createAdminUser(){ 
        
        
        Profile volunteerSystemAdministrator = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User newPvolunteerSystemAdministratorUser = new User(  firstname = 'Yohan',lastName = 'Blake',email = 'blake@yohan.com',Username = 'yohanblake@100m.com',
                                                             EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                                             LanguageLocaleKey = 'en_US',ProfileId = volunteerSystemAdministrator.Id,isActive = true,Statecode = 'AZ');
        insert newPvolunteerSystemAdministratorUser ;
        return newPvolunteerSystemAdministratorUser ;
        
    }
}