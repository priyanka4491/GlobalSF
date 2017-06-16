public class Frontier_TouchpointPlanning {
    /* @AuraEnabled
    public static List<String> getPicklistValue(){
        List<String> picvalues = new List<String>();
        Schema.DescribeFieldResult pgmResult = Program__c.Program__c.getDescribe();
        List<Schema.PicklistEntry> pickValues = pgmResult.getPicklistValues();
        for (Schema.PicklistEntry pgmLabel: pickValues) {
            picvalues.add(pgmLabel.getLabel());
        }  
        system.debug('picvalues' + picvalues);
        return picvalues;
    }
     @AuraEnabled
    public static List<String>  getDependentValue(String Controlvalue){
        List<String> dependentvalue = new List<String>();
        if(Controlvalue == 'Program 1'){  
            dependentvalue.add('Activity 5'); 
            dependentvalue.add('Proposal'); 
            dependentvalue.add('Field Check'); 
        }
        else if(Controlvalue == 'Program 2'){  
            dependentvalue.add('Field Check'); 
            dependentvalue.add('Assist Planting'); 
            dependentvalue.add('Activity 7'); 
        }
        else if(Controlvalue == 'Program 3'){  
            dependentvalue.add('Activity 5'); 
            dependentvalue.add('Proposal'); 
            dependentvalue.add('Assist Planting'); 
        }
        else if(Controlvalue == 'Program 4'){  
            dependentvalue.add('Activity 1'); 
            dependentvalue.add('Assist Planting'); 
            dependentvalue.add('Field Check'); 
            dependentvalue.add('Activity 7'); 
        }

        return dependentvalue;
    }
    
    @AuraEnabled
    public static List<String>  getNonPicklistValue(){
        List<String> nonActivity = new List<String>();  
            nonActivity.add('Complaint'); 
            nonActivity.add('Relationship Building'); 
            nonActivity.add('Sales Visit');   
        nonActivity.add('Contract Negotiation'); 
        nonActivity.add('Supply Conversation'); 
        nonActivity.add('Product Introduction'); 
        return nonActivity;
    }*/
   
}