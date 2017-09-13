<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DynamicContent_Update_Chapter_Value</fullName>
        <description>Updating Chapter Name value.</description>
        <field>Chapter__c</field>
        <formula>Chapter_Name__r.Name</formula>
        <name>DynamicContent: Update Chapter Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DynamicContent%3A Update Chapter Field</fullName>
        <actions>
            <name>DynamicContent_Update_Chapter_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updating Chapter Name</description>
        <formula>Chapter_Name__c != Null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
