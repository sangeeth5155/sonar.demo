<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_In_Kind_Donor_Account_For_Approval_Email_Alert</fullName>
        <description>Account:In Kind Donor Account For Approval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Wish_Co_ordinator_Hidden_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Wish_Granting_Email_Templates/Account_In_Kind_Donors_Approval_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>In_Kind_Approval_Field_Status_Update</fullName>
        <description>Used to set rejected value to approval field</description>
        <field>In_Kind_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>In-Kind Approval Field Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_Approved_Field_Update</fullName>
        <description>This field update is used to update the is approved field in in kind donors record</description>
        <field>Is_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Is Approved Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_In_Kind_Approval_Status</fullName>
        <description>Used to update in kind account status</description>
        <field>In_Kind_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update In-Kind Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
