public class WishBudgetForm_AC{
    
    public List<Wish_Expense_Transaction_Code__c> transactionCodes {get;set;}
    public List<Wish_Expense__c> expenseList;
    public String caseApproverStatus {get;set;}
    Public Boolean disableTcode {get;set;}
    Public String wishType {get;set;}
    public string expenseType {get;set;}
    public List<User> userList {get;set;}
    public String pageBlockMode {get;set;}
    public Id approverId {get;set;}
    public String newExpenseType {get;set;}
    public Id caseId {get;set;}
    public string antiWishType {get;set;}
    public List<Wish_Expense__c> wishExpenseList {get;set;}
    public Set<String> wishExpenseTypes {get;set;}
    Public Map<String,List<Wish_Expense_Transaction_Code__c>> TransCodesWrap{get;set;}
    Public Map<String,List<Wish_Expense__c>> wishExpensewrap{get;set;}
    Public Map<String, expenseSummarywrapper> SumExpensewrappers{get;set;}
    public expenseSummarywrapper TotalExpensewrappers{get;set;}
    public Map<String,SelectOption[]> TransCodeOptionsMap {get;set;}
    Public String wishChapterName {get; set;}   
    public List<Wish_Expense_Type_Tempate__c> ExpenseTypeTempList {get;set;}
    Map <string, List<String>> ExpenseTypeTempWrap {get;set;}
    Public Boolean approvalBtnVisibility {get;set;}
    public ApprovalList aSW {get;set;}
    Public List<Case> getPlanningAnticipationCase;
    public Id recordId {get;set;}
    public Id retURLRecordId {get;set;}
    public String ORG_LNK;
    Public String DeptDiv{get;set;}
    Constant_AC  constant = new Constant_Ac();    
    public Id budgetingRecordTypeId = Schema.Sobjecttype.Wish_Expense__c.getRecordTypeInfosByName().get(constant.budgetingRt).getRecordTypeId();
    public Id financeRecordTypeId = Schema.Sobjecttype.Wish_Expense__c.getRecordTypeInfosByName().get(constant.financeRt).getRecordTypeId();
    public boolean displayPopup {get; set;}
    public boolean UserIdentiy{get; set;}
    public String WEtypeExpand{get; set;}
    public String childName{get; set;}
    public Date AntWishDate{get; set;}
    public Integer NoOfWishParts{get; set;}
    public Boolean isbudgetApprovalExist{get; set;}
    public set<Id> participentSet;
    Id RecentApproverID;
    public String budgetNotes{get; set;}
    
    public WishBudgetForm_AC(ApexPages.StandardController controller) {
        
        RecentApproverID=null;
        UserIdentiy=false;
        isbudgetApprovalExist= false;
        caseApproverStatus = '';
        disableTcode = true;
        pageBlockMode ='detail';
        caseId = ApexPages.currentPage().getParameters().get('CaseId');
        WEtypeExpand=ApexPages.currentPage().getParameters().get('exp');
        System.debug('The parameter value is++++++++++'+caseId );
        retURLRecordId = caseId;
        participentSet = new Set<Id>();
        Constant_AC  constant = new Constant_Ac();    
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();
        system.debug('Wish P and A RecordTypeID :' + CaseId + '-' + wishPlanningRecordTypeId );
        getPlanningAnticipationCase = [SELECT Id, ParentId,Parent.Budget_Submitted_Date__c, Budget_Approval_Status__c FROM Case WHERE ParentId =: CaseId AND RecordTypeId =: wishPlanningRecordTypeId order by Createddate desc];
        system.debug('Wish P and A RecordTypeID 1:' + getPlanningAnticipationCase );
        recordId = getPlanningAnticipationCase.get(0).Id;
        caseApproverStatus = getPlanningAnticipationCase.get(0).Budget_Approval_Status__c;
        if(caseApproverStatus == 'Submitted') {
            approvalBtnVisibility = false;
        } else {
            approvalBtnVisibility = true;
        }
        
        //To check whether budget approval form is approved
        List<Case> caseList = [SELECT Id,Contact.FirstName,Contact.LastName, Contact.Middle_Name__c, Anticipated_Start_Date__c, isApprove__c,ChapterName__r.Name,Wish_Type__c, Budget_Notes__c FROM Case WHERE Id =: caseId];
        
        if(caseList.size() > 0) {
            wishChapterName = caseList.get(0).ChapterName__r.Name;
            antiWishType = caseList.get(0).Wish_Type__c;
            wishType= caseList.get(0).Wish_Type__c;
            AntWishDate=caseList.get(0).Anticipated_Start_Date__c;
            childName = caseList.get(0).Contact.FirstName + ' ' + (caseList.get(0).Contact.Middle_Name__c !=null ? caseList.get(0).Contact.Middle_Name__c : '') + ' ' + caseList.get(0).Contact.LastName;
            List<Account> accountList = [SELECT ID,Department_Division__c FROM Account WHERE Name =: wishChapterName];
            DeptDiv=accountList.get(0).Department_Division__c;
            budgetNotes=caseList.get(0).Budget_Notes__c;
           
        }
        
      if(caseList[0].ContactId != Null){
          for(npe4__Relationship__c currrentRlationShip : [SELECT ID,npe4__Contact__c,npe4__RelatedContact__c,Wish_Participant__c,Non_Comped__c FROM npe4__Relationship__c 
                                                             WHERE npe4__Contact__c =:caseList[0].ContactId AND Wish_Participant__c =: true AND Non_Comped__c =: false]){
                       
                       participentSet.add(currrentRlationShip.npe4__RelatedContact__c);
             
             }
             
            if(participentSet.size() > 0){
                NoOfWishParts = participentSet.size() + 1;
            }
         
      }    
      
      /*List<Wish_Child_Form__c> childPartic = [SELECT Id, Participant_Contacts__c FROM Wish_Child_Form__c WHERE Case__c =: caseId];*/
        
       /* if(childPartic != null & childPartic.size() >0 ){
            if(childPartic[0].Participant_Contacts__c != Null)
            {
               String[] currString = childPartic[0].Participant_Contacts__c.split('<br>'); 
               NoOfWishParts =  currString.size();              
            }
        }*/
        
       
        
        // wishExpense= new Map<String,expensewrapper>();
        wishExpensewrap=new Map<String,List<Wish_Expense__c>>();
        TransCodesWrap = new Map<String,List<Wish_Expense_Transaction_Code__c>>();
        TransCodeOptionsMap = new Map<String,List<SelectOption>>();
        wishExpenseTypes= new Set<String>();
        
        LoadData();
        summary();
        Totalsummary();
        System.debug('Final Data is:'+ SumExpensewrappers );
        ORG_LNK = 'https://'+URL.getSalesforceBaseUrl().getHost();
        if(!String.isBlank(recordID)){
            aSW = new ApprovalList();
            aSW = generateData();
        } 
        
        List<User> useriden = [SELECT Id, Name, Profile.Name FROM User WHERE Id=: UserInfo.getUserId()];
        if(useriden !=null){
            User userdata=useriden[0];
            
            if( caseApproverStatus == 'Submitted'){
               
                //String strAppvalName = aSW.approvals[0].listOfSteps[0].OriginalActor.Name;
                //Id strAppvalName = aSW.approvals[0].listOfSteps[0].ActorId;
                if(RecentApproverID!= null)
                {
                   //if(userdata.Id == strAppvalName ){
                   if(userdata.Id == RecentApproverID){
                        UserIdentiy=false;
                    }
                    else{
                        UserIdentiy=true;
                    }
                } 
            } 
         }
    }
    
