/***********************************************************************
Description : Sharing the records to Chatper Staff with Read & Write permission 
for their corresponding chapter records.
************************************************************************/

Public class ChapterStaffRecordSharing_AC
{
   public static void LeadSharing(Map<String,List<Lead>> leadMap)
   {
       Map<String, String> ChapterRoleMap = FindChapterRole(leadMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<LeadShare> leadsToShare = new List<LeadShare>();
      for(String currChapter : leadMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Lead currLead : leadMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       LeadShare currSharing = new LeadShare();
                       currSharing.leadId = currLead.id;
                       currSharing.UserOrGroupId = currUser.id;//.subString(0,15);//'00536000001rItA';//currVolunteer.subString(0,15);
                       currSharing.leadAccessLevel = 'Edit';
                       currSharing.RowCause = Schema.LeadShare.RowCause.Manual;
                       leadsToShare.add(currSharing);
                  }
               }
             }
         }
        
      } 
      
      if(leadsToShare.size() > 0)
          insert leadsToShare;
      
   
   }
   
   public static void ContactSharing(Map<String,List<Contact>> contactMap)
   {
     /* Map<String, String> ChapterRoleMap = FindChapterRole(contactMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<ContactShare> contactsToShare = new List<ContactShare>();
      for(String currChapter : contactMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Contact currCon : contactMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       ContactShare currSharing = new ContactShare();
                       currSharing.contactId = currCon.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.contactAccessLevel = 'Edit';
                       currSharing.RowCause = Schema.ContactShare.RowCause.Manual;
                       contactsToShare.add(currSharing);
                  }
               }
             }
         }
      } */
      
     /* if(contactsToShare.size() > 0)
          insert contactsToShare;*/
      
   
   }
   
   public static void AccountSharing(Map<String,List<Account>> accountMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(accountMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<AccountShare> accountsToShare = new List<AccountShare>();
      for(String currChapter : accountMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Account currAcc : accountMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       AccountShare currSharing = new AccountShare();
                       currSharing.accountId = currAcc.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.accountAccessLevel = 'Edit';
                       currSharing.OpportunityAccessLevel = 'Read';
                       currSharing.CaseAccessLevel = 'Edit';
                       currSharing.ContactAccessLevel = 'Edit';
                       
                       currSharing.RowCause = Schema.AccountShare.RowCause.Manual;
                       accountsToShare.add(currSharing);
                  }
               }
             }
         }
      }
      
      if(accountsToShare.size() > 0)
          insert accountsToShare;
          
          System.debug('Accountssharing++++++++++++++++++++++++++++++++++ ' +accountsToShare); 
      
   
   }
   
   
   public static void CaseSharing(Map<String,List<Case>> CaseMap)
   {
     /* Map<String, String> ChapterRoleMap = FindChapterRole(CaseMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<CaseShare> casesToShare = new List<CaseShare>();
      for(String currChapter : CaseMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Case currCase : CaseMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       CaseShare currSharing = new CaseShare();
                       currSharing.caseId = currCase.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.caseAccessLevel = 'Edit';
                       currSharing.RowCause = Schema.caseShare.RowCause.Manual;
                       casesToShare.add(currSharing);
                  }
               }
             }
         }
      } */
      
    //  if(casesToShare.size() > 0)
         // insert casesToShare;
      
   
   }
   
   
   Public static void BGCRecordSharing(Map<String,List<Background_check__c>> bgcRecordMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(bgcRecordMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Background_check__Share> bgcToShare = new List<Background_check__Share>();
      for(String currChapter : bgcRecordMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Background_check__c currBGC : bgcRecordMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Background_check__Share currSharing = new Background_check__Share();
                       currSharing.ParentId = currBGC.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Edit';
                       currSharing.RowCause = Schema.Background_check__Share.RowCause.Manual;
                       bgcToShare.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(bgcToShare.size() > 0)
        insert bgcToShare;
      }
   
   
    Public static void COIRecordSharing(Map<String,List<Conflict_Of_Interest__c>> coiRecordMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(coiRecordMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Conflict_Of_Interest__Share> coiToShare = new List<Conflict_Of_Interest__Share>();
      for(String currChapter : coiRecordMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Conflict_Of_Interest__c currCOI : coiRecordMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Conflict_Of_Interest__Share currSharing = new Conflict_Of_Interest__Share();
                       currSharing.ParentId = currCOI.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Edit';
                       currSharing.RowCause = Schema.Conflict_Of_Interest__Share.RowCause.Manual;
                       coiToShare.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(coiToShare.size() > 0)
         insert coiToShare;
      }
       
       Public static void broadRecordSharing(Map<String,List<Broadcast__c>> boradRecordMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(boradRecordMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Broadcast__Share> broadcastToShare = new List<Broadcast__Share>();
      for(String currChapter : boradRecordMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Broadcast__c currBroadcast : boradRecordMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Broadcast__Share currSharing = new Broadcast__Share();
                       currSharing.ParentId = currBroadcast .id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Read';
                       currSharing.RowCause = Schema.Broadcast__Share.RowCause.Manual;
                       broadcastToShare.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(broadcastToShare .size() > 0)
         insert broadcastToShare;
      }
   
   Public static void awardsRegRecordSharing(Map<String,List<Awards_Recognition__c>> awrdsRegRecordMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(awrdsRegRecordMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Awards_Recognition__Share> awardsRegToShareList = new List<Awards_Recognition__Share>();
      for(String currChapter : awrdsRegRecordMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Awards_Recognition__c currRec : awrdsRegRecordMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Awards_Recognition__Share currSharing = new Awards_Recognition__Share();
                       currSharing.ParentId = currRec.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Edit';
                       currSharing.RowCause = Schema.Awards_Recognition__Share.RowCause.Manual;
                       awardsRegToShareList.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(awardsRegToShareList.size() > 0)
         insert awardsRegToShareList;
   }
  
  //Chapter Action Track.
  
  Public static void chapterActionTrackSharing(Map<String,List<Chapter_Action_Track__c>> chapterActionRecordMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(chapterActionRecordMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Chapter_Action_Track__Share> chapterActionToShareList = new List<Chapter_Action_Track__Share>();
      for(String currChapter : chapterActionRecordMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Chapter_Action_Track__c currRec : chapterActionRecordMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Chapter_Action_Track__Share currSharing = new Chapter_Action_Track__Share();
                       currSharing.ParentId = currRec.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Read';
                       currSharing.RowCause = Schema.Chapter_Action_Track__Share.RowCause.Manual;
                       chapterActionToShareList.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(chapterActionToShareList.size() > 0)
         insert chapterActionToShareList;
   }
  
  //Chapter_Role__c
  
  Public static void chapterRoleSharing(Map<String,List<Chapter_Role__c>> chapterRoleRecordMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(chapterRoleRecordMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Chapter_Role__Share> chapterRoleToShareList = new List<Chapter_Role__Share>();
      for(String currChapter : chapterRoleRecordMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Chapter_Role__c currRec : chapterRoleRecordMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Chapter_Role__Share currSharing = new Chapter_Role__Share();
                       currSharing.ParentId = currRec.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Edit';
                       currSharing.RowCause = Schema.Chapter_Role__Share.RowCause.Manual;
                       chapterRoleToShareList.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(chapterRoleToShareList.size() > 0)
         insert chapterRoleToShareList;
   }
   
   //Chapter Role O&T
    Public static void chapterRoleOTSharing(Map<String,List<Chapter_Role_O_T__c>> chapterRoleOTRecordMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(chapterRoleOTRecordMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Chapter_Role_O_T__Share> chapterRoleOTToShareList = new List<Chapter_Role_O_T__Share>();
      for(String currChapter : chapterRoleOTRecordMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Chapter_Role_O_T__c currRec : chapterRoleOTRecordMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Chapter_Role_O_T__Share currSharing = new Chapter_Role_O_T__Share();
                       currSharing.ParentId = currRec.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Edit';
                       currSharing.RowCause = Schema.Chapter_Role_O_T__Share.RowCause.Manual;
                       chapterRoleOTToShareList.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(chapterRoleOTToShareList.size() > 0)
         insert chapterRoleOTToShareList;
   }
   
   //Class Offering
     Public static void classOfferingSharing(Map<String,List<Class_Offering__c>> classOfferingRecordMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(classOfferingRecordMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Class_Offering__Share> classOfferingShareList = new List<Class_Offering__Share>();
      for(String currChapter : classOfferingRecordMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Class_Offering__c currRec : classOfferingRecordMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Class_Offering__Share currSharing = new Class_Offering__Share();
                       currSharing.ParentId = currRec.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Edit';
                       currSharing.RowCause = Schema.Class_Offering__Share.RowCause.Manual;
                       classOfferingShareList.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(classOfferingShareList.size() > 0)
         insert classOfferingShareList;
   }
   
   //In-Kind Donation & Reimbursement
     Public static void inKindReimbursementSharing(Map<String,List<In_Kind_Donation_Reimbursement__c>> inkindRecordsMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(inkindRecordsMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<In_Kind_Donation_Reimbursement__Share> inKindShareList = new List<In_Kind_Donation_Reimbursement__Share>();
      for(String currChapter : inkindRecordsMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(In_Kind_Donation_Reimbursement__c currRec : inkindRecordsMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       In_Kind_Donation_Reimbursement__Share currSharing = new In_Kind_Donation_Reimbursement__Share();
                       currSharing.ParentId = currRec.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Edit';
                       currSharing.RowCause = Schema.In_Kind_Donation_Reimbursement__Share.RowCause.Manual;
                       inKindShareList.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(inKindShareList.size() > 0)
         insert inKindShareList;
   }
   
   //Non-Wish & Events
    Public static void nonWishEventsSharing(Map<String,List<Non_Wish_Events__c>> nonWishEventRecordsMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(nonWishEventRecordsMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Non_Wish_Events__Share> nonWishEventShareList = new List<Non_Wish_Events__Share>();
      
      for(String currChapter : nonWishEventRecordsMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Non_Wish_Events__c currRec : nonWishEventRecordsMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Non_Wish_Events__Share currSharing = new Non_Wish_Events__Share();
                       currSharing.ParentId = currRec.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Edit';
                       currSharing.RowCause = Schema.Non_Wish_Events__Share.RowCause.Manual;
                       nonWishEventShareList.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(nonWishEventShareList.size() > 0)
         insert nonWishEventShareList;
   }
   
   //Volunteer Opportunity
    Public static void volunteerOpportunitySharing(Map<String,List<Volunteer_Opportunity__c>> voluteerOppRecordsMap)
   {
      Map<String, String> ChapterRoleMap = FindChapterRole(voluteerOppRecordsMap.keySet());
      Map<String,List<User>> userMap = userRecMap(ChapterRoleMap.values());
      List<Volunteer_Opportunity__Share> voluteerOppShareList = new List<Volunteer_Opportunity__Share>();
      
      for(String currChapter : voluteerOppRecordsMap.keySet())
      {
         if(ChapterRoleMap.containsKey(currChapter))
         {
             if(userMap.containsKey(ChapterRoleMap.get(currChapter)))
             {
               for(Volunteer_Opportunity__c currRec : voluteerOppRecordsMap.get(currChapter))
               {
                  for(User currUser : userMap.get(ChapterRoleMap.get(currChapter)))
                  {
                       Volunteer_Opportunity__Share currSharing = new Volunteer_Opportunity__Share();
                       currSharing.ParentId = currRec.id;
                       currSharing.UserOrGroupId = currUser.id;
                       currSharing.AccessLevel = 'Edit';
                       currSharing.RowCause = Schema.Volunteer_Opportunity__Share.RowCause.Manual;
                       voluteerOppShareList.add(currSharing);
                  }
               }
             }
         }
      
      }
      
      if(voluteerOppShareList.size() > 0)
         insert voluteerOppShareList;
   }
   
   
   public static Map<String,List<User>> userRecMap(List<String> usersRole)
   {
      Map<String,List<User>> userMap = new Map<String,List<User>>();
   
      for(User currUser : [SELECT id,userrole.Name FROM User WHERE userrole.name in :usersRole AND isActive=True])
      {
          if(userMap.containsKey(currUser.userrole.Name))
              userMap.get(currUser.userrole.Name).add(currUser);
          else
              userMap.put(currUser.userrole.Name, new list<user>{currUser});
             
      }
      
      return userMap;
   }
   
   public static Map<String, String> FindChapterRole(Set<String> chaptersSet)
   {
      Map<String, String> ChapterRoleMap = new Map<String, String>();
      for(Chapter_Vs_Role__c currChapterRole : [SELECT Chapter_Name__c, Role_Name__c FROM Chapter_Vs_Role__c WHERE Chapter_Name__c IN : chaptersSet])
      {
          ChapterRoleMap.put(currChapterRole.Chapter_Name__c,currChapterRole.Role_Name__c);
      }
      
      return ChapterRoleMap;
   }

}