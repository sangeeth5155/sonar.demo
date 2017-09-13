/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest 
public with sharing class CommunitiesSelfRegControllerTest 
{
  
   /* validate with empty values */
    public static testmethod void testCommunitiesSelfRegController() 
    {
       TestClassUtil.createDynamicContent();
     
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.registerUser();
    } 
   /** LastName validation */
    public static testmethod void LastNameValidation() 
    {
       TestClassUtil.createDynamicContent();
     
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.Email = 'test@gmail.com';
       selfRegCtrl.registerUser();
    } 
    /* First name as blank */
    public static testmethod void firstNameValidation() 
    {
       TestClassUtil.createDynamicContent();
     
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.registerUser();
    } 
     /* zipCode as blank */
    public static testmethod void zipCodeValidation() 
    {
       TestClassUtil.createDynamicContent();
      
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.registerUser();
    } 
     /* Enter email as blank */
    public static testmethod void EmailValidation() 
    {
       TestClassUtil.createDynamicContent();
     
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.lastName = 'test';
       selfRegCtrl.registerUser();
    } 
      /* zipcode greater than 5 */
    public static testmethod void zipCodeSizeValidation() 
    {
       TestClassUtil.createDynamicContent();
     
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='350043';
       selfRegCtrl.registerUser();
    } 
    
    /* Fill Username */
   public static testmethod void usernameValidation() 
    {
       TestClassUtil.createDynamicContent();
      
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='35004';
       selfRegCtrl.username='test';
       selfRegCtrl.registerUser();
    } 
    // Captuing password valiation.
    public static testmethod void passwordValidation() 
    {
       TestClassUtil.createDynamicContent();
     
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='35004';
       selfRegCtrl.username='test@username.com';
       selfRegCtrl.registerUser();
    } 
    //  Capturing confirm password validation.
    public static testmethod void confirmPasswordValidation() 
    {
       TestClassUtil.createDynamicContent();
     
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='35004';
       selfRegCtrl.username='test@username.com';
       selfRegCtrl.password = 'abcded';
       selfRegCtrl.registerUser();
    } 
    // Capturing voluteer age valiation.
    public static testmethod void volunteerAgeValidation() 
    {
       TestClassUtil.createDynamicContent();
      
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='35004';
       selfRegCtrl.username='test@username.com';
       selfRegCtrl.password = 'abcded';
       selfRegCtrl.confirmPassword = 'abcded';
       selfRegCtrl.registerUser();
    } 
    
    public static testmethod void coverStatePicklist() 
    {
       TestClassUtil.createDynamicContent();
     
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='35004';
       selfRegCtrl.username='test@username.com';
       selfRegCtrl.password = 'abcded';
       selfRegCtrl.confirmPassword = 'abcded';
       selfRegCtrl.isOver18YearsOld = True;
       selfRegCtrl.registerUser();
       selfRegCtrl.getStates();
       
    } 
    public static testmethod void validateBelow18Year() 
    {
       TestClassUtil.createDynamicContent();
       
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='35004';
       selfRegCtrl.username='test@username.com';
       selfRegCtrl.password = 'abcded';
       selfRegCtrl.confirmPassword = 'abcded';
        selfRegCtrl.isOver18YearsOld = false;
       selfRegCtrl.registerUser();
    } 
    // Sign up with valid details.
    public static testmethod void CreateUserwithValidData() 
    {
       TestClassUtil.createDynamicContent();
      
        Account chapterAccount = TestClassUtil.createChapter();
        Office__c newOffice = TestClassUtil.createOffice();
        newOffice.Chapter__c = chapterAccount.Id;
        newOffice.External_Id__c = 'Test123';
        insert newOffice;
        Zip_Code__c newZipCode = TestClassUtil.createZipCode();
        newZipCode.Office__c = newOffice.Id;
        newZipCode.Name = '35004';
        newZipCode.External_Id__c = 'Test123';
        insert newZipCode;
        
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='35004';
       selfRegCtrl.username='test@username.com';
       selfRegCtrl.password = 'abcded';
       selfRegCtrl.confirmPassword = 'abcded';
       selfRegCtrl.isOver18YearsOld = True;
       selfRegCtrl.registerUser();
       selfRegCtrl.getStates();
    } 
    
    // Sign up with valid details.
    public static testmethod void CreateDupUser() 
    {
        Constant_AC  constant = new Constant_AC(); 
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        TestClassUtil.createDynamicContent();
      
        Account chapterAccount = TestClassUtil.createChapter();
        Office__c newOffice = TestClassUtil.createOffice();
        newOffice.Chapter__c = chapterAccount.Id;
        newOffice.External_Id__c = 'Test123';
        insert newOffice;
        Zip_Code__c newZipCode = TestClassUtil.createZipCode();
        newZipCode.Office__c = newOffice.Id;
        newZipCode.Name = '35004';
        newZipCode.External_Id__c = 'Test123';
        insert newZipCode;
        
        Contact con = new Contact();
        con.LastName = 'Test';
        con.RecordTypeId = volunteerRecordTypeId;
        con.Email = 'test@gmail.com';
        con.accountId = chapterAccount.id;
        insert con;
        
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='35004';
       selfRegCtrl.username='test@username.com';
       selfRegCtrl.password = 'abcded';
       selfRegCtrl.confirmPassword = 'abcded';
       selfRegCtrl.isOver18YearsOld = True;
       selfRegCtrl.registerUser();
       selfRegCtrl.getStates();
    } 
    
    // Sign up with valid details.
    public static testmethod void chapterListBlank() 
    {
       TestClassUtil.createDynamicContent();
       TestClassUtil.createVolunteerAccount();
      
      
        Zip_Code__c newZipCode = TestClassUtil.createZipCode();
        newZipCode.Name = '35004';
        newZipCode.external_Id__c = 'test2356';
        insert newZipCode;
        
       CommunitiesSelfRegController selfRegCtrl=new CommunitiesSelfRegController();
       selfRegCtrl.email= 'test@gmail.com';
       selfRegCtrl.lastName='a';
       selfRegCtrl.firstName='a';
       selfRegCtrl.zipCode='35004';
       selfRegCtrl.username='test@username.com';
       selfRegCtrl.password = 'abcded';
       selfRegCtrl.confirmPassword = 'abcded';
       selfRegCtrl.isOver18YearsOld = True;
       selfRegCtrl.registerUser();
       selfRegCtrl.getStates();
    } 
    
   
}