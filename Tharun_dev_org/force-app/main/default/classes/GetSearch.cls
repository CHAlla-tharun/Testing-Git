public with sharing class GetSearch {
    @AuraEnabled(cacheable=true)
        public static ListingAndCvIdsWrapper getRecords(String value )
    {
        string searchTripLocation = '%' + value + '%';
        Map<Id, Listing__c> idAndObj = new Map<Id, Listing__c>([SELECT Id, Name, State2__c, Duration__c, Catageroy__c, BasePrice__c
                                                                FROM Listing__c
                                                                WHERE State2__c LIKE :searchTripLocation]);
        Map<Id, Id> cdIdToLeId = new Map<Id, Id>();
        if(!idAndObj.isEmpty())
        {
            for(ContentDocumentLink cdl : [SELECT ContentDocumentId, LinkedEntityId
                                       FROM ContentDocumentLink
                                       WHERE LinkedEntityId IN :idAndObj.keySet()])
            {
                cdIdToLeId.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
            }
        }
        Map<Id, List<string>> recIdtoCvIds = new Map<Id, List<string>>();
        for(ContentVersion cv : [SELECT Id, ContentDocumentId
                                FROM ContentVersion
                                WHERE ContentDocumentId IN :cdIdToLeId.keySet()])
        {
            if(!recIdtoCvIds.containsKey(cdIdToLeId.get(cv.ContentDocumentId)))
            {
                recIdtoCvIds.put(cdIdToLeId.get(cv.ContentDocumentId), new List<string>());
            }
            recIdtoCvIds.get(cdIdToLeId.get(cv.ContentDocumentId)).add('/sfc/servlet.shepherd/version/download/'+cv.Id);
        }
        ListingAndCvIdsWrapper wrp = new ListingAndCvIdsWrapper();
        wrp.listings = idAndObj.values();
        wrp.recordIdToCvid = recIdtoCvIds;
        return wrp;
    }
    public class ListingAndCvIdsWrapper
    {
        @AuraEnabled
        public List<Listing__c> listings;
        @AuraEnabled
        public Map<Id, List<string>> recordIdToCvid;
    }
}




        

