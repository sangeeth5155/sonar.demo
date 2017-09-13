@isTest
public class VolunteerLanding_AC_Test {
    
    // Capturing Dynamic content and Events. 
    static testmethod void createDynamicContent()
    {
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        
        User currUser;
        System.RunAs(new User(Id = UserInfo.getUserId()))
        {
            currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        }
        System.RunAs(currUser)
        {
            
            Dynamic_Content__c  createProspectiveDynamicContent = OrientationandTrainingUtil.ChapterDynamicContent(acc.id);
            HoldCurrentChapter__c currVal = new HoldCurrentChapter__c();
            currVal.Name = currUser.id;
            currVal.CurrentChapter__c = acc.Name;
            insert currVal;
            
            
            Constant_AC  constant = new Constant_Ac();    
            Id EventRecTypeId = Schema.Sobjecttype.Non_Wish_Events__c.getRecordTypeInfosByName().get(constant.events).getRecordTypeId();
            
            List<Non_Wish_Events__c> eventList= new List<Non_Wish_Events__c>();
            for(integer i =1 ; i<4;i++)
            {
                
                Non_Wish_Events__c newEvent = new Non_Wish_Events__c();
                newEvent.Event_Name__c = 'Send Off';
                newEvent.Event_Date__c = System.Today()+5;
                newEvent.Event_Text__c = 'Sending Wish Child';
                newEvent.Priority__c = String.valueOf(i);
                newEvent.chapter__c = acc.id;
                newEvent.RecordTypeId =  EventRecTypeId;
                eventList.add(newEvent);
                
            }
            
            Non_Wish_Events__c newEvent = new Non_Wish_Events__c();
            newEvent.Event_Name__c = 'Send Off';
            newEvent.Event_Date__c = System.Today()+5;
            newEvent.Event_Text__c = 'Sending Wish Child';
            //newEvent.Priority__c = String.valueOf(i);
            newEvent.RecordTypeId =  EventRecTypeId;
            newEvent.chapter__c = acc.id;
            eventList.add(newEvent);
            insert eventList;
            
            VolunteerLanding_AC controller = new VolunteerLanding_AC();
            controller.getChapterList();
            controller.getEvents();
            controller.EnterchapterPage();
            
        }
        
    }
    // Create custom setting value.
    static testmethod void CreateHoldChapterValue()
    {
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        User currUser;
        System.RunAs(new User(Id = UserInfo.getUserId()))
        {
            currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        }
        System.RunAs(currUser)
        {
            Dynamic_Content__c  createDynamicContent = OrientationandTrainingUtil.createDynamicContent();
            
            VolunteerLanding_AC controller = new VolunteerLanding_AC();
            controller.EnterchapterPage();
            
            
        }
    }
    
