/**************************************************************************************
Enabled by : Vennila Paramasivam
Description : This community used for capturing Volunteer for Make A Wish. Already signed up user can login using their username and password.
Based on the User Profile, Volunteer will redirect to the portal.
If Volunteer Profile is "Prospective Volunteer", then they will redirect to Prospective Volunteer Portal.
Suppose Volunteer Profile is "Active Volunteer", then they will redirect to Active Volunteer Portal.
****************************************************************************************/
global class CommunitiesLoginController {
    
    global CommunitiesLoginController () {}
    
    global String username {get; set;}
    global String password {get; set;}
    
    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        List<User> getUserDetails = [SELECT Id,Profile.name,ContactId from User WHERE Username = :username limit 1];
        if(getUserDetails.size() > 0){
            // If Prospective Volunteer, then they will be landed to Propective Volunteer Welcome Page.
            if(getUserDetails[0].Profile.name == 'Prospective Volunteer (Login)' || getUserDetails[0].Profile.name == 'Prospective Volunteer (Member)') {
                return Site.login(username, password, '/apex/VolunteerWelcomePage_VF');
            }
            else {
                // If Active Volunteer, then they will be landed to Active Volunteer Welcome Page.
                if(getUserDetails.size()>0)  {
                    List<npe5__Affiliation__c> getPrimaryChapter = [SELECT Id, npe5__Organization__r.Name FROM npe5__Affiliation__c WHERE npe5__Contact__c =: getUserDetails.get(0).ContactId AND npe5__Primary__c = true];
                    if(getPrimaryChapter.size()>0)  {
                        // If the volunteer belongs to mulitple chapter then they will redirect to login page, where they finally logout from the chapter. 
                        // Volunteer last login chapter will be stored in HoldCurrentChapter custom settings.
                        // For example, If Volunteer belongs to Alabama and Arizona, if the user logged in Arizona finally, when the login next time, they will redirect to Arizona Chapter.
                        // If Volunteer login first time, then they will redirect to Primary chapter.
                        List<HoldCurrentChapter__c> getChapterValues = [SELECT Name,CurrentChapter__c FROM HoldCurrentChapter__c  WHERE Name =: getUserDetails.get(0).Id LIMIT 1];
                        if(getChapterValues.size()>0) {
                            getChapterValues.get(0).CurrentChapter__c = getPrimaryChapter.get(0).npe5__Organization__r.Name;
                            update getChapterValues;
                        } 
                        else {
                            HoldCurrentChapter__c newHoldChapter = new HoldCurrentChapter__c();
                            newHoldChapter.Name = getUserDetails.get(0).Id;
                            newHoldChapter.CurrentChapter__c = getPrimaryChapter.get(0).npe5__Organization__r.Name;
                            insert newHoldChapter;
                        }
                    }
                }
                if(!String.isEmpty(startUrl)) {
                    return Site.login(username, password, startUrl);
                } else {
                    return Site.login(username, password, '/apex/VolunteerLanding_VF');
                }
            }
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Username does not exist');
            ApexPages.addMessage(msg);
            return null;
        }
        return null;
    }
    
}