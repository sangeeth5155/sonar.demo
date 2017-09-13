/*
* Description : It will create volunteer user record while doing volunteer contact data import.
*This will fire only when Migrated_Record is true on Volunteer Contact.
*/

public class VolunteerContactHandler{
   @future  
    public static void createUser(Set<Id> contactIds)
    { 
         User newUser;
         List<User> userList=new List<User>();
        // Database.DMLOptions dlo = new Database.DMLOptions();
        // dlo.EmailHeader.triggerUserEmail= true;
         
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
         
         String profileId = label.Active_Volunteer_Profile;
         for(Contact currContact:[SELECT FirstName,Id,LastName,Account.Timezone__c,email,Middle_Name__c FROM Contact WHERE Id IN :contactIds AND email != Null]){
            
               newUser=new User();
               newUser.FirstName=currContact.FirstName;
               newUser.LastName=currContact.LastName;
               newUser.ContactId=currContact.Id;
               newUser.CommunityNickname=currContact.Email;
               newUser.ProfileId=profileId;
               newUser.Email=currContact.Email;
               newUser.Username=currContact.email;
                if(currContact.LastName != Null)
                { 
                   if(currContact.LastName.length() > 7)
                       newUser.Alias=(currContact.LastName).subString(0,7);
                   else
                       newUser.Alias=(currContact.LastName);
                }
                  if(currContact.Middle_Name__c != Null)
                  { 
                   if(currContact.Middle_Name__c.length() > 7)
                       newUser.Alias=(currContact.Middle_Name__c).subString(0,7);
                   else
                       newUser.Alias=(currContact.Middle_Name__c);
                  }
             //  newUser.TimeZoneSidKey='America/Los_Angeles';
               if(timeZoneMap.containsKey(currContact.account.Timezone__c))
                   newUser.TimeZoneSidKey = timeZoneMap.get(currContact.account.Timezone__c);
               else
                   newUser.TimeZoneSidKey='America/Los_Angeles';
               newUser.LocaleSidKey='en_US';
               newUser.EmailEncodingKey='ISO-8859-1';
               newUser.LanguageLocaleKey='en_US';
               newUser.IsActive=True;
               //newUser.setOptions(dlo);
               newUser.migrated_user__c = True;
               userList.add(newUser);
      
        }
        
        if(userList.Size() > 0){
           Database.insert(userList,false);
        }    
            
      }
}