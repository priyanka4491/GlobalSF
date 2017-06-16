<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Acc_Identifier_Status</fullName>
        <field>Has_Account_Identifier__c</field>
        <literalValue>1</literalValue>
        <name>Update Acc Identifier Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account_SFID__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Acc Identifier Status</fullName>
        <actions>
            <name>Update_Acc_Identifier_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
