global class CC_UrlRewriter implements Site.UrlRewriter {

    
  global static String DATACAT_PAGE = '/datacat/';
  global static String DATACAT_VISUALFORCE_PAGE = '/CC_KnowledgeByDataCategory?';
    
  global static String DETAIL_PAGE = '/detail/id';
  global static String DETAIL_VISUALFORCE_PAGE = '/CC_KnowledgeDetail?';

  global static String SEARCH_RESULTS_PAGE = '/results/';
  //global static String SEARCH_RESULTS_VISUALFORCE_PAGE = '/CC_KnowledgeSearch?SearchString=';
  global static String SEARCH_RESULTS_VISUALFORCE_PAGE = '/CC_KnowledgeSearch?';

  global static String CASE_THANKYOU_PAGE = '/case/thankyou/';
  global static String CASE_THANKYOU_VISUALFORCE_PAGE = '/CC_SupportCase?';
  
  global static String CASE_THANKYOU_PAGE_CLIENT = '/client/thankyou/';
  global static String CASE_THANKYOU_VISUALFORCE_PAGE_CLIENT = '/CC_ClientCase?';
  
  global static String CREATE_CASE_PAGE = '/case/';
  global static String CREATE_CASE_VISUALFORCE_PAGE = '/CC_SupportCase';
  
  global static String HOME_PAGE = '/';
  global static String HOME_VISUALFORCE_PAGE = '/CC_SupportHome';

  global static String CHOICE_HOME_PAGE = '/choice/';
  global static String CHOICE_HOME_VISUALFORCE_PAGE = '/CC_SupportHome?channel=choice';

  global static String CHOICE_CLIENT_HOME_PAGE = '/client/';
  global static String CHOICE_CLIENT_HOME_VISUALFORCE_PAGE = '/CC_ClientCase';
  
  

  global PageReference mapRequestUrl(PageReference myFriendlyUrl) {
    String url = myFriendlyUrl.getUrl();
        
    if (url.startsWith(DATACAT_PAGE)) { 
        String dataCatStringWhole = url.substring(DATACAT_PAGE.length(), url.length());
        String[] dataCatString = dataCatStringWhole.split('/');
        if(dataCatString.size()==2){
      return new PageReference(DATACAT_VISUALFORCE_PAGE + 'DataCategoryGroupName='+dataCatString[0] + '&DataCategoryName='+dataCatString[1]);
        }else {
            return new PageReference(url);
        }
    }
    else if (url.startsWith(DETAIL_PAGE)) { 
      String detailStringWhole = url.substring(DETAIL_PAGE.length(), url.length());
        String[] detailString = detailStringWhole.split('/');
        if(detailString.size()==2){
      return new PageReference(DETAIL_VISUALFORCE_PAGE + 'KnowledgeId='+detailString[0]+'&DataCategoryGroupName=' + detailString[1]);
        }else {
            return new PageReference(url);
        }
    }
    else if (url.startsWith(SEARCH_RESULTS_PAGE)) { 
  String WholeString = url.substring(SEARCH_RESULTS_PAGE.length(), url.length());
        String[] sString = WholeString.split('&');
        if(sString.size()==2){
           String[] nString = sString[0].split('=');
           String searchString = '';
           if(nString.size()==2){
               searchString = nString[1];
           }
           String[] wString = sString[1].split('=');
           String groupName = '';
           if(wString.size()==2){
               groupName = wString[1];
           }
      return new PageReference(SEARCH_RESULTS_VISUALFORCE_PAGE + 'SearchString='+searchString+'&DataCategoryGroupName=' + groupName);
        }else {
            return new PageReference(url);
        }

    }
    else if (url.startsWith(CASE_THANKYOU_PAGE)){ 
      String WholeString = url.substring(CASE_THANKYOU_PAGE.length(), url.length());
            String[] sString = WholeString.split('/');
            if(sString.size()==2){
          return new PageReference(CASE_THANKYOU_VISUALFORCE_PAGE + 'thankyou='+sString[0]+'&DataCategoryGroupName=' + sString[1]);
            }else {
                return new PageReference(url);
            }
    }
    else if (url.startsWith(CASE_THANKYOU_PAGE_CLIENT)){ 
      String WholeString = url.substring(CASE_THANKYOU_PAGE_CLIENT.length(), url.length());
            String[] sString = WholeString.split('/');
            if(sString.size()==2){
          return new PageReference(CASE_THANKYOU_VISUALFORCE_PAGE_CLIENT + 'thankyou='+sString[0]+'&DataCategoryGroupName=' + sString[1]);
            }else {
                return new PageReference(url);
            }
    }
    else if (url.startsWith(CREATE_CASE_PAGE)) 
    { 
       String groupName = url.substring(CREATE_CASE_PAGE.length(), url.length());
      return new PageReference(CREATE_CASE_VISUALFORCE_PAGE +'?DataCategoryGroupName='+groupName);
    }
    else if (url.startsWith(CHOICE_HOME_PAGE)) { 
      return new PageReference(CHOICE_HOME_VISUALFORCE_PAGE);
    }
    else if (url.startsWith(CHOICE_CLIENT_HOME_PAGE)) { 
      system.debug(CHOICE_CLIENT_HOME_VISUALFORCE_PAGE);
      return new PageReference(CHOICE_CLIENT_HOME_VISUALFORCE_PAGE +'?channel=choice');
    }
    else if (url.equalsIgnoreCase(HOME_PAGE)) { 
      return new PageReference(HOME_VISUALFORCE_PAGE);
    }

    return null;
  }
  
  global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls) {
   
    List<PageReference> myFriendlyUrls = new List<PageReference>();
    
    for (PageReference mySalesforceUrl : mySalesforceUrls) {

      String url = mySalesforceUrl.getUrl();
      
        if (url.startsWith(DATACAT_VISUALFORCE_PAGE)) {
         String wholeString= url.substring(DATACAT_VISUALFORCE_PAGE.length(),
                        url.length());
              String[] labelAndName = wholeString.split('&');
              if(labelAndName.size()>1){
                  String groupName='';
                  String name='';

                  for(String s: labelAndName){
                      if(s.startsWith('DataCategoryName=')){
                          name= s.substring('DataCategoryName='.length(),
                           s.length());
                         
                      }else if(s.startsWith('DataCategoryGroupName=')){
                          groupName= s.substring('DataCategoryGroupName='.length(),
                           s.length());
                         
                      }
                  }
                  myFriendlyUrls.add(new PageReference(DATACAT_PAGE + groupName+'/'+name));
              }else {
                  myFriendlyUrls.add(mySalesforceUrl);
              }
                    
        
      }
      else if (url.startsWith(DETAIL_VISUALFORCE_PAGE)) {
        String wholeString= url.substring(DETAIL_VISUALFORCE_PAGE.length(),
                        url.length());
              String[] idAndGroupName = wholeString.split('&');
              if(idAndGroupName.size()>1){
                  String groupName='';
                  String id='';

                  for(String s: idAndGroupName ){
                      if(s.startsWith('KnowledgeId=')){
                            id= s.substring('KnowledgeId='.length(),
                           s.length());
            }else if(s.startsWith('DataCategoryGroupName=')){
                          groupName= s.substring('DataCategoryGroupName='.length(), s.length());
                         
                      }
                }
                  myFriendlyUrls.add(new PageReference(DETAIL_PAGE + id+'/'+  groupName));
              }else {
                  myFriendlyUrls.add(mySalesforceUrl);
              }
                    
      }
      else if (url.startsWith(SEARCH_RESULTS_VISUALFORCE_PAGE)) {
        String wholeString= url.substring(SEARCH_RESULTS_VISUALFORCE_PAGE.length(),
                        url.length());
              String[] sString = wholeString.split('&');
              if(sString.size()>1){
                  String search='';
                  String groupName='';

                  for(String s: sString){
                      if(s.startsWith('SearchString=')){
                            search= s.substring('SearchString='.length(),
                           s.length());
            }else if(s.startsWith('DataCategoryGroupName=')){
                          groupName= s.substring('DataCategoryGroupName='.length(), s.length());
                         
                      }
                }
                  myFriendlyUrls.add(new PageReference(SEARCH_RESULTS_PAGE + search+'/'+  groupName));
              }else {
                  myFriendlyUrls.add(mySalesforceUrl);
              }
        
      }
      else if (url.startsWith(CASE_THANKYOU_VISUALFORCE_PAGE)) {
                    
      String wholeString= url.substring(CASE_THANKYOU_VISUALFORCE_PAGE.length(),
                 url.length());
              String[] sString = wholeString.split('&');
              if(sString.size()>1){
                  String thankyou='';
                  String groupName='';

                  for(String s: sString){
                      if(s.startsWith('thankyou=')){
                            thankyou= s.substring('thankyou='.length(),
                           s.length());
            }else if(s.startsWith('DataCategoryGroupName=')){
                          groupName= s.substring('DataCategoryGroupName='.length(), s.length());
                         
                      }
                }
                  myFriendlyUrls.add(new PageReference(CASE_THANKYOU_PAGE + thankyou+'/'+  groupName));
              }else {
                  myFriendlyUrls.add(mySalesforceUrl);
              }
        
      }
      else if (url.startsWith(CASE_THANKYOU_VISUALFORCE_PAGE_CLIENT)) {
                    
      String wholeString= url.substring(CASE_THANKYOU_VISUALFORCE_PAGE_CLIENT.length(),
                 url.length());
              String[] sString = wholeString.split('&');
              if(sString.size()>1){
                  String thankyou='';
                  String groupName='';

                  for(String s: sString){
                      if(s.startsWith('thankyou=')){
                            thankyou= s.substring('thankyou='.length(),
                           s.length());
            }else if(s.startsWith('DataCategoryGroupName=')){
                          groupName= s.substring('DataCategoryGroupName='.length(), s.length());
                         
                      }
                }
                  myFriendlyUrls.add(new PageReference(CASE_THANKYOU_PAGE_CLIENT + thankyou+'/'+  groupName));
              }else {
                  myFriendlyUrls.add(mySalesforceUrl);
              }
        
      }
      else if (url.startsWith(CREATE_CASE_VISUALFORCE_PAGE)) {
                    
        myFriendlyUrls.add(new PageReference(CREATE_CASE_PAGE));
        
      }
      else
      {
        myFriendlyUrls.add(mySalesforceUrl);
      }
    }
    return myFriendlyUrls;
    //return null;
  }
  
}