/*************************************************************************************** 
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @objects Referenced : Event
* @Description : To sort the visits based on territory. Applied Sorting functionality to sort out 
           		 the visit based on the order. 
			     It is referred in Eventlistcontroller

****************************************************************************************/
global class Frontier_SortingWrapper implements Comparable{
    global Frontier_EventListController.VisitWrapper visitWrapper{get;set;}
    global string fieldOrder {get;set;}
    global String fieldName {get;set;}
    
    global Frontier_SortingWrapper(Frontier_EventListController.VisitWrapper visitWrapperToSort,String fieldOrder,String field){
        this.visitWrapper = visitWrapperToSort; 
        this.fieldOrder = fieldOrder;
        this.fieldName = field;
    }
    global Integer compareTo(Object compareTo) { 
         Frontier_SortingWrapper sortingWrap = (Frontier_SortingWrapper)compareTo;     

         Integer returnValue = 0;
        if(fieldName == 'Team'){   
            if( this.fieldOrder == 'ASC'){          
               returnValue  = (visitWrapper.Team > sortingWrap.visitWrapper.Team ? 1 : (visitWrapper.Team < sortingWrap.visitWrapper.Team ? -1:0));
			}
            else{              
             returnValue  = (visitWrapper.Team > sortingWrap.visitWrapper.Team ? -1 : (visitWrapper.Team < sortingWrap.visitWrapper.Team ? 1:0));
            }
        }
        else if(fieldName == 'Name'){
            if(this.fieldOrder == 'ASC'){
              returnValue  = (visitWrapper.TerritoryName > sortingWrap.visitWrapper.TerritoryName ? 1 : (visitWrapper.TerritoryName < sortingWrap.visitWrapper.TerritoryName ? -1:0));
			}
            else{
                 returnValue  = (visitWrapper.TerritoryName > sortingWrap.visitWrapper.TerritoryName ? -1 : (visitWrapper.TerritoryName < sortingWrap.visitWrapper.TerritoryName ? 1:0));
			}
        }
        else if(fieldName == 'Comment'){
            if(this.fieldOrder == 'ASC'){
              returnValue  = (visitWrapper.Description > sortingWrap.visitWrapper.Description ? 1 : (visitWrapper.Description < sortingWrap.visitWrapper.Description ? -1:0));
			}
            else{
                 returnValue  = (visitWrapper.Description > sortingWrap.visitWrapper.Description ? -1 : (visitWrapper.Description < sortingWrap.visitWrapper.Description ? 1:0));
			}
        }
        else if(fieldName == 'Service_Level_Class_Descr__c'){
            if(this.fieldOrder == 'ASC'){
              returnValue  = (visitWrapper.RADL_Class > sortingWrap.visitWrapper.RADL_Class ? 1 : (visitWrapper.RADL_Class < sortingWrap.visitWrapper.RADL_Class ? -1:0));
			}
            else{
                 returnValue  = (visitWrapper.RADL_Class > sortingWrap.visitWrapper.RADL_Class ? -1 : (visitWrapper.RADL_Class < sortingWrap.visitWrapper.RADL_Class ? 1:0));
			}
        }
        return returnValue;
    }
}