    public void LoadData() {
        
        if(wishExpensewrap.size() > 0)
            wishExpensewrap.clear();
        if(TransCodeOptionsMap.size() > 0)
            TransCodeOptionsMap.clear();
        for(Wish_Expense_Transaction_Code__c  currtransactionCode :  [SELECT Id, Name,Wish_Expense_Type__r.Name from Wish_Expense_Transaction_Code__c Where Is_Active__c =true order by Name]){
            if(!TransCodesWrap.containsKey(currtransactionCode.Wish_Expense_Type__r.Name )){
                TransCodesWrap.put(currtransactionCode.Wish_Expense_Type__r.Name,new List<Wish_Expense_Transaction_Code__c >{currtransactionCode});    
            }else{
                TransCodesWrap.get(currtransactionCode.Wish_Expense_Type__r.Name ).add(currtransactionCode ); 
            }
            SelectOption obj;
            if(!TransCodeOptionsMap.containsKey(currtransactionCode.Wish_Expense_Type__r.Name )){
                obj = new SelectOption(currtransactionCode.Id,currtransactionCode.Name);
                
                TransCodeOptionsMap.put(currtransactionCode.Wish_Expense_Type__r.Name,new List<SelectOption>{obj});    
            }else{
                obj = new SelectOption(currtransactionCode.Id,currtransactionCode.Name);
                TransCodeOptionsMap.get(currtransactionCode.Wish_Expense_Type__r.Name).add(obj); 
            }
        }
        
        System.debug('wishExpenseList Size 2.2:' + TransCodesWrap);
        
         System.debug('wishExpenseList Size 1:' + caseId);
        wishExpenseList =  [SELECT Id, Wish_Expense_Transaction_Code__r.Wish_Expense_Type__r.Name, 
                            Wish_Expense_Transaction_Code__c,
                            Wish_Expense_Transaction_Code__r.Name,
                            Post_Date__c,
                            Transaction__c,
                            Account_Number__c,
                            Account_Description__c,
                            Department_Division__c,
                            Journal_Reference__c,
                            Budget_Cash__c,
                            Budget_In_Kind__c,
                            Projected_Cash__c,
                            Projected_In_Kind__c,
                            Actual_Cash__c,RecordType.Name,
                            Actual_In_Kind__c,Wish_Expense_Approval_Status__c,Budget_Approval_Status__c,Projected_Approval_Status__c,
                            FE_Posted_Cash__c,
                            FE_Posted_In_Kind__c,
                            Case__c
                            FROM Wish_Expense__c WHERE Case__c =:caseId Order by Wish_Expense_Transaction_Code__r.Wish_Expense_Type__r.Name,RecordType.Name, CreatedDate];
        
        System.debug('wishExpenseList Size 1:' + wishExpenseList.size());
        if(wishExpenseList.size() <= 0){
            LoadTemplates();
            System.debug('wishExpenseList Size 2:' +wishExpensewrap);
        }
        string accDesc;
        for(Wish_Expense__c expense : wishExpenseList){
            
            wishExpenseTypes.add(expense.Wish_Expense_Transaction_Code__r.Wish_Expense_Type__r.Name);
            if(!wishExpensewrap.containsKey(expense.Wish_Expense_Transaction_Code__r.Wish_Expense_Type__r.Name )){
                wishExpensewrap.put(expense.Wish_Expense_Transaction_Code__r.Wish_Expense_Type__r.Name, new List<Wish_Expense__c>{expense});    
            }else{
                wishExpensewrap.get(expense.Wish_Expense_Transaction_Code__r.Wish_Expense_Type__r.Name).add(expense); 
            } 
            if(expense.Budget_Approval_Status__c == 'Approved'){
                isbudgetApprovalExist=true;
            }
                       
        }
        
       
    }
    
