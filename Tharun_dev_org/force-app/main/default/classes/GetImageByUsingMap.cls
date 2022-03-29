public with sharing class GetImageByUsingMap 
{
    @AuraEnabled(cacheable= true)
    public static wrapclass recordSearch()
    {
        map<Id, Listing__c> listIdByListingRec = new map<Id, Listing__c>([SELECT Id, Name, State2__c, Category__c, Duration__c, Guest_Max_Capacity__c
                                                                           FROM Listing__c]);
        map<Id, Id> conDocIdByLinkId = new map<Id, Id>();
         for(ContentDocumentLink docLink: [SELECT ContentDocumentId, LinkedEntityId
                                            FROM ContentDocumentLink
                                            WHERE LinkedEntityId = : listIdByListingRec.keySet()])
        {
            if(!conDocIdByLinkId.containskey(docLink.ContentDocumentId))
            {
                conDocIdByLinkId.put(docLink.ContentDocumentId, docLink.LinkedEntityId);
            }
        }                                                          
        map<Id, Contentversion> linkObjIdByDocId = new map<Id, Contentversion>([SELECT Id, ContentDocumentId
                                                                                FROM Contentversion
                                                                                WHERE ContentDocumentId =: conDocIdByLinkId.keySet()]);
        map<Id, List<Id>> rIdByCId = new map<Id, List<Id>>();
        for(Contentversion conObj : [SELECT Id,ContentDocumentId
                                    FROM Contentversion                                        
                                    WHERE  Id IN :linkObjIdByDocId.keySet()])
        {
                Id linkEntityId = conDocIdByLinkId.get(conObj.ContentDocumentId);
                if(!rIdByCId.containskey(linkEntityId))
                {
                    rIdByCId.put(linkEntityId, new List<Id>());
                }
                rIdByCId.get(linkEntityId).add(conObj.Id);
        }
        system.debug('ContentDocumentId : '+rIdByCId);
        wrapclass listingObj = new wrapclass();
        listingObj.rIdsWithConIds = rIdByCId;
        listingObj.listingList = listIdByListingRec.values();
        System.debug('listingObject : '+listingObj);
        return listingObj;
    }
    public class wrapclass
     {
        @AuraEnabled
       public map<Id, List<Id>> rIdsWithConIds {get;set;}
       @AuraEnabled
       public List<Listing__c> listingList {get;set;}
    
     }
    }