({   
    loadMap : function(component, event, helper) {
        
        var itemNode = document.getElementById('mapid');
        itemNode.parentNode.removeChild(itemNode);
        document.getElementById('maps').innerHTML = '<div aura:id="mapid" id="mapid" style="position:absolute;height:100%;width:100%;"></div>';
        setTimeout(function(){
            console.log('Task=>'+component.get('v.Tasks'));
            var i;
            var map='';
            var mapObject = new L.Map('mapid', {zoomControl: true});
            var task = component.get('v.Tasks');
            var coveragetask = component.get('v.coverageTasks');
            var coverageAreaJson='{"type": "FeatureCollection","features": [';
            var coverageAreaJsonLayer;
            
            
            map =  mapObject.setView([component.get("v.currentLatitude"),component.get("v.currentLongitude")], 11);
            L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                        {
                            attribution: 'Tiles © Esri'
                        }).addTo(map);
            if(component.get('v.Tasks') !== null) {
                var myIcon = L.icon({
                    iconUrl: 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|e85141&chf=a,s,ee00FFF',
                    iconRetinaUrl: 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|e85141&chf=a,s,ee00FFF',
                    iconSize: [28, 35],
                    iconAnchor: [22, 35],
                    popupAnchor: [-3, -30],
                });       
                console.log("Inside map" + map);
                //Add marker
                L.marker([component.get("v.currentLatitude"),component.get("v.currentLongitude")],{opacity: 0.5,icon: myIcon} ).addTo(map).bindPopup('You Are Here').openPopup();
                L.circle([component.get("v.currentLatitude"),component.get("v.currentLongitude")], 40233.60).addTo(map);
                for(i=0;i<task.length;i++){
                    var type = typeof task[i].Type != 'undefined'?  task[i].Type : 'None';
                    var activityDate = typeof task[i].ActivityDate != 'undefined'?  task[i].ActivityDate : 'None';
                    L.marker([task[i].Account.BillingLatitude,task[i].Account.BillingLongitude]).bindPopup(task[i].Account.Name+'<br/> Activity Date : '+activityDate+'<br/> Type : '+type+'<br /> Location : '+task[i].Account.BillingStreet+','+task[i].Account.BillingCity).openPopup().addTo(map);
                }
            }else if(component.get('v.coverageTasks') !== null){
                for(i=0;i<coveragetask.length;i++){
                    
                    if(typeof coveragetask[i].Business_Roles__r  !== 'undefined'){
                        //alert(JSON.stringify(coveragetask[i].Business_Roles__r[0].Service_Level_Class_Descr__c));
                        if(coveragetask[i].Business_Roles__r[0].Service_Level_Class_Descr__c === 'Acquire'){
                            console.log('Acquire');
                            coverageAreaJson +='{'+
                                '"type": "Feature",'+
                                '"geometry": {'+
                                '"type": "Point",'+
                                '"coordinates":  ['+coveragetask[i].BillingLongitude+','+coveragetask[i].BillingLatitude+']'+
                                '},'+
                                '"properties": {'+
                                '"DateTime": "7/3/2013 4:47:15 PM",'+
                                '"GPSUserName": "3",'+
                                '"GPSUserColor": "#ff9000",'+
                                '"show_on_map": true'+
                                '}'+
                                '},'
                        }else if(coveragetask[i].Business_Roles__r[0].Service_Level_Class_Descr__c === 'Develop'){
                            console.log('Develop');
                            coverageAreaJson +='{'+
                                '"type": "Feature",'+
                                '"geometry": {'+
                                '"type": "Point",'+
                                '"coordinates": ['+coveragetask[i].BillingLongitude+','+coveragetask[i].BillingLatitude+']'+
                                '},'+
                                '"properties": {'+
                                '"DateTime": "7/3/2013 4:47:15 PM",'+
                                '"GPSUserName": "2",'+
                                '"GPSUserColor": "#fe5000",'+
                                '"show_on_map": true'+
                                '}'+
                                '},'
                            
                        }else if(coveragetask[i].Business_Roles__r[0].Service_Level_Class_Descr__c === 'Light Touch'){
                            console.log('Light Touch');
                            coverageAreaJson +='{'+
                                '"type": "Feature",'+
                                '"geometry": {'+
                                '"type": "Point",'+
                                '"coordinates":  ['+coveragetask[i].BillingLongitude+','+coveragetask[i].BillingLatitude+']'+
                                '},'+
                                '"properties": {'+
                                '"DateTime": "7/3/2013 4:47:15 PM",'+
                                '"GPSUserName": "4",'+
                                '"GPSUserColor": "#ffca30",'+
                                '"show_on_map": true'+
                                '}'+
                                '},'
                            
                        }else if(coveragetask[i].Business_Roles__r[0].Service_Level_Class_Descr__c === 'Retain'){
                            console.log('Retain');
                            coverageAreaJson +='{'+
                                '"type": "Feature",'+
                                '"geometry": {'+
                                '"type": "Point",'+
                                '"coordinates": ['+coveragetask[i].BillingLongitude+','+coveragetask[i].BillingLatitude+']'+
                                '},'+
                                '"properties": {'+
                                '"DateTime": "7/3/2013 4:47:15 PM",'+
                                '"GPSUserName": "5",'+
                                '"GPSUserColor": "#b3d041",'+
                                '"show_on_map": true'+
                                '}'+
                                '},'
                        }
                    }
                }
                coverageAreaJson = coverageAreaJson.substring(0,coverageAreaJson.length-1)+'],"name": "Points","keyField": ""}';
                console.log('coverageAreaJson=>'+coverageAreaJson);
                L.geoJson(JSON.parse(coverageAreaJson), {
                    style: function(feature) {
                        return {color: feature.properties.GPSUserColor};
                    },
                    pointToLayer: function(feature, latlng) {
                        console.log('latlog=>'+latlng);
                        return new L.CircleMarker(latlng, {radius: 10, fillOpacity: 0.85});
                    },
                    onEachFeature: function (feature, layer) {
                        
                        layer.bindPopup(feature.properties.GPSUserName);
                    }
                }).addTo(map);
                
            }
            //$A.util.addClass(component.find('mapid'), 'mapid');
            
        },2000);        
    }  
    
})