   /* public string transCodeid {get;set;}
    public string expenseTypekey {get;set;}
    public void RemoveWrapper() {
        integer index = -1;
        //Id transId = Id.valueOf(transCodeid ); 
        List<Wish_Expense__c> wrappers= new List<Wish_Expense__c>();
        for (String type: wishExpensewrap.keySet()){
            wrappers.addall(wishExpensewrap.get(type));
        }
        for(Wish_Expense__c wrapper : wrappers){
            
            if(wrapper.Wish_Expense_Transaction_Code__c == transCodeid ){
                index = index +1;
            }
        }
        wrappers.remove(index );
    } */
    
    public List<SelectOption> getWishExpenceTypes() {    
        List<SelectOption> options =  new List<SelectOption>();    
        options.add(new selectOption('','--- None ---'));
        for(String tcode: TransCodesWrap.keySet() ) {
            options.add(new selectOption(tcode,tcode));                    
        }    
        return Options;    
    }
    
    public List<SelectOption> getDeptDivisions(){
        List<SelectOption> options =  new List<SelectOption>();    
          if(DeptDiv != null)
          {
            String[] depts= DeptDiv.split(',') ; 
            options.add(new selectOption('--None--','--None--'));
            for(String dept: depts) {
                options.add(new selectOption(dept,dept));                    
            }    
          }
        return Options;
    
    }
    
     public List<SelectOption> getAccountDescs(){
        List<SelectOption> options =  new List<SelectOption>(); 
        Schema.DescribeFieldResult fieldResult = Wish_Expense__c.Account_Description__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--', '--None--'));
        for( Schema.PicklistEntry f : ple)
        {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
        }          
          
        return Options;
    
    }
    public PageReference addExpenseType() {
        
        WEtypeExpand=null;
        if(newExpenseType != null) {
            wishExpenseTypes.add(newExpenseType);
            System.debug('Test add expence 1:' + newExpenseType );
            List<Wish_Expense_Transaction_Code__c> transListType = TransCodesWrap.get(newExpenseType);
            System.debug('Test add expence 1:' + TransCodesWrap);
            
            Wish_Expense__c curExpense=new Wish_Expense__c();
            curExpense.Wish_Expense_Transaction_Code__c = TransCodesWrap.get(newExpenseType).get(0).Id;
            for(Wish_Expense_Transaction_Code__c trans: transListType){
                if(trans.Name.contains('Other')){
                    curExpense.Wish_Expense_Transaction_Code__c = trans.Id;
                    break;
                }
            }
            curExpense.Case__c =caseId ;
            if(isbudgetApprovalExist || caseApproverStatus == 'Submitted'){
             curExpense.Budget_Approval_Status__c = 'Submitted';
            }
            if(!wishExpensewrap.containsKey(newExpenseType)){
                wishExpensewrap.put(newExpenseType, new List<Wish_Expense__c>{curExpense}); 
            }else{
                wishExpensewrap.get(newExpenseType).add(curExpense);
            } 
            saveWishExpenses();
            LoadData();
            summary();
            Totalsummary();
            WEtypeExpand= wishExpensewrap.size() - 1 + 'collapsed';
        }
        
        PageReference pageRef = new PageReference('/apex/WishBudgetForm_VF?caseId='+caseId);
        //pageRef.setRedirect(True);
        return pageRef;
    }
    
    public void LoadTemplates()
    {
        List<Wish_Expense_Transaction_Code__c> transListT;
        for(Wish_Expense_Type_Tempate__c template : [SELECT Id, Name, Wish_Expense_Type__r.Name from Wish_Expense_Type_Tempate__c where Wish_Type__c =: wishType order by Wish_Expense_Type__r.Name]){
        
            wishExpenseTypes.add(template.Wish_Expense_Type__r.Name);
            Wish_Expense__c curExpense = new Wish_Expense__c();
            curExpense.Wish_Expense_Transaction_Code__c =TransCodesWrap.get(template.Wish_Expense_Type__r.Name).get(0).Id;
            transListT= TransCodesWrap.get(template.Wish_Expense_Type__r.Name);
            for(Wish_Expense_Transaction_Code__c trans: transListT){
                if(trans.Name.contains('Other')){
                    curExpense.Wish_Expense_Transaction_Code__c = trans.Id;
                    break;
                }
            }
            curExpense.Case__c =caseId ;
            if(!wishExpensewrap.containsKey(template.Wish_Expense_Type__r.Name)){
                wishExpensewrap.put(template.Wish_Expense_Type__r.Name, new List<Wish_Expense__c>{curExpense});    
            }else{
                wishExpensewrap.get(template.Wish_Expense_Type__r.Name).add(curExpense); 
            }
            transListT=null;  
            system.debug('Tansaction Code 1.11:' + curExpense); 
        } 
         system.debug('Tansaction Code 1.11:' + wishExpensewrap);
    }
    
