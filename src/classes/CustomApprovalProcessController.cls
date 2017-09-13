public with sharing class CustomApprovalProcessController {
    
    
    //Properties Declaration
    transient public ApprovalList aSW {get;set;}
    public Id recordId {get;set;}
    public Id retURLRecordId {get;set;}
    public String ORG_LNK;
    
    //Properties Construnctor
    public CustomApprovalProcessController(ApexPages.StandardController controller) {
        if(retURLRecordId == null && recordId == null) {
            retURLRecordId = recordId = ApexPages.currentPage().getParameters().get('caseId');
        }
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>Custom COntroller'+retURLRecordId);
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>recordId'+recordId);
        //retURLRecordId = recordId = ApexPages.currentPage().getParameters().get('caseId');
        ORG_LNK = 'https://'+URL.getSalesforceBaseUrl().getHost();
        if(!String.isBlank(recordID)){
            aSW = new ApprovalList();
            aSW = generateData();
        }            
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
                                                        OriginalActor.Name , ProcessNode.Name FROM StepsAndWorkitems order by CreatedDate DESC ) 
                                            FROM ProcessInstance where TargetObjectId =:objectId order by CreatedDate DESC]);
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
}