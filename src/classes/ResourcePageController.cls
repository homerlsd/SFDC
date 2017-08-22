public class ResourcePageController {
  public string Resourcename{get; set;}
  
  
  public List<Resource_Page_Category__c> getresourcecategory(){
     
     List<Resource_Page_Category__c> lstcat=[select Name, Category_Title__c, Link_Title_and_URL__c from Resource_Page_Category__c where Resource_Page_Requirement__c IN (select Id from Resource_Page_Requirement__c where Name=:Resourcename)];
     return lstcat;
  }
  
  public List<Resource_Page_Promotion__c> getresourcepromotion(){
     List<Resource_Page_Promotion__c> lstcatp=[Select Id, Name, RecordTypeId, Resource_Page_Requirement__c, Additional_Information__c, Background_Color_Code__c, Background_Color__c, CTA_Type__c, Client_Logo_ID__c, Client_Logo__c, Client_Request_for_Current_Promo_Email__c, Current_Promo_Abbreviated_Body__c, Current_Promo_Body__c, Current_Promo_Email_Send_Date__c, Current_Promo_Headline__c, Current_Promo_Type__c, Featured_Promo_Abbreviated_Body__c, Featured_Promo_Body__c, Featured_Promo_Headline__c, Implementation_ID__c, Launch_DateString__c, Launch_Date__c, Overall_Page_Body_Text__c, Overall_Page_Headline__c, Priority_Number__c, Promo_CTA_Link__c, Promo_Image_URL__c, Promo_Link_CTA_Copy__c, Promo_Phone_CTA_Footer__c, Promo_Phone_CTA_Header__c, Promo_Phone_Number_2__c, Promo_Phone_Number__c, Promo_Tag_1__c, Promo_Tag_2__c, Promo_Tag_3__c, Promo_Tag_4__c, Promo_Tag_5__c, Promotion_End_DateString__c, Promotion_End_Date__c, Promotion_Start_DateString__c, Promotion_Start_Date__c, Requester_Contact_Email__c, Requester_Contact_Name__c, Tag_1__c, Tag_2__c, Tag_3__c, Tag_4__c, Tag_5__c, Tagging_Logic__c, Text_Color_Code__c, Text_Color__c FROM Resource_Page_Promotion__c where Resource_Page_Requirement__c in (select Id from Resource_Page_Requirement__c where Name=:Resourcename)];

     return lstcatp;
  }
 
}