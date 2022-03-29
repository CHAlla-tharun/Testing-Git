public with sharing class UiApex {
   @AuraEnabled()
   public static void listofvalues(Listing__c  ListingDetails)
   {
       insert ListingDetails;
   }
   @AuraEnabled()
   public static List<string> getCategorypicklist(){
       List<String> category = new List<String>();
       Schema.DescribeFieldResult fieldlistresult=Listing__c.Catageroy__c.getDescribe();
       List<Schema.PicklistEntry>  categorylist=fieldlistresult.getPicklistValues();
       for(Schema.PicklistEntry oneof:categorylist  )
       {
           category.add(oneof.getvalue());
       }
       return category;
   }
   @AuraEnabled()
   public static List<string> Durationpicklist(){
      List<String> Duration = new List<String>();
      Schema.DescribeFieldResult  fieldofduration=Listing__c.Duration__c.getDescribe();
      List<Schema.PicklistEntry> Durationlist=fieldofduration.getPicklistValues();
      for(Schema.PicklistEntry oneoff: Durationlist )
      {
       Duration.add(oneoff.getvalue());
      }
      return Duration;
   }
   @AuraEnabled()
   public static List<string> statepicklist(){
      List<String> state = new List<String>();
      Schema.DescribeFieldResult  fieldofstate=Listing__c.State2__c.getDescribe();
      List<Schema.PicklistEntry> statelist=fieldofstate.getPicklistValues();
      for(Schema.PicklistEntry oneoff1: statelist )
      {
       state.add(oneoff1.getvalue());
      }
      return state;
   }
   @AuraEnabled()
   public static List<string> statuspicklist(){
      List<String> status = new List<String>();
      Schema.DescribeFieldResult  fieldofstatus=Listing__c.Status__c.getDescribe();
      List<Schema.PicklistEntry> statuslist=fieldofstatus.getPicklistValues();
      for(Schema.PicklistEntry oneoff2: statuslist )
      {
       status.add(oneoff2.getvalue());
      }
      return status;
    }
    @AuraEnabled()
    public static string insertListing(Listing__c gtList, string file, string fileName){
        string listId;
      try{
          insert gtList;
          listId = gtList.Id;
          String base64File = EncodingUtil.urlDecode(file, 'UTF-8');
          ContentVersion contentVersionRec = new ContentVersion();
          contentVersionRec.Title = fileName;
          contentVersionRec.PathOnClient = '/' + fileName;
          contentVersionRec.FirstPublishLocationId = gtList.Id;
          contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);
          contentVersionRec.IsMajorVersion = true;
          Insert contentVersionRec;
        } catch(Exception ex){
          system.debug('Exception===>'+ex.getMessage());
        }
        return listId;
      }
}

