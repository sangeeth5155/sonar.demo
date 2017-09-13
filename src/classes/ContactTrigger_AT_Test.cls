/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : ContactTrigger_AT_Test is used to increase the code coverage for contact_AT trigger and contactTriggerHandler.
*****************************************************************************************************/

@isTest
public class ContactTrigger_AT_Test{
    /*This setup method is used to create a chapter user and systemAdmin users*/
    
    @testSetup static void setup(){   
        OrientationandTrainingUtil.createChapterUser();
        OrientationandTrainingUtil.createrSystemAdminUser();
    }
    /*This setup method is used to create a community user records*/
    
    public testmethod static void createCommunityUser(){  
        User chapterUser = [SELECT Id,UserName,ProfileId,Profile.Name,Email FROM User WHERE Email  =: 'test123@gmail.com'];
        System.runAs(chapterUser){
            Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            try{
                OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);}
            catch(exception ex){
            }
        }
    }
    
    
    /*This method is used to update the application status to complete*/
    
    public testmethod static void UpdateApplicationStatustoComplete(){ 
        Constant_AC  constant = new Constant_AC(); 
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        user systemAdmin = [select id from user where id =:userinfo.getuserid()];
        system.runAs(systemAdmin){
            Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
            OrientationandTrainingUtil.CreateAffiliation(VolunteerContact.Id);
            Contact dbcontact = [SELECT Id,FirstName,LastName,AccountId,Birth_Month__c ,Birth_Day__c,is_Application__c, Birth_Year__c,RecordTypeId FROM Contact Where RecordTypeId =: volunteerRecordTypeId Limit 1];
            dbcontact .Birth_Day__c = '21';
            dbcontact .Birth_Month__c = 'March';
            dbcontact.RecordTypeId=volunteerRecordTypeId;
            dbcontact .Birth_Year__c = '1986';
            dbcontact .is_Application__c =  'Complete';
            update dbcontact;
        }
    }
    
    /*This method is used to update the application status to reject*/
    
    public testmethod static void UpdateApplicationStatustoReject(){ 
        Constant_AC  constant = new Constant_AC(); 
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        user systemAdmin = [select id from user where id =:userinfo.getuserid()];
        system.runAs(systemAdmin){
            Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
            OrientationandTrainingUtil.CreateAffiliationwithAccount(VolunteerContact.Id,chapterAccount.id);
            Role__c WishRole = OrientationandTrainingUtil.createRole();
            Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,WishRole.Id);
            Contact dbcontact = [SELECT Id,FirstName,LastName,AccountId,Birth_Month__c ,Birth_Day__c,is_Application__c, Birth_Year__c,RecordTypeId FROM Contact Where RecordTypeId =: volunteerRecordTypeId Limit 1];
            dbcontact .Birth_Day__c = '21';
            dbcontact .Birth_Month__c = 'March';
            dbcontact .Birth_Year__c = '1986';
            dbcontact .is_Application__c =  'Rejected';
            dbcontact.Volunteer_Role__c = 'Wish Granter;Airport Greeter';
            update dbcontact;
        }
    }
    
    /*This method is used to create a task record when zipcode is update*/
    
    public testmethod static void CreateZipcodeUpdateTask(){
        user systemAdmin = [select id from user where id =:userinfo.getuserid()];
        system.runAs(systemAdmin){
            Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Account chapterAccount1 = OrientationandTrainingUtil.createVolunteerAccount();
            Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
            Office__c  officeRec = OrientationandTrainingUtil.createOffice(chapterAccount1.Id);
            officeRec.External_Id__c = 'R123';
            insert officeRec;
            Zip_Code__c  zipcodeRec = OrientationandTrainingUtil.createZipcode(officeRec.Id);
            zipcodeRec.Name = '32401';
            zipCodeRec.office__c = officeRec.id;
            zipCodeRec.External_Id__c = 'R123';
            insert zipCodeRec;
            OrientationandTrainingUtil.CreateAffiliationwithAccount(VolunteerContact.Id,chapterAccount.id);
            contact dbContact = [SELECT Id,MailingPostalCode  FROM Contact WHERE Id =:VolunteerContact.Id];
            dbContact.MailingPostalCode  = '32401';
            update dbContact;
        }
    }
    
    /* This Method is used to update the Volunteer LastName,FirstName,Email and Mobile Number */
    public testmethod static void UpdateVolunteerDetails(){ 
        Constant_AC  constant = new Constant_AC(); 
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        user systemAdmin = [select id from user where id =:userinfo.getuserid()];
        system.runAs(systemAdmin){
            
            Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
            User volunteerUser=OrientationandTrainingUtil.createVolunteerUser(VolunteerContact.Id);
            OrientationandTrainingUtil.CreateAffiliationwithAccount(VolunteerContact.Id,chapterAccount.id);
            Role__c WishRole = OrientationandTrainingUtil.createRole();
            Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,WishRole.Id);
            Contact dbcontact = [SELECT Id,FirstName,LastName,MobilePhone,Email,RecordTypeId FROM Contact Where RecordTypeId =: volunteerRecordTypeId Limit 1];
            dbcontact.LastName = 'moss';
            dbcontact.FirstName = 'Smith';
            dbcontact.MobilePhone='9003910427';
            dbcontact.Email ='Smith@gmail.com';
            dbcontact.Same_as_Household_Address__c = True;
            update dbcontact;
            
            
        }
        
    }
    
    testmethod static void CreateWishChildContact()
    {
        Constant_ac constant = new Constant_ac();
        Id wichChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        
        Account newAcc = new Account();
        newAcc.Name = 'Test';
        insert newAcc; 
        
        Account chapterAcc=OrientationandTrainingUtil.createchapterAccount();
         ICD_Codes__c  newICD = new ICD_Codes__c ();
        newICD.Name = 'c00';
        insert newICD;
        Contact newCon = new Contact();
        newCon.LastName = 'Test';
        newCon.ICD_10_Code__c = newICD.Id;
        newCon.Diagnosis__c  = 'Malignant Neoplasm';
        //newCon.Short_Description__c  = 'Test';
        newCon.Non_Verbal__c  = 'No';
        newCon.accountid = newAcc.id;
        newCon.Region_Chapter__c=chapterAcc.Id;
        newCon.recordTypeId = wichChildRecordTypeId;
        insert newCon;
    }
    
    testmethod static void CreateMedicalContact()
    {
        Constant_ac constant = new Constant_ac();
        Id wichChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        Id MedicalProfContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId(); 
        Account newAcc = new Account();
        newAcc.Name = 'Test';
        insert newAcc; 
        ICD_Codes__c  newICD = new ICD_Codes__c ();
        newICD.Name = 'c00';
        insert newICD;
        Contact newCon = new Contact();
        newCon.LastName = 'Test';
        newCon.ICD_10_Code__c = newICD.Id;
        newCon.Diagnosis__c  = 'Malignant Neoplasm';
        //newCon.Short_Description__c  = 'Test';
        newCon.Non_Verbal__c  = 'No';
        newCon.accountid = newAcc.id;
        newCon.recordTypeId = wichChildRecordTypeId;
        insert newCon;
        
        Contact newMedCon = new Contact();
        newMedCon.LastName = 'Test';
        // newMedCon.accountid = newAcc.id;
        newMedCon.recordTypeId = MedicalProfContactRecordTypeId;
        insert newMedCon;
        
        npe4__Relationship__c newRel = new npe4__Relationship__c();
        newRel.npe4__RelatedContact__c = newMedCon.id;
        newRel.npe4__Contact__c =  newCon.id;
        newRel.npe4__Status__c = 'Active';
        newRel.Qualifying_Medical_Professional__c = true;
        insert newRel;
        
        newMedCon.LastName = 'Test1';
        newMedCon.Email = 'test@gmail.com';
        update newMedCon;
        
    }
    
    public testmethod static void RecallWishFamilyContactInfo(){
        
        
        Contact childCon = OrientationandTrainingUtil.CreateWishChildCon();
        Contact childFamily = OrientationandTrainingUtil.CreateWishFamily();
        npe4__Relationship__c  npcr = OrientationandTrainingUtil.CreateRelationshipRec(childCon.Id,childFamily.Id);
        
        Contact updateConFamily = new Contact();
        updateConFamily.Hidden_First_Name__c  = 'Chandra';
        updateConFamily.Hidden_Last_Name__c  = 'Sekar';
        updateConFamily.Hidden_Phone__c = '8056913402';
        updateConFamily.Hidden_Email__c  = 'testmst@gmail.com';
        updateConFamily.Hidden_Street__c = 'North Street';
        updateConFamily.Hidden_city__c = 'Chennai';
        updateConFamily.Hidden_State__c = 'Alabama';
        updateConFamily.Hidden_Country__c =  'United States';
        updateConFamily.Hidden_Zip_Code__c = '621010';
        updateConFamily.IsContactInfoUpdated__c = true;
        updateConFamily.Id = childFamily.Id;
        update updateConFamily;
        
        
        Contact updateCon = new Contact();
        updateCon.Email = 'kanagu431@gmail.com';
        updateCon.IsRejected_Contact_Info__c = true;
        updateCon.Id = childCon.Id;
        update updateCon;
    }
    public testmethod static void updatewishChildContactInfo(){
        
        Contact childCon = OrientationandTrainingUtil.CreateWishChildCon();
        
        Contact updateCon = new Contact();
        updateCon.Hidden_First_Name__c  = 'Chandra';
        updateCon.Hidden_Last_Name__c  = 'Sekar';
        updateCon.Hidden_Phone__c = '8056913402';
        updateCon.Hidden_Email__c  = 'testmst@gmail.com';
        updateCon.Hidden_Street__c = 'North Street';
        updateCon.Hidden_city__c = 'Chennai';
        updateCon.Hidden_State__c = 'Alabama';
        updateCon.Hidden_Country__c =  'United States';
        updateCon.Hidden_Zip_Code__c = '621010';
        updateCon.IsContactInfoUpdated__c = true;
        updateCon.Id = childCon.Id;
        update updateCon;
    }
    
    /*This method is used to update the application status to submit*/
    
    public testmethod static void UpdateApplicationStatustoSubmit(){ 
        Constant_AC  constant = new Constant_AC(); 
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        user systemAdmin = [select id from user where id =:userinfo.getuserid()];
        system.runAs(systemAdmin){
            Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
            OrientationandTrainingUtil.CreateAffiliation(VolunteerContact.Id);
            Contact dbcontact = [SELECT Id,FirstName,LastName,AccountId,Birth_Month__c ,Birth_Day__c,is_Application__c, Birth_Year__c,RecordTypeId FROM Contact Where RecordTypeId =: volunteerRecordTypeId Limit 1];
            dbcontact .Birth_Day__c = '21';
            dbcontact .Birth_Month__c = 'March';
            dbcontact .Birth_Year__c = '1986';
            dbcontact .is_Application__c = 'Submit';
            update dbcontact;
        }
    }
    public testmethod static void updateMedicalProfContact(){
        Constant_AC  constant = new Constant_AC(); 
        Id medicalProfessionalRecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
        Contact medicalProfessionalcon=OrientationandTrainingUtil.createMedicalProfContact();
        Contact childCon = OrientationandTrainingUtil.CreateWishChildCon();
        npe4__Relationship__c relationship=OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRec(medicalProfessionalcon.Id,childCon.Id);
        Contact UpdateMedicalProfessional=[SELECT id,FirstName FROM Contact WHERE RecordTypeId =:medicalProfessionalRecordTypeId Limit 1];
        UpdateMedicalProfessional.FirstName='Smith';
        update UpdateMedicalProfessional;
    }
    
    public testmethod static void createwishfamilyContact(){
        Contact wishChildFamily = OrientationandTrainingUtil.CreateWishFamily();
    }
    
    public testmethod static void RecallWishChildContactInfo(){
        
        Contact childCon = OrientationandTrainingUtil.CreateWishChildCon();
        Contact childFamily = OrientationandTrainingUtil.CreateWishFamily();
        npe4__Relationship__c  npcr = OrientationandTrainingUtil.CreateRelationshipRec(childCon.Id,childFamily.Id);
        
        Contact updateConFamily = new Contact();
        updateConFamily.Hidden_First_Name__c  = 'Chandra';
        updateConFamily.Hidden_Last_Name__c  = 'Sekar';
        updateConFamily.Hidden_Phone__c = '8056913402';
        updateConFamily.Hidden_Email__c  = 'testmst@gmail.com';
        updateConFamily.Hidden_Street__c = 'North Street';
        updateConFamily.Hidden_city__c = 'Chennai';
        updateConFamily.Hidden_State__c = 'Alabama';
        updateConFamily.Hidden_Country__c =  'United States';
        updateConFamily.Hidden_Zip_Code__c = '621010';
        updateConFamily.IsContactInfoUpdated__c = true;
        updateConFamily.Id = childFamily.Id;
        update updateConFamily;
        
        
        Contact updateCon = new Contact();
        updateCon.Email = 'kanagu431@gmail.com';
        updateCon.IsContactInfoUpdated__c = true;
        updateCon.Id = childCon.Id;
        update updateCon;
    }
    
    public testmethod static void updatewishChildRecall(){
        
        
        Contact childCon = OrientationandTrainingUtil.CreateWishChildCon();
        Contact childFamily = OrientationandTrainingUtil.CreateWishFamily();
        npe4__Relationship__c  npcr = OrientationandTrainingUtil.CreateRelationshipRec(childCon.Id,childFamily.Id);
        childFamily.Hidden_First_Name__c  = '';
        Update childFamily;
        Contact updateCon = new Contact();
        updateCon.Hidden_First_Name__c  = 'Chandra';
        updateCon.Hidden_Last_Name__c  = 'Sekar';
        updateCon.Hidden_Phone__c = '8056913402';
        updateCon.Hidden_Email__c  = 'testmst@gmail.com';
        updateCon.Hidden_Street__c = 'North Street';
        updateCon.Hidden_State__c = 'Alabama';
        updateCon.Hidden_Country__c =  'United States';
        updateCon.Hidden_Zip_Code__c = '621010';
        updateCon.HiddenOtherPhone__c = '9876543210';
        updateCon.HiddenMobilePhone__c = '8907654321';
        updateCon.Hidden_Use_as_Household_Address__c = True;
        updateCon.IsRejected_Contact_Info__c = true;
        updateCon.Id = childCon.Id;
        update updateCon;
        updateCon.Hidden_city__c = 'Chennai';
        Update updateCon;
        
        
    }
    
    public testmethod static void  updateRelationship(){
        Contact childCon = OrientationandTrainingUtil.CreateWishChildCon();
        Contact childFamily = OrientationandTrainingUtil.CreateWishFamily();
        npe4__Relationship__c  newRelationShip= OrientationandTrainingUtil.CreateRelationshipRec(childCon.Id,childFamily.Id); 
        childFamily.Relationship__c = 'Brother';
        childFamily.Email = 'Test@msil.com';
        Update childFamily;
        
        Contact wishchildCon = OrientationandTrainingUtil.CreateWishChildCon();
        Contact wishchildFamily = OrientationandTrainingUtil.CreateWishFamily();
        npe4__Relationship__c   relationship = new npe4__Relationship__c();
        newRelationShip.Parent_Legal_Guardian__c = True;
        relationship.npe4__Contact__c = wishchildCon.Id;
        relationship.npe4__RelatedContact__c = wishchildFamily.Id;
        relationship.npe4__Status__c = 'Active';
        relationship.npe4__Type__c = 'Father';
        Insert relationship;
        
    }
    
    public testmethod static void deleteContact()
    {
        Contact childCon = OrientationandTrainingUtil.CreateWishChildCon();
        Contact childFamily = OrientationandTrainingUtil.CreateWishFamily();
        Delete childFamily;
    }
}