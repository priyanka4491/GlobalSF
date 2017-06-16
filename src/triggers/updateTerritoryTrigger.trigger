trigger updateTerritoryTrigger on Account_To_Territory__c ( after insert,after update)
{

    List<ObjectTerritory2Association> loggers = new List<ObjectTerritory2Association>();
if(Trigger.isInsert&&Trigger.isAfter){
    for(Account_To_Territory__c  c : Trigger.new)
    {
        loggers.add(new ObjectTerritory2Association(AssociationCause = c.AssociationCause__c, ObjectId = c.Account_SFID__c, Territory2Id =c.Territory__c ));
    }

    insert loggers;
}

if(Trigger.isupdate&&Trigger.IsAfter){
    list<ObjectTerritory2Association> delete_records = new list<ObjectTerritory2Association>();
    Map<id,set<Id>> old_acc_TerritoryMap = new Map<id,set<id>>();
    set<id> old_territoryIds = new Set<id>();
    set<id> territory_ids; 
    for(Account_To_Territory__c recAccTerritory: Trigger.new){
        if(recAccTerritory.Territory__c!=trigger.oldmap.get(recAccTerritory.id).Territory__c){
            if(recAccTerritory.Territory__c!=null && recAccTerritory.Territory__c instanceof Id){
                loggers.add(new ObjectTerritory2Association(AssociationCause = recAccTerritory.AssociationCause__c, ObjectId = recAccTerritory.Account_SFID__c, Territory2Id =recAccTerritory.Territory__c ));
            }
            if(trigger.oldmap.get(recAccTerritory.id).Territory__c!=null&& (trigger.oldmap.get(recAccTerritory.id).Territory__c instanceof Id)){
                Id oldTerritory_id= Id.valueof(trigger.oldmap.get(recAccTerritory.id).Territory__c);
                if(old_acc_TerritoryMap.containskey(recAccTerritory.Account_SFID__c))
                    territory_ids=old_acc_TerritoryMap.get(recAccTerritory.Account_SFID__c);
                else
                    territory_ids = new set<id>();
                territory_ids.add(oldTerritory_id);
                old_territoryIds.add(oldTerritory_id);
                if(!territory_ids.isempty())
                old_acc_TerritoryMap.put(recAccTerritory.Account_SFID__c,territory_ids);
            }
        }
    }
List<ObjectTerritory2Association> existingObjTerritoryList = [select id,ObjectId,Territory2Id from ObjectTerritory2Association where ObjectId In:old_acc_TerritoryMap.keyset() and Territory2Id in: old_territoryIds];

for(ObjectTerritory2Association rec:existingObjTerritoryList){
    if(old_acc_TerritoryMap.containskey(rec.Objectid)){
        territory_ids = new set<id>();
        territory_ids = old_acc_TerritoryMap.get(rec.Objectid);
        if(territory_ids.contains(rec.Territory2Id))
            delete_records.add(rec);    
    }
    
}
if(!loggers.isempty())
    insert loggers;
if(!delete_records.isempty())
    delete delete_records;
    }
}