    public PageReference addExpense() {
        //WEtypeExpand='1collapsed';
        //expenseType= apexpages.currentpage().getParameters().get('expenseType');
        //WEtypeExpand=apexpages.currentpage().getParameters().get('WEtypeExpand');
        system.debug('Tansaction Code 1:' + TransCodesWrap);
        system.debug('Tansaction Code 2:' + expenseType);
        system.debug('Tansaction Code 3:' + WEtypeExpand);
        List<Wish_Expense_Transaction_Code__c> transListW= TransCodesWrap.get(expenseType);
        if(transListW == null){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'There is no active transaction code is available for ' + expenseType + '.' );
             
             ApexPages.addMessage(myMsg);
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There is no active transaction code is available for ' + expenseType + '.'));
            return null;
        }
        system.debug('Tansaction Code 1:' + transListW);
        Wish_Expense__c curExpense = new Wish_Expense__c();
        system.debug('Tansaction Code 1:' + TransCodesWrap.get(expenseType).get(0).Id);
        curExpense.RecordTypeid = budgetingRecordTypeId;
        curExpense.Wish_Expense_Transaction_Code__c = TransCodesWrap.get(expenseType).get(0).Id;
        for(Wish_Expense_Transaction_Code__c trans: transListW){
            if(trans.Name.contains('Other')){
                curExpense.Wish_Expense_Transaction_Code__c = trans.Id;
                break;
            }
        }
        //curExpense.Wish_Expense_Transaction_Code__c = TransCodesWrap.get(expenseType).get(0).Id;
        curExpense.Case__c =caseId ;
         system.debug('Tansaction Code 111:' + isbudgetApprovalExist);
         system.debug('Tansaction Code 111:' + caseApproverStatus );
        if(isbudgetApprovalExist || caseApproverStatus == 'Submitted'){
         curExpense.Budget_Approval_Status__c = 'Submitted';
        }
        if(!wishExpensewrap.containsKey(expenseType)){
           
            wishExpensewrap.put(expenseType, new List<Wish_Expense__c>{curExpense});    
        }else{
            wishExpensewrap.get(expenseType).add(curExpense); 
        } 
        
