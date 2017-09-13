/**************************************************************************************
Author : MST Solutions
Description : This class referred in the DelegatedApprover_VF. It display the all record approval processes . 
This will allow chapter staff to see visibility into their colleagues approval's needed when they are covering for each other.
****************************************************************************************/

public class DelegatedApproverController_AC{
    public Map<String,List<ProcessInstance>> approvalMap{get;set;}
    public Transient  String selectedprocessName{get;set;}
    public Transient  String selectedChapter{get;set;}
    public Transient  String selectedApprover{get;set;}
    public Transient  String selectedStatus{get;set;}
    public Transient  String selectedCompltedBy{get;set;}
    public Transient  Set<String> StringSet;
    public List<SelectOption> processItems {get;set;}
    public List<SelectOption> chapterItems {get;set;}   
    public List<SelectOption> approvedByItems {get;set;}  
    //public List<SelectOption> completedByItems {get;set;}
    public List<SelectOption> statusItems {get;set;}   
    
    public DelegatedApproverController_AC(){
       
       Set<String> approverSet = new Set<String>();
       approvedByItems = new List<SelectOption>();
       approvedByItems.add(new selectOption('','--Select--'));
       processItems= new List<SelectOption>();
       processItems.add(new SelectOption('','--Select--'));
       chapterItems = new List<SelectOption>();
       chapterItems.add(new SelectOption('','--Select--'));
       statusItems = new List<SelectOption>();
       statusItems.add(new SelectOption('','--Select--'));
       statusItems.add(new SelectOption('Pending','Pending'));
       statusItems.add(new SelectOption('Approved','Approved'));
       statusItems.add(new SelectOption('Rejected','Rejected'));
       
       approvalMap = new Map<String,List<ProcessInstance>>();
       
       //This get all chapter name from custom setting.
       for(Chapter_Vs_Role__c currChapter :Chapter_Vs_Role__c.getAll().values()){
           if(currChapter.Chapter_Name__c != 'Make-A-Wish America')
               chapterItems.add( new SelectOption(currChapter.Role_Name__c,currChapter.Chapter_Name__c));
       }
       chapterItems.sort();
       
       for(ProcessInstance process : [SELECT Id,status,ProcessDefinition.Name,TargetObject.Name,SubmittedBy.userRole.Name,TargetObject.Type,CreatedBy.Name,SubmittedBy.Account.Name,SubmittedBy.Name,completedDate,CreatedDate
                                            , (SELECT Id,Actor.Name,OriginalActor.Name,ActorId FROM StepsandWorkItems order by Id desc LIMIT 1)FROM ProcessInstance Order by CreatedDate Desc LIMIT 1000]){
                 
            if(approvalMap.containsKey(process.ProcessDefinition.Name))
                approvalMap.get(process.ProcessDefinition.Name).add(process);
             else{
                 approvalMap.put(process.ProcessDefinition.Name,new List<ProcessInstance>{process});   
                 processItems.add(new SelectOption(process.ProcessDefinition.Name,process.ProcessDefinition.Name));
             }
             
             if(!approverSet.Contains(process.StepsandWorkItems[0].Actor.Name) && (!Test.isRunningTest())){
                 approverSet.add(process.StepsandWorkItems[0].Actor.Name);
                 approvedByItems.add(new SelectOption(process.StepsandWorkItems[0].Actor.Name,process.StepsandWorkItems[0].Actor.Name));
             }
             if(!approverSet.Contains(process.StepsandWorkItems[0].OriginalActor.Name) && (!Test.isRunningTest())){
                 approverSet.add(process.StepsandWorkItems[0].OriginalActor.Name);
                 approvedByItems.add(new SelectOption(process.StepsandWorkItems[0].OriginalActor.Name,process.StepsandWorkItems[0].OriginalActor.Name));
             }
            
                 
             
             
        }
   
    }
    
    public void viewProcess(){
        
            
        /*    String Query ='SELECT Id,status,ProcessDefinition.Name,TargetObject.Name,SubmittedBy.userRole.Name,TargetObject.Type,CreatedBy.Name,SubmittedBy.Account.Name,SubmittedBy.Name,completedDate,CreatedDate,(SELECT Id,Actor.Name,ActorId FROM StepsandWorkItems)FROM ProcessInstance';
                                            
       // List<sObject> processList =  Database.query(Query );
                                            
        for(ProcessInstance process :  Database.query(Query)){
                 
            if(approvalMap.containsKey(process.ProcessDefinition.Name))
                approvalMap.get(process.ProcessDefinition.Name).add(process);
             else{
                 approvalMap.put(process.ProcessDefinition.Name,new List<ProcessInstance>{process});   
                // Items.add(new SelectOption(process.ProcessDefinition.Name,process.ProcessDefinition.Name));
             }                        
            
        }*/
    }
    
}