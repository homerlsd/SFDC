public class Implementationviewpagecontroller
{
    public List<QuickLinks__c> links{get;set;}
     public String imageURL{get;set;}
     public integer count{get; set;}
     
     
    public Implementationviewpagecontroller()
    {
        Map<String,QuickLinks__c> alllinks = QuickLinks__c.getAll();
        links = alllinks.values();
        
        count=links.size();
        
        imageURL='/servlet/servlet.FileDownload?file=';
        List< document > documentList=[select name from document where 
                                    Name='Rally Icon'];
   
        if(documentList.size()>0)
        {
          imageURL=imageURL+documentList[0].id;
        }
        
    }  
   
}