    // Display Promop upon login Training.
    static testmethod void checkBGandCOI()
    {
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        con.Broadcast_Number__c = '1234';
        update con;
        OrientationandTrainingUtil.createAffiliation(con.id);
        
        User currUser;
        System.RunAs(new User(Id = UserInfo.getUserId()))
        {
            currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        }
        VolunteerLanding_AC controller;
        System.RunAs(currUser)
        {
            
            Dynamic_Content__c  createProspectiveDynamicContent = OrientationandTrainingUtil.ChapterDynamicContent(acc.id);
            HoldCurrentChapter__c currVal = new HoldCurrentChapter__c();
            currVal.Name = currUser.id;
            currVal.CurrentChapter__c = acc.Name;
            insert currVal;
            
            Background_check__c currBG = OrientationandTrainingUtil.createBackgroundCheck(currUser.contactId);
            System.assert(currBg.id!=Null);
            
            Conflict_Of_Interest__c currCOI = OrientationandTrainingUtil.createCOI(con.id);
            currCOI.Expiration_Date__c  = System.Today()+5;
            COIRecordSharing(currUser.id,currCOI.id);
            update currCOI;
            
            
            
            Broadcast__c currBroad = new Broadcast__c();
            currBroad.Broadcast_Message__c = 'Test';
            currBroad.Date__c = Date.Today() + 5;
            currBroad.Chapter_Name__c = acc.id;
            currBroad.Active__c = true;
            insert currBroad;
            
            Role__c currRole = OrientationandTrainingUtil.createRole();
            Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
            Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
            
            Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
            currOandT.Prompt_upon_login__c = True;
            update currOandT;
            
            Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
            Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
            
            controller = new VolunteerLanding_AC();
            controller.getChapterList();
            controller.EnterchapterPage();
            controller.COICheck();
            controller.BackgroundCheck(false);
            controller.DisplayTraining(false);
            controller.register();
            controller.featuredImage = 'testImage';
            controller.featuredQuote = 'testQuote';
            controller.welcomeMsg = 'testWelcome';
            controller.headingTitle1 = 'testTitle1';
            controller.headingText1 = 'testText';
            controller.text1 = 'testText1';
            controller.text2 = 'testText2';
            controller.text3 = 'testText3';
            controller.title1 = 'testTitile1';
            controller.title2 = 'testTitle2';
            controller.title3 = 'testTitle3';
            controller.image1 = 'testImage1'           ;
            controller.image2 = 'testImage2';
            controller.image3 = 'testImage3';
            //controller.confirmBackGroundCheck();
            controller.cancel();
            controller.cancelConflict();
            OrientationandTrainingUtil.insertDocusignSetting();
            controller.TrainingAckCancel();
            Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
            Test.StartTest();
            controller.confirmConflict();
            Test.StopTest();
        }
        controller.broadCastCancel();
    }
    // Background verfication and New BroadCast policy created.
    static testmethod void checkBackgroundCheck()
    {
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        con.Broadcast_Number__c = '1234';
        update con;
        OrientationandTrainingUtil.createAffiliation(con.id);
        
        User currUser;
        System.RunAs(new User(Id = UserInfo.getUserId()))
        {
            currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        }
        VolunteerLanding_AC controller;
        System.RunAs(currUser)
        {
            
            Dynamic_Content__c  createProspectiveDynamicContent = OrientationandTrainingUtil.ChapterDynamicContent(acc.id);
            HoldCurrentChapter__c currVal = new HoldCurrentChapter__c();
            currVal.Name = currUser.id;
            currVal.CurrentChapter__c = acc.Name;
            insert currVal;
            
            Background_check__c currBG = OrientationandTrainingUtil.createBackgroundCheck(con.id);
            
            Broadcast__c currBroad = new Broadcast__c();
            currBroad.Broadcast_Message__c = 'Test';
            currBroad.Date__c = Date.Today() + 5;
            currBroad.Active__c = true;
            currBroad.Chapter_Name__c = acc.id;
            insert currBroad;
            
            Role__c currRole = OrientationandTrainingUtil.createRole();
            Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
            Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
            
            Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
            currOandT.Prompt_upon_login__c = True;
            update currOandT;
            
            Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
            Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
            
            controller = new VolunteerLanding_AC();
            controller.getChapterList();
            controller.EnterchapterPage();
            controller.COICheck();
            
            
        }
        controller.broadCastCancel();
    }
    // Background check and COI is interms of going to expired in 30 days.
    static testmethod void checkCOI()
    {
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        con.Broadcast_Number__c = '1234';
        update con;
        OrientationandTrainingUtil.createAffiliation(con.id);
        
        User currUser;
        System.RunAs(new User(Id = UserInfo.getUserId()))
        {
            currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        }
        VolunteerLanding_AC controller;
        System.RunAs(currUser)
        {
            
            Dynamic_Content__c  createProspectiveDynamicContent = OrientationandTrainingUtil.ChapterDynamicContent(acc.id);
            HoldCurrentChapter__c currVal = new HoldCurrentChapter__c();
            currVal.Name = currUser.id;
            currVal.CurrentChapter__c = acc.Name;
            insert currVal;
            
            Conflict_Of_Interest__c currCOI = OrientationandTrainingUtil.createCOI(con.id);
            currCOI.Expiration_Date__c  = System.Today()+5;
            COIRecordSharing(currUser.id,currCOI.id);
            update currCOI;
            
            Broadcast__c currBroad = new Broadcast__c();
            currBroad.Broadcast_Message__c = 'Test';
            currBroad.Date__c = Date.Today() + 5;
            currBroad.Chapter_Name__c = acc.id;
            currBroad.Active__c = true;
            insert currBroad;
            
            Role__c currRole = OrientationandTrainingUtil.createRole();
            Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
            Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
            
            Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
            currOandT.Prompt_upon_login__c = True;
            update currOandT;
            
            Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
            Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
            Volunteer_Orientation_Training__c  createVolOrientation = VolunteerLanding_AC_Test.createVolOrientation(currOandT.id,currOffering.id,con.id,'Registered');
            
            controller = new VolunteerLanding_AC();
            controller.getChapterList();
            controller.EnterchapterPage();
            controller.COICheck();
            
            
        }
        controller.broadCastCancel();
    }
    
