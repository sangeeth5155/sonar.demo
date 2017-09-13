/*****************************************************************************************************************
Enabled By : Vennila Paramasivam.
Description : An apex page controller that supports self registration of volunteers in communities that allow self registration

*****************************************************************************************************************/
public class CommunitiesSelfRegController {
    
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email{get; set;}
    public String phone{get;set;}
    public String city{get;set;}
    public String state{get;set;}
    public String zipCode{get;set;}
    public String username{get;set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public boolean isOver18YearsOld{get;set;}
    Public boolean showErrorMsg {get;set;}
    Public string errorMessage {get;set;}
    Public String chapterRT;
    Public String nationalRT;
    public String userId;
    
    
    Public String signUpNotes{get;set;}
    
    public CommunitiesSelfRegController() {
        Constant_AC  constant = new Constant_Ac();
        chapterRT= Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.ChapterRT).getRecordTypeId();
        nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.nationalRT).getRecordTypeId();
        Dynamic_Content__c signUpContent = new Dynamic_Content__c();
        signupContent = [SELECT id, Sign_Up_Page__c from Dynamic_Content__c WHERE RecordTypeId = :nationalRT and active__c = true limit 1];
        if(signupContent != Null)
            signUpNotes = signUpContent.Sign_Up_Page__c;
    }
    
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    // It will create Volunteer Contact and User record based on the Sign up page inputs.
    public PageReference registerUser() {
    
    
       // TimeZone Map
         String timeZone;
         Map<String,String> timeZoneMap = new Map<String,String>();
         timeZoneMap.put('(GMT-07:00) Mountain Standard Time (America/Phoenix)','America/Phoenix');
         timeZoneMap.put('(GMT-02:00) Brasilia Summer Time (America/Sao_Paulo)','America/Sao_Paulo');
         timeZoneMap.put('(GMT-03:00) Argentina Time (America/Argentina/Buenos_Aires)','America/Argentina/Buenos_Aires');
         timeZoneMap.put('(GMT-03:00) Chile Summer Time (America/Santiago)','America/Santiago');
         timeZoneMap.put('(GMT-03:30) Newfoundland Standard Time (America/St_Johns)','America/St_Johns');
         timeZoneMap.put('(GMT-04:00) Atlantic Standard Time (America/Halifax)','America/Halifax');
         timeZoneMap.put('(GMT-04:00) Atlantic Standard Time (America/Puerto_Rico)','America/Puerto_Rico');
         timeZoneMap.put('(GMT-04:30) Venezuela Time (America/Caracas)','America/Caracas');
         timeZoneMap.put('(GMT-05:00) Colombia Time (America/Bogota)','America/Bogota');
         timeZoneMap.put('(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)','America/Indiana/Indianapolis');
         timeZoneMap.put('(GMT-05:00) Peru Time (America/Lima)','America/Lima');
         timeZoneMap.put('(GMT-05:00) Eastern Standard Time (America/New_York)','America/New_York');
         timeZoneMap.put('(GMT-05:00) Eastern Standard Time (America/Panama)','America/Panama');
         timeZoneMap.put('(GMT-06:00) Central Standard Time (America/Chicago)','America/Chicago');
         timeZoneMap.put('(GMT-06:00) Central Standard Time (America/El_Salvador)','America/El_Salvador');
         timeZoneMap.put('(GMT-06:00) Central Standard Time (America/Mexico_City)','America/Mexico_City');
         timeZoneMap.put('(GMT-07:00) Mountain Standard Time (America/Denver)','America/Denver');
         timeZoneMap.put('(GMT-07:00) Mountain Standard Time (America/Phoenix)','America/Phoenix');
         timeZoneMap.put('(GMT-08:00) Pacific Standard Time (America/Los_Angeles)','America/Los_Angeles');
         timeZoneMap.put('(GMT-08:00) Pacific Standard Time (America/Tijuana)','America/Tijuana');
         timeZoneMap.put('(GMT-09:00) Alaska Standard Time (America/Anchorage)','America/Anchorage');
         
        
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    
        
        
        if((lastName  == NULL || lastName  == '') && (email == NULL || email == '')){
            errorMessage = 'Please enter your last name and email address.';
            showErrorMsg = true;
            return null;
        } else
            showErrorMsg = false;
        
        if(lastName   == NULL || lastName   == ''){
            errorMessage = 'Please enter your last name.';
            showErrorMsg = true;
            return null;
        }else
            showErrorMsg = false;
        
        if(email  == NULL || email  == '' || !validateEmail(email)){
            errorMessage = 'Please enter a valid email address.';
            showErrorMsg = true;
            return null;
        } else 
            showErrorMsg = false; 
        
        
        if((zipcode== NULL || zipcode== '')){
            errorMessage = 'Please enter your zip code.';
            showErrorMsg = true;
            return null;
        } else
            showErrorMsg = false; 
        
        
        if((zipcode != Null) && (zipcode.length() > 5 || zipcode.length() <5)){
            errorMessage = 'Please enter a 5 digit zip code.';
            showErrorMsg = true;
            return null;
        } else
            showErrorMsg = false;   
        
        if((username == NULL || username == '' || !validateEmail(username))){
            errorMessage = 'Please enter a valid username. Username must be in email format (name@domain.com).';
            showErrorMsg = true;
            return null;
        } else
            showErrorMsg = false;
        
        if((password == NULL || password == '')){
            errorMessage = 'Please enter a password.';
            showErrorMsg = true;
            return null;
        } else
            showErrorMsg = false; 
        
        if((confirmPassword == NULL || confirmPassword== '')){
            errorMessage = 'Please confirm password.';
            showErrorMsg = true;
            return null;
        } else
            showErrorMsg = false;
        
        if(isOver18YearsOld == False){
            errorMessage = 'Thank you for your interest in volunteering with Make-A-Wish. Most volunteer opportunities are '
                +'designed for individuals over the age of 18. If you are under the age of 18,'+
                'please contact your local chapter to discuss what, if any, opportunities we currently have available.';
            showErrorMsg = true;
            return null;
        } else
            showErrorMsg = false;
        
       
        String accountId;
       
        List<Zip_Code__c> getChpaterName = [SELECT Office__c,Office__r.Chapter__c FROM Zip_Code__c WHERE Name = :zipcode limit 1];
        
        if(getChpaterName.size() > 0) {
            List<Account> getAccount = new List<Account>();
            if(getChpaterName[0].Office__c != Null)
                 getAccount = [SELECT id, Name, Timezone__c FROM Account WHERE Id = :getChpaterName[0].Office__r.Chapter__c limit 1];
            System.debug('getAccount----'+getAccount);
            if(getAccount.size() > 0) {
                accountId = getAccount[0].id;
                timeZone =  getAccount[0].timeZone__c;
            }
            else {
                List<Account> currAccount = [SELECT id, TimeZone__c FROM Account Where Name = 'Make-A-Wish America' limit 1];
                
                if(!(currAccount.size() > 0)) {
                    Account newAccount = new Account();
                    newAccount.Name = 'Make-A-Wish America';
                    newAccount.RecordTypeId = chapterRT;
                    insert newAccount;
                    accountId = newAccount.id;
                   
                }
                else
                {
                    accountId = currAccount[0].id;
                    timeZone =  currAccount[0].timeZone__c;
                }
            }
        }
        else {
            List<Account> currAccount = [SELECT id,timeZone__c FROM Account Where Name = 'Make-A-Wish America' limit 1];
            
            if(!(currAccount.size() > 0)) {
                Account newAccount = new Account();
                newAccount.Name = 'Make-A-Wish America';
                newAccount.RecordTypeId = chapterRT;
                insert newAccount;
                accountId = newAccount.id;
            }
            else
            {
                accountId = currAccount[0].id;
                timeZone =  currAccount[0].timeZone__c;
            }
        }
        
        String profileId = label.Prospective_Volunteer;
        
        
        List<User> checkExUser = [SELECT id FROM User WHERE Username = :userName];
        List<Contact> exContacts = [SELECT id FROM Contact WHERE email = :email AND AccountId = :accountId];
        if(checkExUser.size() > 0)
        {
            errorMessage = 'The username you provided is already in use. Please enter a different username to continue the sign up process. If you have already signed up, please click "Log In" to access the login page.';
            showErrorMsg = true;
            return null;
        
        }
        else if(exContacts.size() > 0)
        {
            errorMessage = 'The email you provided is already in use. Please enter a different email address to continue the sign up process. If you have already signed up, please click "Log In" to access the login page.';
            showErrorMsg = true;
            return null;
        }
        else
        {
            User newUser = new User();
            newUser.Username = userName;
            newUser.Email = email;
            newUser.FirstName = firstName;
            newUser.LastName = lastName;
            newUser.CommunityNickname = userName;
            newUser.Phone = phone;
            newUser.State = state;
            newUser.city = city;
            newUser.postalCode = zipCode;
            newUser.ProfileId = profileId;
            newUser.I_am_over_18_years_old__c = isOver18YearsOld;
            newUser.created_from_portal__c = true;
            if(timeZoneMap.containsKey(timeZone))
                   newUser.TimeZoneSidKey = timeZoneMap.get(timeZone);
            else
                   newUser.TimeZoneSidKey='America/Los_Angeles';
            
            try {
                userId = Site.createExternalUser(newUser, accountId, password);
            } catch(Site.ExternalUserCreateException ex) {
                List<String> errors = ex.getDisplayMessages();
                for (String error : errors)  {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }
                
                // This message is used for debugging. Do not display this in the UI to the end user.
                // It has the information around why the user creation failed.
                System.debug(ex.getMessage());
            }
        
       } 
        // If Volunteer is created successfully, then redirect to Volunteer Landing Page.
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                return Site.login(userName, password, '/VolunteerWelcomePage_VF');
            }
            else {
                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        return null;
    }
    
    // Validating Email Address is valid or not.
    public static boolean validateEmail(string email){
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        return MyMatcher.matches();
    }
    
    //Capturing State Picklist values.   
    public List<SelectOption> getStates() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.State_Picklist__c.getDescribe();
        options.add(new SelectOption('', 'Select an option')); 
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues){
            options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
            
        }  
        return options;
    }  
}