        saveWishExpenses();
        LoadData();
        summary();
        Totalsummary();
        //PageReference pageRef = new PageReference('/apex/WishBudgetForm_VF?caseId='+caseId + '&exp=' + WEtypeExpand);
        PageReference pageRef = new PageReference('/apex/WishBudgetForm_VF');
        //PageReference pageRef= SaveExpenses();
        pageRef.setRedirect(True);
        pageRef.getParameters().put('caseId',caseId);
        pageRef.getParameters().put('exp',WEtypeExpand);
        return pageRef ;
        //return null;
        
             
    }
 
    public List<SelectOption> getUserListForApproval() {
        Set<Id> userIdsSet = new Set<Id>();
        Set<Id> userDupCheck = new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String chapterGroup;
        if(wishChapterName != null) {
            chapterGroup = wishChapterName.removeStart('Make-A-Wish ');
            for(GroupMember getGroupUsers : [Select Id, UserOrGroupId From GroupMember Where Group.Name =: chapterGroup]) {
                if(((String)getGroupUsers.UserOrGroupId).startsWith(userType)) {
                    userIdsSet.add(getGroupUsers.UserOrGroupId);
                }
            }
            userList = [SELECT Id,Name, Profile.Name, UserRole.Name FROM User WHERE Id IN : userIdsSet AND ContactId = null AND IsActive=true  ];
            //userList = [SELECT Id,Name, Profile.Name, UserRole.Name FROM User WHERE ((Id IN : userIdsSet AND Profile.Name != 'Active Volunteer') OR UserRole.Name = 'National Staff' ) AND IsActive=true  ];
        } else {
            //userList = [SELECT Id, Name, Profile.Name, UserRole.Name FROM User WHERE (UserRole.Name = 'National Staff' OR Profile.Name = 'System Administrator') AND IsActive=true];
        }
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Select Approver'));
        options.add(new SelectOption(UserInfo.getUserId(),UserInfo.getName()));
        userDupCheck.add(UserInfo.getUserId());
        for(User approvalUser : userList) {
            if(!userDupCheck.contains(approvalUser.Id)) {
                options.add(new SelectOption(approvalUser.Id,approvalUser.Name));
            }
        }
        return options;
    }
    
    
    
    /* This method is used to submit wish budget form for approval to Wish Coordinator. If Projected Cash and Projected Inkind are blank then we will
assign Budget Cash and Budget InKind to Projected Cash and Projected InKind before records goes for approval. Once the form is submitted for approval 
them we will make all fields as Read Only except T-Code and Projected fields.*/
    public void submitForApproval() {
        List<Case> casebudgetapprovals = new List<Case>();
        Set<Id> approvedCaseIds = new Set<Id>();
        String budgetStatus='';
        String projectedStatus='';
        System.debug('Save wrappers2:');
        saveWishExpenses();
        System.debug('>>>>>>>>>>approverId>>>>>>>>>>>>>>>'+approverId);
        List<Wish_Expense__c> recordApprovalStatusUpdateList = new List<Wish_Expense__c>();
        for(Wish_Expense__c updateWishExpenseStatus : [SELECT Id, Case__c, Budget_Approval_Status__c,Projected_Approval_Status__c, Wish_Expense_Approval_Status__c FROM Wish_Expense__c WHERE Case__c =: caseId]) {
            //updateWishExpenseStatus.Wish_Expense_Approval_Status__c = 'Initiated';
            if(updateWishExpenseStatus.Budget_Approval_Status__c == 'Approved'){
                budgetStatus= 'Approved';
            }
            else if(updateWishExpenseStatus.Budget_Approval_Status__c != 'Approved' ){
               updateWishExpenseStatus.Budget_Approval_Status__c = 'Submitted';
               if(budgetStatus!= 'Approved'){
                   budgetStatus= 'Submitted';
               }
            }
           
             if((isbudgetApprovalExist == true && updateWishExpenseStatus.Budget_Approval_Status__c == 'Submitted') || updateWishExpenseStatus.Budget_Approval_Status__c == 'Approved' ){
                if(updateWishExpenseStatus.Projected_Approval_Status__c != 'Approved'){
                   updateWishExpenseStatus.Projected_Approval_Status__c= 'Submitted';
                   projectedStatus= 'Submitted';
                }
            }
            recordApprovalStatusUpdateList.add(updateWishExpenseStatus);
            if(!approvedCaseIds.contains(updateWishExpenseStatus.Case__c)){
                approvedCaseIds.add(updateWishExpenseStatus.Case__c);
            }
        }
        system.debug('Wish P and A recordApprovalStatusUpdateList: - ' + recordApprovalStatusUpdateList);
        
        if(recordApprovalStatusUpdateList.size() > 0) {
            system.debug('Wish P and A recordApprovalStatusUpdateList: - ' + recordApprovalStatusUpdateList);

            update recordApprovalStatusUpdateList;
        }
        
        if(approverId != null && getPlanningAnticipationCase.get(0).Id != null) {
           
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            /*if(budgetNotes.length()>0){
                req.setComments(budgetNotes);
            }
            else{
                req.setComments('Approval for Wish Budget form');
            }*/
            req.setComments('Approval for Wish Budget form');
            req.setObjectId(getPlanningAnticipationCase.get(0).Id);
            req.setProcessDefinitionNameOrId('Case_Budget_Approval_Form');
            req.setNextApproverIds(new Id[]{approverId});
            req.setSkipEntryCriteria(true);
            Approval.ProcessResult result = Approval.process(req);
            displayPopup = true;
           
            
        }
        
        if(getPlanningAnticipationCase.get(0).Parent.Budget_Submitted_Date__c == Null)
        {
                Case updateCase = new Case();
                updateCase.id = getPlanningAnticipationCase.get(0).ParentId;
                updateCase.Budget_Submitted_Date__c = Date.Today();
                update updateCase;
        }
        
        if(budgetStatus=='Submitted' || projectedStatus== 'Submitted'){
            for(Id tempId : approvedCaseIds ){
                Case approvedCase = new Case();
                approvedCase.Id= tempId;
                if(budgetStatus=='Submitted')
                    approvedCase.Budget_Status__c=budgetStatus;
                if(projectedStatus== 'Submitted')
                   approvedCase.Projected_Status__c=projectedStatus; 
                casebudgetapprovals.add(approvedCase);       
            }
            update casebudgetapprovals;
        }        
    }
    
    public PageReference SaveExpenses() {
        System.debug('Save wrappers1:');
        saveWishExpenses();
        LoadData();
        summary();
        Totalsummary();
        
        PageReference pageRef = new PageReference('/apex/WishBudgetForm_VF?caseId='+caseId);
        pageRef.setRedirect(True);
        return pageRef;
    }
    
    public PageReference ReloadPage() {
        System.debug('Save wrappers1:');
        PageReference pageRef = new PageReference('/apex/WishBudgetForm_VF?caseId='+caseId);
        pageRef.setRedirect(True);
        return pageRef;
    }
    
    
    public void saveWishExpenses(){
        List<Wish_Expense__c> wrappers= new List<Wish_Expense__c>();
        for (String type: wishExpensewrap.keySet()){
            wrappers.addall(wishExpensewrap.get(type));
        }
        List<Wish_Expense__c> wishexpenses = new List<Wish_Expense__c>();
        System.debug('Save wrappers3:'+wishExpensewrap);
        
        case caseNotes=  new Case();
        caseNotes.Id=caseId;
        caseNotes.Budget_Notes__c= budgetNotes;
        update caseNotes;
        
        for(Wish_Expense__c wrapper : wrappers){
            Wish_Expense__c expense = new Wish_Expense__c();
            if(wrapper.id != Null)
            {
                expense.id = wrapper.id;
            }
            else
            {
                expense.RecordTypeid = budgetingRecordTypeId;
            }
            
            expense.Case__c =caseId;
            
            expense.Wish_Expense_Transaction_Code__c =wrapper.Wish_Expense_Transaction_Code__c ;
            if(wrapper.Account_Description__c != '--None--'){
                expense.Account_Description__c =wrapper.Account_Description__c ;
            }
            if(wrapper.Department_Division__c != '--None--'){
                expense.Department_Division__c =wrapper.Department_Division__c;
            }
            expense.Account_Number__c =wrapper.Account_Number__c ;
            expense.Post_Date__c =wrapper.Post_Date__c ;
            expense.Transaction__c =wrapper.Transaction__c ;
            expense.Journal_Reference__c =wrapper.Journal_Reference__c;
            expense.Budget_Cash__c =wrapper.Budget_Cash__c;
            expense.Budget_In_Kind__c =wrapper.Budget_In_Kind__c;
            expense.Projected_Cash__c =wrapper.Projected_Cash__c;
            expense.Projected_In_Kind__c =wrapper.Projected_In_Kind__c;
            expense.Actual_Cash__c =wrapper.Actual_Cash__c;
            expense.Actual_In_Kind__c =wrapper.Actual_In_Kind__c;
            expense.FE_Posted_Cash__c=wrapper.FE_Posted_Cash__c;
            expense.FE_Posted_In_Kind__c=wrapper.FE_Posted_In_Kind__c;
            expense.Budget_Approval_Status__c = wrapper.Budget_Approval_Status__c;
            expense.Projected_Approval_Status__c= wrapper.Projected_Approval_Status__c;
            //if(expense.Budget_Cash__c != 0 || expense.Budget_In_Kind__c != 0 || expense.Projected_Cash__c != 0 
            //   || expense.Projected_In_Kind__c != 0 || expense.Actual_Cash__c != 0 || expense.Actual_In_Kind__c != 0)
            //{ 
                wishexpenses.add(expense);
           // }
        }
        
        if(wishexpenses.size()>0){
            upsert wishexpenses;
        }
        
        
    }
    
    public void summary() {
        List<Wish_Expense__c> wrappers= new List<Wish_Expense__c>();
        SumExpensewrappers = new Map<String, expenseSummarywrapper>();
        
        Decimal totalBudCash=0;
        Decimal totalProjcash=0;
        Decimal totalActCash=0;
        Decimal totalBudInKind=0;
        Decimal totalProjInKind=0;
        Decimal totalActInKind=0;
        Decimal totalFEPCash=0;
        Decimal totalFEPInKind=0;
        Double Decrease;
        for (String type: wishExpensewrap.keySet()){
            expenseSummarywrapper sumWrap = new expenseSummarywrapper();
            for(Wish_Expense__c wrapper: wishExpensewrap.get(type)){
                
                if(wrapper.Budget_Cash__c == Null)
                    wrapper.Budget_Cash__c = 0;
                if(wrapper.Budget_In_Kind__c == Null)
                    wrapper.Budget_In_Kind__c = 0;
                if(wrapper.Projected_Cash__c== Null)
                    wrapper.Projected_Cash__c= 0;
                if(wrapper.Projected_In_Kind__c== Null)
                    wrapper.Projected_In_Kind__c= 0;
                if(wrapper.Actual_Cash__c== Null)
                    wrapper.Actual_Cash__c= 0;
                if(wrapper.Actual_In_Kind__c  == Null)
                    wrapper.Actual_In_Kind__c   = 0;
                if(wrapper.FE_Posted_Cash__c== Null)
                    wrapper.FE_Posted_Cash__c= 0;
                if(wrapper.FE_Posted_In_Kind__c== Null)
                    wrapper.FE_Posted_In_Kind__c= 0;      
                
                sumWrap.sumBudgetCash = sumWrap.sumBudgetCash + wrapper.Budget_Cash__c;
                sumWrap.sumBudgetInKind= sumWrap.sumBudgetInKind + wrapper.Budget_In_Kind__c;
                sumWrap.sumProjectedCash= sumWrap.sumProjectedCash + wrapper.Projected_Cash__c;
                sumWrap.sumprojectedInkind= sumWrap.sumprojectedInkind+ wrapper.Projected_In_Kind__c;
                sumWrap.sumActualCash = sumWrap.sumActualCash+ wrapper.Actual_Cash__c;
                sumWrap.sumActualInKind= sumWrap.sumActualInKind+ wrapper.Actual_In_Kind__c  ;
                if(wrapper.FE_Posted_Cash__c!= null){
                    sumWrap.sumFEPostedCash = sumWrap.sumFEPostedCash + wrapper.FE_Posted_Cash__c;
                }
                if(wrapper.FE_Posted_In_Kind__c != null){
                    sumWrap.sumFEPostedInKind = sumWrap.sumFEPostedInKind + wrapper.FE_Posted_In_Kind__c;
                }
                
                
            }
            
            totalBudCash=sumWrap.sumBudgetCash;
            totalProjcash=sumWrap.sumProjectedCash;
            totalActCash=sumWrap.sumActualCash;
            totalFEPCash=sumWrap.sumFEPostedCash;
            totalBudInKind=sumWrap.sumBudgetInKind;
            totalProjInKind=sumWrap.sumprojectedInkind;
            totalActInKind=sumWrap.sumActualInKind;
            totalFEPInKind=sumWrap.sumFEPostedInKind;
            if(totalBudCash + totalBudInKind >0 &&  totalProjcash + totalProjInKind >0 )
            {
                Decrease= (totalProjcash+ totalProjInKind) - (totalBudCash + totalBudInKind);
                Decrease= (Decrease/ (totalBudCash + totalBudInKind))*100;
                sumWrap.sumBtoPDiff=Decrease.round();
            }
            /*if(totalProjcash+ totalProjInKind>0 && totalFEPCash+ totalFEPInKind>0)
            {
               Decrease=  (totalActCash+ totalActInKind) -(totalProjcash+ totalProjInKind) ;
               Decrease= (Decrease/ (totalActCash+ totalActInKind))*100;
               sumWrap.sumAtoFEPDiff=Decrease.round();
            }*/
            //sumWrap.sumBtoPDiff = (totalBudCash + totalBudInKind) - (totalProjcash + totalProjInKind);
            sumWrap.sumAtoFEPDiff=(totalFEPCash+ totalFEPInKind) - (totalActCash+ totalActInKind);
            SumExpensewrappers.put(type, sumWrap);
            
        }
        
    }
    
    public PageReference removeExpense(){
        WEtypeExpand=null;
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        System.debug('index>>>>>>>>'+indexVal);
        String expenType = system.currentpagereference().getparameters().get('expenType');
        //List<Wish_Expense__c> expenseList = new List<Wish_Expense__c>();
        expenseList = wishExpensewrap.get(expenType);
        
        System.debug('indexVal+++++++++++++++++++++++++= ' + indexVal);
        System.debug('expenType+++++++++++++++++++++++++= ' + expenType);
        System.debug('expenseList+++++++++++++++++++++++++ = ' + expenseList);
        //Remove the contact from the table    
        // expenseList.remove(indexVal);  
        if(expenseList.size() > 0 && expenseList[indexVal].Id !=null){
            Delete expenseList[indexVal];
        }
        else{
            expenseList[indexVal].clear();
        }
      
            
        PageReference pageRef = new PageReference('/apex/WishBudgetForm_VF?caseId='+caseId);
        pageRef.setRedirect(True);
        return pageRef;           
    }   
    
    public void Totalsummary() {
        Decimal totalBudCash=0;
        Decimal totalProjcash=0;
        Decimal totalActCash=0;
        Decimal totalBudInKind=0;
        Decimal totalProjInKind=0;
        Decimal totalActInKind=0;
        Decimal totalFEPCash=0;
        Decimal totalFEPInKind=0;
        Double Decrease;
        expenseSummarywrapper sumWrap = new expenseSummarywrapper();
        List<Wish_Expense__c> wrappers= new List<Wish_Expense__c>();
        for (String type: wishExpensewrap.keySet()){
            wrappers.addall(wishExpensewrap.get(type));
        }
        
        for(Wish_Expense__c  wrapper : wrappers){
            
            if(wrapper.Budget_Cash__c == Null)
                wrapper.Budget_Cash__c = 0;
            if(wrapper.Budget_In_Kind__c == Null)
                wrapper.Budget_In_Kind__c = 0;
            if(wrapper.Projected_Cash__c== Null)
                wrapper.Projected_Cash__c= 0;
            if(wrapper.Projected_In_Kind__c== Null)
                wrapper.Projected_In_Kind__c= 0;
            if(wrapper.Actual_Cash__c== Null)
                wrapper.Actual_Cash__c= 0;
            if(wrapper.Actual_In_Kind__c  == Null)
                wrapper.Actual_In_Kind__c   = 0;
            if(wrapper.FE_Posted_Cash__c== Null)
                wrapper.FE_Posted_Cash__c= 0;
            if(wrapper.FE_Posted_In_Kind__c== Null)
                wrapper.FE_Posted_In_Kind__c= 0;   
            
            sumWrap.sumBudgetCash = sumWrap.sumBudgetCash + wrapper.Budget_Cash__c;
            sumWrap.sumBudgetInKind= sumWrap.sumBudgetInKind + wrapper.Budget_In_Kind__c;
            sumWrap.sumProjectedCash= sumWrap.sumProjectedCash + wrapper.Projected_Cash__c;
            sumWrap.sumProjectedInkind= sumWrap.sumprojectedInkind+ wrapper.Projected_In_Kind__c ;
            sumWrap.sumActualCash = sumWrap.sumActualCash+ wrapper.Actual_Cash__c;
            sumWrap.sumActualInKind= sumWrap.sumActualInKind+ wrapper.Actual_In_Kind__c   ;
            if(wrapper.FE_Posted_Cash__c!= null){
                sumWrap.sumFEPostedCash = sumWrap.sumFEPostedCash + wrapper.FE_Posted_Cash__c;
            }
            if(wrapper.FE_Posted_In_Kind__c!= null){
                sumWrap.sumFEPostedInKind = sumWrap.sumFEPostedInKind + wrapper.FE_Posted_In_Kind__c;
            }
        }
        
        totalBudCash=sumWrap.sumBudgetCash;
        totalProjcash=sumWrap.sumProjectedCash;
        totalActCash=sumWrap.sumActualCash;
        totalFEPCash=sumWrap.sumFEPostedCash ;
        totalBudInKind=sumWrap.sumBudgetInKind;
        totalProjInKind=sumWrap.sumprojectedInkind;
        totalActInKind=sumWrap.sumActualInKind;
        totalFEPInKind=sumWrap.sumFEPostedInKind ;
        if(totalBudCash + totalBudInKind >0 &&  totalProjcash+ totalProjInKind>0 )
        {
            Decrease= (totalProjcash+ totalProjInKind) - (totalBudCash + totalBudInKind);
            Decrease= (Decrease/ (totalBudCash + totalBudInKind))*100;
            sumWrap.sumBtoPDiff=Decrease.round();
        }
        /*if(totalProjcash+ totalProjInKind>0 && totalActCash+ totalActInKind >0)
        {
           
            Decrease=  (totalActCash+ totalActInKind) -(totalProjcash+ totalProjInKind) ;
            Decrease= (Decrease/ (totalActCash+ totalActInKind))*100;
            sumWrap.sumAtoFEPDiff=Decrease.round();
        }*/
        //sumWrap.sumBtoPDiff=(totalBudCash + totalBudInKind) - (totalProjcash+ totalProjInKind) ;
        sumWrap.sumAtoFEPDiff= (totalFEPCash+ totalFEPInKind) - (totalActCash+ totalActInKind);
        TotalExpensewrappers=sumWrap;
     
    }
    ApprovalList generateData(){
        ApprovalList approvalResultForObject = new ApprovalList();
        List<ApprovalStepWrapper> aSW = new List<ApprovalStepWrapper>();
        String recallApprovalProcessLink;
        Boolean isSubmitForApproval = true;
        for(ProcessInstance pI:getProcessHistory(recordId).values()){
            Map<Id,List<ProcessInstanceHistory>> mapOfProcessNodeIdAndProcessInstanceHistory = new Map<Id,List<ProcessInstanceHistory>>();
            Set<Id> processNodeId= new Set<Id>(); 
            
            for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems){
                if(processNodeId.size() ==0)
                    processNodeId.add(sWI.ProcessNodeId);
                else if(processNodeId.size()>0 && processNodeId.contains(sWI.ProcessNodeId)!= NULL)
                    processNodeId.add(sWI.ProcessNodeId);
            }
            
            for(Id pNId: processNodeId){
                ApprovalStepWrapper aSWr = new ApprovalStepWrapper();
                for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems){
                    if(sWI.processNodeId == pNID){
                        aSWr.listOfSteps.add(sWI);
                    }
                    if(sWI.StepStatus == 'Pending'){
                        aSWr.workItemApproveOrRejectLink = ORG_LNK+'/p/process/ProcessInstanceWorkitemWizardStageManager?id='+sWI.Id;
                        aSWr.workItemReassignLink =  ORG_LNK+'/'+sWI.Id+'/e?et=REASSIGN&retURL=/'+retURLRecordId;
                        recallApprovalProcessLink =  ORG_LNK +'/'+sWI.Id+'/e?et=REMOVE&retURL=/'+retURLRecordId;
                        isSubmitForApproval = false;
                        RecentApproverID =sWI.OriginalActorId;
                    }
                    
                }
                aSW.add(aSWr);
            }
        }
        approvalResultForObject.approvals = aSW;
        approvalResultForObject.recordId = recordId;
        approvalResultForObject.isSubmitForApproval = isSubmitForApproval;
        approvalResultForObject.recallApprovalProcessLink = recallApprovalProcessLink;
        return approvalResultForObject;
    }
    public Map<Id,ProcessInstance> getProcessHistory(Id objectId){
        return new Map<Id,ProcessInstance>([SELECT Id, (SELECT ID, ProcessNodeId,
                                                        StepStatus,Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending
                                                        ,OriginalActorId,ProcessInstanceId,RemindersSent,CreatedDate, Actor.Name,
                                                        OriginalActor.Name , ProcessNode.Name FROM StepsAndWorkitems order by CreatedDate DESC, StepStatus) 
                                            FROM ProcessInstance where TargetObjectId =:objectId order by CreatedDate desc  ]);
    }
    public class ApprovalStepWrapper{
        public String workItemApproveOrRejectLink {get;set;}
        public String workItemReassignLink {get;set;}
        public List<ProcessInstanceHistory> listOfSteps {get;set;}
        public ApprovalStepWrapper(){
            listOfSteps = new  List<ProcessInstanceHistory>();
        }
    }
    
    public class ApprovalList{
        public List<ApprovalStepWrapper> approvals {get;set;}
        public String recallApprovalProcessLink {get;set;}
        public Boolean isSubmitForApproval {get;set;}
        public Id recordId {get;set;}
        public ApprovalList(){
            approvals = new List<ApprovalStepWrapper>();
            isSubmitForApproval = true;
        }
    }
    Public class expenseSummarywrapper{
        
        public String expenseType{get;set;}
        public Id transacationCode{get;set;}
        
        public Decimal sumBudgetCash{get;set;}
        public Decimal sumBudgetInKind{get;set;}
        public Decimal sumProjectedCash{get;set;}
        public Decimal sumProjectedInkind{get;set;}
        public Decimal sumActualCash{get;set;}
        public Decimal sumActualInKind{get;set;}
        public Decimal sumFEPostedCash {get;set;}
        public Decimal sumFEPostedInKind {get;set;}
        public Decimal sumBtoPDiff {get;set;}
        public Decimal sumAtoFEPDiff{get;set;}            
        public expenseSummarywrapper() {
            sumBudgetCash= 0;
            sumBudgetInKind=0;
            sumProjectedCash= 0;
            sumProjectedInkind= 0;
            sumActualCash= 0;
            sumActualInKind=0;
            sumFEPostedCash = 0;
            sumFEPostedInKind =0;
            sumBtoPDiff=0;
            sumAtoFEPDiff=0;
                
        }
    } 
    
    public String temp {get; set;}
    public Boolean temp1 {get; set;}
     public void showDeptDiv()
    {
        if(temp == '--None--')
        {
            temp1 = true;
        }
        else
        {
            temp1 = false;
        }
    }   
    
     public void closePopup() {        
        displayPopup = false;    
    }
    public PageReference closePopup1() {        
        return new PageReference('javascript:window.close()');    
    }
    
             
}