    //Confict Of Interest Expired.
    static testmethod void checkCOIisExpired()
    {
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        
        User currUser;
        System.RunAs(new User(Id = UserInfo.getUserId()))
        {
            currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        }
        VolunteerLanding_AC controller;
        System.RunAs(currUser)
        {
            
            Dynamic_Content__c  createProspectiveDynamicContent = OrientationandTrainingUtil.ChapterDynamicContent(acc.id);
            HoldCurrentChapter__c currVal = new HoldCurrentChapter__c();
            currVal.Name = currUser.id;
            currVal.CurrentChapter__c = acc.Name;
            insert currVal;
            
            Conflict_Of_Interest__c currCOI = OrientationandTrainingUtil.createCOI(con.id);
            currCOI.Expiration_Date__c  = System.Today()-5;
            COIRecordSharing(currUser.id,currCOI.id);
            update currCOI;
            
            
            
            controller = new VolunteerLanding_AC();
            controller.getChapterList();
            controller.EnterchapterPage();
            controller.COICheck();
            
            
        }
        
    }
    // Backgroundcheck expired.
    static testmethod void checkBGisExpired()
    {
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        
        User currUser;
        System.RunAs(new User(Id = UserInfo.getUserId()))
        {
            currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        }
        VolunteerLanding_AC controller;
        System.RunAs(currUser)
        {
            
            Dynamic_Content__c  createProspectiveDynamicContent = OrientationandTrainingUtil.ChapterDynamicContent(acc.id);
            HoldCurrentChapter__c currVal = new HoldCurrentChapter__c();
            currVal.Name = currUser.id;
            currVal.CurrentChapter__c = acc.Name;
            insert currVal;
            
            Background_check__c currBG = OrientationandTrainingUtil.createBackgroundCheck(con.id);
            currBG.Date__c = Date.Today()-5;
            BGCRecordSharing(currUser.id,currBG.id);
            update currBG;
            
            controller = new VolunteerLanding_AC();
            controller.getChapterList();
            controller.EnterchapterPage();
            controller.COICheck();
            
            
        }
        
    }
    // Registered the Background Verfication.But Verifiation pending status.
    static testmethod void checkBGStatus()
    {
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        
        User currUser;
        System.RunAs(new User(Id = UserInfo.getUserId()))
        {
            currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        }
        VolunteerLanding_AC controller;
        System.RunAs(currUser)
        {
            
            Dynamic_Content__c  createProspectiveDynamicContent = OrientationandTrainingUtil.ChapterDynamicContent(acc.id);
            HoldCurrentChapter__c currVal = new HoldCurrentChapter__c();
            currVal.Name = currUser.id;
            currVal.CurrentChapter__c = acc.Name;
            insert currVal;
            
            Background_check__c currBG = OrientationandTrainingUtil.createBackgroundCheck(con.id);
            Background_check__c currBG1 = OrientationandTrainingUtil.createBackgroundCheck(con.id);
            Background_check__Share BGSharing = BGCRecordSharing(currUser.id,currBG.id);
            
            currBG.Date__c = Date.Today().addYears(3);
            BGCRecordSharing(currUser.id,currBG.id);
            update currBG;
            
            controller = new VolunteerLanding_AC();
            controller.getChapterList();
            controller.EnterchapterPage();
            controller.COICheck();
            
            
        }
        
    }
    
    // Creating Volunteer Traing based on the input parameter.
    static Volunteer_Orientation_Training__c createVolOrientation(Id OrienationId, Id ClassOfferingId,Id volunteer,string status)
    {
        Volunteer_Orientation_Training__c createNewVol = new Volunteer_Orientation_Training__c();
        createNewVol.class_offering__c = ClassOfferingId;
        createNewVol.Hidden_O_T_Id__c= OrienationId;
        createNewVol.Registered_Date__c = Date.Today();
        createNewVol.Volunteer__c = volunteer;
        createNewVol.Volunteer_Attendance__c = status;
        createNewVol.Type__c = 'Training';
        insert createNewVol;
        return createNewVol;
    }  
    
    
    Public Static Background_check__Share BGCRecordSharing(id userId, id recordId)
    {
        Background_check__Share currSharing = new Background_check__Share();
        User currUser = [SELECT id from User WHERE Profile.Name ='System Administrator' and isActive=True limit 1];
        System.RunAs(currUser)
        {
            
            currSharing.ParentId = recordId;
            currSharing.UserOrGroupId = userId;
            currSharing.AccessLevel = 'Edit';
            currSharing.RowCause = Schema.Background_check__Share.RowCause.Manual;
            insert currSharing;
        }
        return currSharing;
    }
    Public Static Conflict_Of_Interest__Share COIRecordSharing(id userId, id recordId)
    {
        Conflict_Of_Interest__Share currSharing = new Conflict_Of_Interest__Share();
        User currUser = [SELECT id from User WHERE Profile.Name ='System Administrator' and isActive=True limit 1];
        System.RunAs(currUser)
        {
            
            currSharing.ParentId = recordId;
            currSharing.UserOrGroupId = userId;
            currSharing.AccessLevel = 'Edit';
            currSharing.RowCause = Schema.Conflict_Of_Interest__Share.RowCause.Manual;
            insert currSharing;
        }
        return currSharing;
    }
}