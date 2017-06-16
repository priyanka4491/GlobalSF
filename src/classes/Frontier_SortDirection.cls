/***********************************************************************************
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @objects Referenced :Account,Territory
* @Description : This Class is used for sorting. 
            It is referred in Eventlistcontroller,FollowupListController
*************************************************************************************/
public class Frontier_SortDirection{
    public String ActivityDate;
    public String Type{get;set;}
    public String CreatedBy;
    public String AccountName;
    public String Activities;
    public String AccountId;
    public String EventId;
    public String SAPId;
    
    public String TerritoryId;
    public String TerritoryName;
    public String ParentTerritoryLabel;
    public String Description;
    public String Location;
    Public String Team;
    Public String Comment;    
    public String Radl;
    
    //Field of Touchpoint Program
    public String ProgramName;
    public String Planning;
    public String Execution;
    public String ProgramEventName;
    public String Status;
    public String EventActivityDate;
    public String Phase;
    public String TouchPointProgramName;
   // public String StatusAct;
    public String AccountsName;
    
    
    public String AccountRADL;
    public String ProductName;
    
    //Field of Products
    public string Products;
    public String AccName;
    public String Address;
    public String AccRADL;
    
    // Assign default values with the sort order
    public Frontier_SortDirection(){
        this.ProductName = 'Product_SFID__r.Name-ASC';
        this.ActivityDate = 'ActivityDate-ASC';
        this.Products = 'Products-ASC';
        this.Type = 'Type-ASC';
        this.CreatedBy = 'CreatedBy.Name-ASC';
        this.AccountName = 'What.Name-ASC';
        this.AccountId ='WhatId-ASC';
        this.EventId='Id-ASC';
        this.Location = 'Location-ASC';
        this.SAPId='SAP_ID__c-ASC';
        this.Activities = 'Activities-ASC';
        this.Radl='Service_Level_Class_Descr__c-ASC';
        this.TerritoryId='TerritoryId-ASC';
        this.TerritoryName='Name-ASC';
        this.Team = 'Team-ASC';
        this.ParentTerritoryLabel='ParentTerritoryLabel-ASC';
        this.Description='Description-ASC';
        this.Comment = 'Comment-ASC';
        
        this.ProgramName = 'Name-ASC';
        this.Planning = 'Planning_Status__c-ASC';
        this.Execution = 'Execution_Status__c-ASC';
        this.Status='Status-ASC';
        this.ProgramEventName='Subject-ASC';
        //this.StatusAct='TouchPoint__r.TouchPoint_Status__c-ASC';
        this.EventActivityDate='TouchPoint_SFID__r.Date__c-ASC';
        this.Phase='Phase__c-ASC';
        this.TouchPointProgramName = 'Program_SFID__r.Name-ASC';
        this.AccountsName = 'Account_SFID__r.Name-ASC';
        this.AccountRADL = 'Service_Level_Class_Descr__c-ASC';
         this.AccName = 'Account_SFID__r.Name-ASC';
        this.Address = 'Account.City-ASC';
         this.AccRADL = 'Service_Level_Class_Descr__c-ASC';
      }
}