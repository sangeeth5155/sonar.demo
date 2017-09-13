<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Date_of_Request_Field_Update</fullName>
        <description>This field will update when submit the record for approval</description>
        <field>Date_of_request__c</field>
        <formula>TODAY()</formula>
        <name>Date of Request Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_of_Submission</fullName>
        <description>This field will update automatically when the record submit for approval</description>
        <field>Date_of_Submission__c</field>
        <formula>TODAY()</formula>
        <name>Date of Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_isSubmitted_Approval_field</fullName>
        <field>HiddenIsSubmittedforApproval__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck isSubmitted Approval field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_By_on_Reimbursement</fullName>
        <field>Approved_By__c</field>
        <formula>$User.FirstName +  $User.LastName</formula>
        <name>Update Approved By on Reimbursement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Date_on_Reimbursement</fullName>
        <field>Approved_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Approved Date on Reimbursement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>isSubmitted_for_Approval_field_update</fullName>
        <field>HiddenIsSubmittedforApproval__c</field>
        <literalValue>1</literalValue>
        <name>isSubmitted for Approval field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
