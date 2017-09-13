<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>This_Email_Alert_will_send_when_the_Non_Wish_volunteer_opportunity_is_Approved_b</fullName>
        <description>This Email Alert will send when the Non - Wish volunteer opportunity is Approved by the chapter staff</description>
        <protected>false</protected>
        <recipients>
            <field>Hidden_Volunteer_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Volunteer_Templates/Volunteer_Opportunity_Non_Wish_Approved</template>
    </alerts>
    <alerts>
        <fullName>This_Email_Alert_will_send_when_the_Non_Wish_volunteer_opportunity_is_rejected_b</fullName>
        <description>This Email Alert will send when the Non - Wish volunteer opportunity is rejected by the chapter staff</description>
        <protected>false</protected>
        <recipients>
            <field>Hidden_Volunteer_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Volunteer_Templates/Volunteer_Opportunity_Non_Wish_Rejected</template>
    </alerts>
    <alerts>
        <fullName>This_Email_Alert_will_send_when_the_Wish_volunteer_opportunity_is_Approved_by_th</fullName>
        <description>This Email Alert will send when the Wish volunteer opportunity is Approved by the chapter staff</description>
        <protected>false</protected>
        <recipients>
            <field>Hidden_Volunteer_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Volunteer_Templates/Volunteer_Opportunity_Wish_Approved</template>
    </alerts>
    <alerts>
        <fullName>This_Email_Alert_will_send_when_the_Wish_volunteer_opportunity_is_rejected_by_th</fullName>
        <description>This Email Alert will send when the Wish volunteer opportunity is rejected by the chapter staff</description>
        <protected>false</protected>
        <recipients>
            <field>Hidden_Volunteer_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Volunteer_Templates/Volunteer_Opportunity_Wish_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>VO_ChangeRFIAsNotApproved</fullName>
        <field>Reason_Inactive__c</field>
        <literalValue>Not Approved</literalValue>
        <name>VO:ChangeRFIAsNotApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VO_ChangeStatusAsApproved</fullName>
        <description>Used to change the status as approved once the record has been approved</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>VO:ChangeStatusAsApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VO_EnableInactiveCheckbox</fullName>
        <description>Used to enable Inactive checkbox once the Volunteer Opportunity is rejected</description>
        <field>Inactive__c</field>
        <literalValue>1</literalValue>
        <name>VO:EnableInactiveCheckbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Volunteer_Opportunity</fullName>
        <description>This field update is used to update the Status field as Pending  When the volunteer registers for the Volunteer Opportunity from the community.</description>
        <field>Status__c</field>
        <literalValue>Pending</literalValue>
        <name>VolunteerOpportunity:ChangeStatusPending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Volunteer_Opportunity_Approval_Initiated</fullName>
        <description>Volunteer Opportunity Approval Process initiated</description>
        <field>Approval_Status__c</field>
        <literalValue>Initiated</literalValue>
        <name>Volunteer Opportunity:Approval Initiated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Volunteer_Opportunity_Approved</fullName>
        <description>Volunteer Opportunity is approved for volunteer</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Volunteer Opportunity : Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Volunteer_Opportunity_ChangeStatusApprov</fullName>
        <description>This field update is used to update the Status field as Approved When the volunteer opportunity is approved by the chapter staff.</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>VolunteerOpportunity:ChangeStatusApprove</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Volunteer_Opportunity_ChangeStatusInacti</fullName>
        <description>This field update is used to set the status field value is Inactive when the user enter the reason for inactive.</description>
        <field>Status__c</field>
        <literalValue>Inactive</literalValue>
        <name>Volunteer Opportunity:ChangeStatusInacti</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Volunteer_Opportunity_Rejection_Period</fullName>
        <description>Volunteer opportunity not approved for volunteers</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejection Notification</literalValue>
        <name>Volunteer Opportunity : Rejection Period</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Volunteer Opportunity %3A Non - Wish Approved</fullName>
        <actions>
            <name>This_Email_Alert_will_send_when_the_Non_Wish_volunteer_opportunity_is_Approved_b</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>VO_ET_Volunteer_Opportunity_Approved_NW</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This Work flow rule will fire when the Volunteer opportunity Non - Wish is Approved by the chapter staff.</description>
        <formula>AND( Volunteer_Name__c != Null, Wish__c  == Null, Non_Wish_Event__c != Null,  TEXT( Status__c )  = &apos;Approved&apos; , ISCHANGED(Status__c), $Profile.Name != &apos;Integration&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Volunteer Opportunity %3A Non - Wish Rejected</fullName>
        <actions>
            <name>This_Email_Alert_will_send_when_the_Non_Wish_volunteer_opportunity_is_rejected_b</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>VO_ET_Volunteer_Opportunity_Not_Approved_NW</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This Work flow rule will fire when the Volunteer opportunity Non - Wish is rejected by the chapter staff.</description>
        <formula>AND( Volunteer_Name__c != Null, Wish__c  == Null, Non_Wish_Event__c != Null,  TEXT(  Reason_Inactive__c  )  = &apos;Not Approved&apos; ,ISCHANGED(  Reason_Inactive__c  ),  $Profile.Name != &apos;Integration&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Volunteer Opportunity %3A Wish Approved</fullName>
        <actions>
            <name>This_Email_Alert_will_send_when_the_Wish_volunteer_opportunity_is_Approved_by_th</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>VO_ET_Volunteer_Opportunity_Wish_Approved</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This Work flow rule will fire when the Volunteer opportunity Wish is Approved by the chapter staff.</description>
        <formula>AND( Volunteer_Name__c != Null, Wish__c  != Null, Non_Wish_Event__c == Null,  TEXT( Status__c )  = &apos;Approved&apos; , ISCHANGED( Status__c ),$Profile.Name != &apos;Integration&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Volunteer Opportunity %3A Wish Rejected</fullName>
        <actions>
            <name>This_Email_Alert_will_send_when_the_Wish_volunteer_opportunity_is_rejected_by_th</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>VO_ET_Volunteer_Opportunity_Not_Approved</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This Work flow rule will fire when the Volunteer opportunity Wish is Approved by the chapter staff.</description>
        <formula>AND( Volunteer_Name__c != Null, Wish__c  != Null, Non_Wish_Event__c == Null, TEXT(  Reason_Inactive__c  )  = &apos;Not Approved&apos; , ISCHANGED(  Reason_Inactive__c  ),   $Profile.Name != &apos;Integration&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Volunteer Opportunity%3AChangeStatusInactiveWorkflowRule</fullName>
        <actions>
            <name>Volunteer_Opportunity_ChangeStatusInacti</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Volunteer_Opportunity__c.Reason_Inactive__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Volunteer_Opportunity__c.Inactive__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Integration</value>
        </criteriaItems>
        <description>This workflow rule fire when inactive check box is checked and user enter the reason for inactive.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>VO_ET_Volunteer_Opportunity_Approved_NW</fullName>
        <assignedTo>sathiskumar.s_maw@mstsolutions.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.Today_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>VO ET : Volunteer Opportunity Approved (NW)</subject>
    </tasks>
    <tasks>
        <fullName>VO_ET_Volunteer_Opportunity_Not_Approved</fullName>
        <assignedTo>sathiskumar.s_maw@mstsolutions.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.Today_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>VO ET : Volunteer Opportunity Not Approved</subject>
    </tasks>
    <tasks>
        <fullName>VO_ET_Volunteer_Opportunity_Not_Approved_NW</fullName>
        <assignedTo>sathiskumar.s_maw@mstsolutions.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.Today_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>VO ET : Volunteer Opportunity Not Approved (NW)</subject>
    </tasks>
    <tasks>
        <fullName>VO_ET_Volunteer_Opportunity_Wish_Approved</fullName>
        <assignedTo>sathiskumar.s_maw@mstsolutions.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.Today_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>VO ET : Volunteer Opportunity Wish Approved</subject>
    </tasks>
</Workflow>
