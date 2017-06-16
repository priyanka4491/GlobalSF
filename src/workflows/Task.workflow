<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Follow_up_Reminder_Email_Notification</fullName>
        <description>Follow-up Reminder Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>vijay.ramesh@monsanto.com.global</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Test</fullName>
        <description>Test</description>
        <protected>false</protected>
        <recipients>
            <recipient>charith.devulapalle@monsanto.com.global</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <rules>
        <fullName>Test</fullName>
        <actions>
            <name>Test</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.ActivityDate</field>
            <operation>greaterThan</operation>
            <value>10/27/2016 2:00 AM</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
