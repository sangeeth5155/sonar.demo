<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Welcome_Email_to_Prospective_volunteer_user</fullName>
        <description>Send Welcome Email to Prospective volunteer user</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>wvc@wish.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Volunteer_Templates/Communities_New_Prospective_Volunteer_Welcome_Email_Template</template>
    </alerts>
    <rules>
        <fullName>User %3ASend Welcome Email to User</fullName>
        <actions>
            <name>Send_Welcome_Email_to_Prospective_volunteer_user</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND( 2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>User.Migrated_User__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Prospective Volunteer (Login)</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Prospective Volunteer (Member)</value>
        </criteriaItems>
        <description>Used to send welcome email for new prospective volunteer user</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
