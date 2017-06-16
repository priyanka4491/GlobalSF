<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Dealer_Status_Update</fullName>
        <field>Has_Dealer_Business_Role__c</field>
        <literalValue>1</literalValue>
        <name>Dealer Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account_SFID__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Grower_Status_Update</fullName>
        <field>Has_Grower_Business_Role__c</field>
        <literalValue>1</literalValue>
        <name>Grower Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account_SFID__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Acc Business Role Dealer Status</fullName>
        <actions>
            <name>Dealer_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Business_Role__c.Role_Descr__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Acc Business Role Status</fullName>
        <actions>
            <name>Grower_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Business_Role__c.Role_Descr__c</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateDealerGrower</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account_Business_Role__c.Role_Descr__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
