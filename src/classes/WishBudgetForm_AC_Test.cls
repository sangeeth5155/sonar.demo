@isTest
public class WishBudgetForm_AC_Test{
    
    public static testMethod void testmethodLoad(){
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case planAntiCase = OrientationandTrainingUtil.createWishPlanningCase(wishChild.Id, parentCase.Id);
        Wish_Expense__c obj = OrientationandTrainingUtil.createWishExpenceRecord(parentCase.Id);
        insert obj;
        PageReference pageRef = Page.WishBudgetForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('CaseId',parentCase.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        WishBudgetForm_AC wishBudget = new WishBudgetForm_AC(sc);
        wishBudget.DeptDiv='10,20,30';
        wishBudget.getWishExpenceTypes();
        wishBudget.getDeptDivisions();
        wishBudget.getAccountDescs();
        wishBudget.showDeptDiv();
        wishBudget.closePopup();
        wishBudget.closePopup1();
        
        WishBudgetForm_AC.ApprovalStepWrapper appStep= new WishBudgetForm_AC.ApprovalStepWrapper ();
    }
    
     public static testMethod void testmethodAddExpenseType(){
       
        
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case planAntiCase = OrientationandTrainingUtil.createWishPlanningCase(wishChild.Id, parentCase.Id);
        Wish_Expense__c expense = OrientationandTrainingUtil.createWishExpenceRecord(parentCase.Id);
        insert expense;
        ApexPages.StandardController sc = new ApexPages.StandardController(expense);
        PageReference pageRef = Page.WishBudgetForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('CaseId',expense.Case__c);
        WishBudgetForm_AC wishBudget = new WishBudgetForm_AC(sc);
        Wish_Expense_Type__c wishExpenseType= OrientationandTrainingUtil.CreateWishExpenseTypeRecord();
        insert wishExpenseType;
        Wish_Expense_Transaction_Code__c currtransactionCode = OrientationandTrainingUtil.CreateWishExpenseTransactionCodeRecord(wishExpenseType.Id);
        insert currtransactionCode;
        wishBudget.TransCodesWrap.put('Airfare', new List<Wish_Expense_Transaction_Code__c>{currtransactionCode});
        wishBudget.newExpenseType ='Airfare';
        wishBudget.addExpenseType();  
   }
   
    public static testMethod void testmethodAddExpense(){
       
        //Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case planAntiCase = OrientationandTrainingUtil.createWishPlanningCase(wishChild.Id, parentCase.Id);
        Wish_Expense__c expense = OrientationandTrainingUtil.createWishExpenceRecord(parentCase.Id);
        insert expense;
        ApexPages.StandardController sc = new ApexPages.StandardController(expense);
        
        PageReference pageRef = Page.WishBudgetForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('CaseId',expense.Case__c);
        WishBudgetForm_AC wishBudget = new WishBudgetForm_AC(sc);
        Wish_Expense_Type__c wishExpenseType= OrientationandTrainingUtil.CreateWishExpenseTypeRecord();
        insert wishExpenseType;
        Wish_Expense_Transaction_Code__c currtransactionCode = OrientationandTrainingUtil.CreateWishExpenseTransactionCodeRecord(wishExpenseType.Id);
        insert currtransactionCode;
        wishBudget.TransCodesWrap.put('Airfare', new List<Wish_Expense_Transaction_Code__c>{currtransactionCode});
        Wish_Expense__c expenseData = new Wish_Expense__c();
        expenseData.Wish_Expense_Transaction_Code__c=currtransactionCode.Id;
        expenseData.Budget_Cash__c=10;
        expenseData.Budget_In_Kind__c=20;
        wishBudget.wishExpensewrap.put('Airfare', new List<Wish_Expense__c>{expenseData});
        wishBudget.expenseType ='Airfare';
        wishBudget.addExpense();  
   }
   
    public static testMethod void testmethodsubmitForApproval(){
       
        //Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case planAntiCase = OrientationandTrainingUtil.createWishPlanningCase(wishChild.Id, parentCase.Id);
        Wish_Expense__c expense = OrientationandTrainingUtil.createWishExpenceRecord(parentCase.Id);
        insert expense;
        ApexPages.StandardController sc = new ApexPages.StandardController(expense);
        PageReference pageRef = Page.WishBudgetForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('CaseId',expense.Case__c);
        WishBudgetForm_AC wishBudget = new WishBudgetForm_AC(sc);
        Wish_Expense_Type__c wishExpenseType= OrientationandTrainingUtil.CreateWishExpenseTypeRecord();
        insert wishExpenseType;
        Wish_Expense_Transaction_Code__c currtransactionCode = OrientationandTrainingUtil.CreateWishExpenseTransactionCodeRecord(wishExpenseType.Id);
        insert currtransactionCode;
        wishBudget.TransCodesWrap.put('Airfare', new List<Wish_Expense_Transaction_Code__c>{currtransactionCode});
        Wish_Expense__c expenseData = new Wish_Expense__c();
        expenseData.Wish_Expense_Transaction_Code__c=currtransactionCode.Id;
        expenseData.Budget_Cash__c=10;
        expenseData.Budget_In_Kind__c=20;
        wishBudget.wishExpensewrap.put('Airfare', new List<Wish_Expense__c>{expenseData});
        wishBudget.expenseType ='Airfare';
        //User userInfo=OrientationandTrainingUtil.createrSystemAdminUser();
        wishBudget.approverId = userInfo.getUserId();
        wishBudget.getPlanningAnticipationCase.add(planAntiCase) ;
        wishBudget.submitForApproval();  
   } 
   
   public static testMethod void testmethodUserListForApproval(){
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case planAntiCase = OrientationandTrainingUtil.createWishPlanningCase(wishChild.Id, parentCase.Id);
        Wish_Expense__c obj = OrientationandTrainingUtil.createWishExpenceRecord(parentCase.Id);
        insert obj;
        PageReference pageRef = Page.WishBudgetForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('CaseId',parentCase.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        WishBudgetForm_AC wishBudget = new WishBudgetForm_AC(sc);
        wishBudget.getUserListForApproval();
        
    } 
    
    public static testMethod void testmethodLoadTemplates(){
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case planAntiCase = OrientationandTrainingUtil.createWishPlanningCase(wishChild.Id, parentCase.Id);
        Wish_Expense__c obj = OrientationandTrainingUtil.createWishExpenceRecord(parentCase.Id);
        insert obj;
        PageReference pageRef = Page.WishBudgetForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('CaseId',parentCase.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        WishBudgetForm_AC wishBudget = new WishBudgetForm_AC(sc);
         Wish_Expense_Type__c wishExpenseType= OrientationandTrainingUtil.CreateWishExpenseTypeRecord();
        insert wishExpenseType;
        Wish_Expense_Transaction_Code__c currtransactionCode = OrientationandTrainingUtil.CreateWishExpenseTransactionCodeRecord(wishExpenseType.Id);
        insert currtransactionCode;
        wishBudget.TransCodesWrap.put('Airfare', new List<Wish_Expense_Transaction_Code__c>{currtransactionCode});
        wishBudget.LoadTemplates();
    } 
    public static testMethod void testmethodSaveExpenses(){
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case planAntiCase = OrientationandTrainingUtil.createWishPlanningCase(wishChild.Id, parentCase.Id);
        Wish_Expense__c obj = OrientationandTrainingUtil.createWishExpenceRecord(parentCase.Id);
        insert obj;
        PageReference pageRef = Page.WishBudgetForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('CaseId',parentCase.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        WishBudgetForm_AC wishBudget = new WishBudgetForm_AC(sc);
        Wish_Expense_Type__c wishExpenseType= OrientationandTrainingUtil.CreateWishExpenseTypeRecord();
        insert wishExpenseType;
        Wish_Expense_Transaction_Code__c currtransactionCode = OrientationandTrainingUtil.CreateWishExpenseTransactionCodeRecord(wishExpenseType.Id);
        insert currtransactionCode;
        wishBudget.TransCodesWrap.put('Airfare', new List<Wish_Expense_Transaction_Code__c>{currtransactionCode});
        Wish_Expense__c expenseData = new Wish_Expense__c();
        expenseData.Wish_Expense_Transaction_Code__c=currtransactionCode.id;
        expenseData.Budget_Cash__c=10;
        expenseData.Budget_In_Kind__c=20;
        wishBudget.wishExpensewrap.put('Airfare', new List<Wish_Expense__c>{expenseData});
        wishBudget.expenseType ='Airfare';
        wishBudget.SaveExpenses();
    }
    
    public static testMethod void testmethodRemoveExpense(){
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case planAntiCase = OrientationandTrainingUtil.createWishPlanningCase(wishChild.Id, parentCase.Id);
        Wish_Expense__c obj = OrientationandTrainingUtil.createWishExpenceRecord(parentCase.Id);
        insert obj;
        PageReference pageRef = Page.WishBudgetForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('CaseId',parentCase.Id);
        ApexPages.currentPage().getParameters().put('index','0');
        ApexPages.currentPage().getParameters().put('expenType','Airfare');
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        WishBudgetForm_AC wishBudget = new WishBudgetForm_AC(sc);
        Wish_Expense_Type__c wishExpenseType= OrientationandTrainingUtil.CreateWishExpenseTypeRecord();
        insert wishExpenseType;
        Wish_Expense_Transaction_Code__c currtransactionCode = OrientationandTrainingUtil.CreateWishExpenseTransactionCodeRecord(wishExpenseType.Id);
        insert currtransactionCode;
        wishBudget.TransCodesWrap.put('Airfare', new List<Wish_Expense_Transaction_Code__c>{currtransactionCode});
        Wish_Expense__c expenseData = new Wish_Expense__c();
        expenseData.Wish_Expense_Transaction_Code__c=currtransactionCode.Id;
        expenseData.Budget_Cash__c=10;
        expenseData.Budget_In_Kind__c=20;
        wishBudget.wishExpensewrap.put('Airfare', new List<Wish_Expense__c>{expenseData});
        wishBudget.expenseList= wishBudget.wishExpensewrap.get('Airfare');
        wishBudget.removeExpense();
    }
    
}