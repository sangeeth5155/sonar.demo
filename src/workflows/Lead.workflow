<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Diagnosis_Form_Email_Alert</fullName>
        <description>Diagnosis Form Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Treating_Medical_Professional_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Medical_Eligibility_Emails/Part_A_Form_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Diagnosis_Form_Email_Alert_for_Best_Physician_contact</fullName>
        <description>Diagnosis Form Email Alert for Best Physician contact</description>
        <protected>false</protected>
        <recipients>
            <field>Best_contact_for_Physician_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Medical_Eligibility_Emails/Diagnosis_Verification_Form_Email_Template_Best_Physician</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_Referrer</fullName>
        <description>Email Notification to Referrer</description>
        <protected>false</protected>
        <recipients>
            <field>Referrer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Medical_Eligibility_Emails/Inquiry_Referral_Template</template>
    </alerts>
    <alerts>
        <fullName>Lead_Email_Alert_for_Lead_Owner_Regarding_Chapter_Update</fullName>
        <description>Lead: Email Alert for Lead Owner Regarding Chapter Update</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Wish_Granting_Email_Templates/Lead_Email_Notification_for_Lead_Owner</template>
    </alerts>
    <alerts>
        <fullName>Lead_Email_Alert_to_Qualifying_Medical_Professional_when_child_is_NOT_eligible</fullName>
        <description>Lead:Email Alert to Qualifying Medical Professional when child is NOT eligible</description>
        <protected>false</protected>
        <recipients>
            <field>Treating_Medical_Professional_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Medical_Professional_Email_Templates/Med_Professional_Your_patient_was_referred_for_a_wish</template>
    </alerts>
    <alerts>
        <fullName>Lead_Email_Alert_to_Qualifying_Medical_Professional_when_child_is_eligible</fullName>
        <description>Lead:Email Alert to Qualifying Medical Professional when child is eligible</description>
        <protected>false</protected>
        <recipients>
            <field>Best_contact_for_Physician_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Treating_Medical_Professional_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Medical_Professional_Email_Templates/Med_Professional_Your_patient_is_eligible_for_a_wish</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Office_Referrar_email_with_Wish_Referral_Form</fullName>
        <ccEmails>missionresources@wish.org</ccEmails>
        <description>Send Email to Office Referrar email with Wish Referral Form</description>
        <protected>false</protected>
        <recipients>
            <field>Office_Referral_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Wish_Granting_Email_Templates/Send_Wish_Referral_Form_to_Non_Active_Chapter_Office</template>
    </alerts>
    <rules>
        <fullName>Email Notification to Referrer</fullName>
        <actions>
            <name>Email_Notification_to_Referrer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Lead_ET_We_ve_Received_your_Referral_Inquiry</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Its sending acknowledge notification to referrer.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A Email Notification for Lead Owner</fullName>
        <actions>
            <name>Lead_Email_Alert_for_Lead_Owner_Regarding_Chapter_Update</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Lead_ET_Chapter_has_been_changed</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Whenever chapter updates based on the Postal Code, It will send an email notification to Lead Owner.</description>
        <formula>ISCHANGED( ChapterName__c) &amp;&amp;   $Profile.Name != &apos;Integration&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3AQualifying Medical Professional when child is NOT eligible</fullName>
        <actions>
            <name>Send_DNQ_Notification_to_Qualifying_Medical_Professional</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>DNQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Integration</value>
        </criteriaItems>
        <description>It send a email notification to Qualifying Medical Professional when child is NOT eligible.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3AQualifying Medical Professional when child is eligible</fullName>
        <actions>
            <name>Lead_Email_Alert_to_Qualifying_Medical_Professional_when_child_is_eligible</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Lead_ET_Your_patient_is_eligible_for_a_wish</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Integration</value>
        </criteriaItems>
        <description>It send a email notification to  Qualifying Medical Professional when child is eligible</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Lead_ET_Chapter_has_been_changed</fullName>
        <assignedTo>sathiskumar.s_maw@mstsolutions.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.Today_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Lead ET : Chapter has been changed</subject>
    </tasks>
    <tasks>
        <fullName>Lead_ET_We_ve_Received_your_Referral_Inquiry</fullName>
        <assignedTo>sathiskumar.s_maw@mstsolutions.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.Today_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Lead ET : We&apos;ve Received your Referral Inquiry</subject>
    </tasks>
    <tasks>
        <fullName>Lead_ET_Your_patient_is_eligible_for_a_wish</fullName>
        <assignedTo>sathiskumar.s_maw@mstsolutions.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.Today_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Lead ET : Your patient is eligible for a wish!</subject>
    </tasks>
    <tasks>
        <fullName>Lead_ET_Your_patient_was_referred_for_a_wish</fullName>
        <assignedTo>sathiskumar.s_maw@mstsolutions.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.Today_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Lead ET : Your patient was referred for a wish</subject>
    </tasks>
    <tasks>
        <fullName>Send_DNQ_Notification_to_Qualifying_Medical_Professional</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send DNQ Notification to Qualifying Medical Professional</subject>
    </tasks>
</Workflow>
