/**
	@author 7S
	@version Nov 4 2014 
	All Constants in CC_ Customer Communtiy App
*/
public without sharing class CC_Constants {
    // query used in this app
	public static  String BASE_QUERY= 'SELECT Id,Custom_Link_Text__c,KnowledgeArticleID,channel__c,Specific_Group_Client__c,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,Group_Name__c,Category__c, Is_Common_Question__c,Is_Default_Question__c,title,summary, UrlName, LastPublishedDate,LastModifiedById,RichTextSummary__c,Publish_Date_Future__c FROM Question__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
	public static  String BASE_QUERY_UNPUBLISHED= 'SELECT Id,Custom_Link_Text__c,KnowledgeArticleID,channel__c,Specific_Group_Client__c,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,Group_Name__c,Category__c, Is_Common_Question__c,Is_Default_Question__c,title,summary, UrlName, LastPublishedDate,LastModifiedById,RichTextSummary__c,Publish_Date_Future__c FROM Question__kav WHERE (PublishStatus = \'draft\' and Language = \'en_US\')';
	public static  String BASE_QUERY_ARCHIVED= 'SELECT Id,Custom_Link_Text__c,KnowledgeArticleID,channel__c,Specific_Group_Client__c,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,Group_Name__c,Category__c, Is_Common_Question__c,Is_Default_Question__c,title,summary, UrlName, LastPublishedDate,LastModifiedById,RichTextSummary__c,Publish_Date_Future__c FROM Question__kav WHERE (PublishStatus = \'archived\' and Language = \'en_US\')';
	public static  String BASE_QUERY_EDIT= 'SELECT Id,Custom_Link_Text__c,KnowledgeArticleID,channel__c,Specific_Group_Client__c,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,Group_Name__c,Category__c, Is_Common_Question__c,Is_Default_Question__c,title,summary, UrlName, LastPublishedDate,LastModifiedById,RichTextSummary__c,Publish_Date_Future__c FROM Question__kav WHERE ';
	public static  String BASE_QUERY_DYNAMIC= 'SELECT Id,Custom_Link_Text__c,KnowledgeArticleID,channel__c,Specific_Group_Client__c,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,Group_Name__c,Category__c, Is_Common_Question__c,Is_Default_Question__c,title,summary, UrlName, LastPublishedDate,LastModifiedById,RichTextSummary__c,Publish_Date_Future__c FROM ';
	public static  String BASE_QUERY_COUNT_PUBLISHED= 'SELECT COUNT() FROM Question__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
	public static  String BASE_QUERY_COUNT_UNPUBLISHED= 'SELECT COUNT() FROM Question__kav WHERE (PublishStatus = \'draft\' and Language = \'en_US\')';

	public static  String BASE_QUERY_INTERNAL= 'SELECT Id,Troubleshooting_Steps__c,Partner__c,KnowledgeArticleID,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,title,summary, UrlName, LastPublishedDate,LastModifiedById FROM Internal__Kav WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
	public static  String BASE_QUERY_INTERNAL_UNPUBLISHED= 'SELECT Id,Troubleshooting_Steps__c,Partner__c,KnowledgeArticleID,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,title,summary, UrlName, LastPublishedDate,LastModifiedById FROM Internal__Kav WHERE (PublishStatus = \'draft\' and Language = \'en_US\')';
	public static  String BASE_QUERY_INTERNAL_ARCHIVED= 'SELECT Id,Troubleshooting_Steps__c,Partner__c,KnowledgeArticleID,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,title,summary, UrlName, LastPublishedDate,LastModifiedById FROM Internal__Kav WHERE (PublishStatus = \'archived\' and Language = \'en_US\')';
	public static  String BASE_QUERY_INTERNAL_EDIT= 'SELECT Id,Troubleshooting_Steps__c,Partner__c,KnowledgeArticleID,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,title,summary, UrlName, LastPublishedDate,LastModifiedById FROM Internal__Kav WHERE ';
	public static  String BASE_QUERY_INTERNAL_DYNAMIC= 'SELECT Id,Troubleshooting_Steps__c,Partner__c,KnowledgeArticleID,channel__c,Specific_Group_Client__c,ArticleType,CreatedBy.Name,LastModifiedBy.Name,ArticleNumber,PublishStatus,title,summary, UrlName, LastPublishedDate,LastModifiedById FROM ';
	public static  String BASE_QUERY_INTERNAL_COUNT_PUBLISHED= 'SELECT COUNT() FROM Internal__Kav WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
	public static  String BASE_QUERY_INTERNAL_COUNT_UNPUBLISHED= 'SELECT COUNT() FROM Internal__Kav WHERE (PublishStatus = \'draft\' and Language = \'en_US\')';

    public static final String DEFAULT_GROUP_NAME= Label.CC_Default_Group_Name;
    public static final String DEFAULT_GROUP_ID= Label.CC_Default_Group_ID;
    public static final String DEFAULT_CHANNEL_ID= Label.CC_Default_Channel_ID;
    public static final String DEFAULT_CASE_RECORDTYPE_ID= Label.CC_Default_CASE_RECORDTYPE_ID;
    public static final String DEFAULT_TIER2_RECORDTYPE_ID= Label.Default_Tier_2_Case_ID;
    public static final String DEFAULT_CHANNEL_NAME= Label.CC_Default_Channel_Name;
    public static final String DEFAULT_KBARCHIVED_ID= Label.CC_Default_Archived_KB_ID;
    public static final String DEFAULT_UNPUBLISHED_QUESTION= Label.CC_Default_Unpublished_Question_ID;
    public static final String DEFAULT_PARTNER_ID= Label.DEFAULT_PARTNER_ID;

							
    public static String CUSTOMER_COMMUNITY_PROFILE_NAME = 'Rally Customer Community Login User';
    
    static public Id CUSTOMER_COMMUNITY_PROFILE_Id {
		get{
			if(CUSTOMER_COMMUNITY_PROFILE_Id  == null){
	
				List<Profile> profiles = [select Id from Profile where Name = :CUSTOMER_COMMUNITY_PROFILE_NAME];
            	CUSTOMER_COMMUNITY_PROFILE_Id = profiles[0].id;           
			}
			return CUSTOMER_COMMUNITY_PROFILE_Id;
		}
		set;
	}
	
}