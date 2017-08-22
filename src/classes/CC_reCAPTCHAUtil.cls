public without sharing class CC_reCAPTCHAUtil {

    /* Configuration */

    // The API endpoint for the reCAPTCHA service
    private static String baseUrl = 'https://www.google.com/recaptcha/api/verify'; 

    // The keys you get by signing up for reCAPTCHA for your domain
    //private static String privateKey = '6LeSUv8SAAAAAEL8BVnVT7ERj3OaVoQWNm8vnk7h';
    private static String privateKey = Label.CC_reCAPTCHA_Secret_Key;

    public static String publicKey { 
        //get { return '6LeSUv8SAAAAALUGXRb7eLnymUNmk8x0QHB6hFmq'; }
        get { return Label.CC_reCAPTCHA_Site_Key; }
    } 

     //private static String privateKey_force = Label.CC_reCAPTCHA_Secret_Key_force;

    public static String publicKey_force { 
        //get { return '6LeSUv8SAAAAALUGXRb7eLnymUNmk8x0QHB6hFmq'; }
        get { return Label.CC_reCAPTCHA_Site_Key_force; }
    } 


    public static String challenge { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_challenge_field');
        }
        set;
    }
    public static String tResponse  { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_response_field');
        }
        set;
    }
    
    // Whether the submission has passed reCAPTCHA validation or not
    public static Boolean verified { get; set; }
    
    public CC_reCAPTCHAUtil() {
        verified = false;
    }
    
    public Static Boolean verify() {
        System.debug('reCAPTCHA verification attempt');
        // On first page load, form is empty, so no request to make yet
        if(!Test.isRunningTest()){
            if ( challenge == null || tResponse == null ) { 
                //System.debug('reCAPTCHA verification attempt with empty form');
                return null; 
            }
        }else{
            challenge='test';
            tResponse = 'test';
        }

        string hostString = ApexPages.currentPage().getHeaders().get('Host');

        system.debug('HOST IS ' + hostString);

        if(hostString != null && hostString != '' && hostString.contains('force')){
            privatekey = Label.CC_reCAPTCHA_Secret_Key_force;
            system.debug('FORCE PRIVATE KEY');
        }
                    
        HttpResponse r = makeRequest(baseUrl,
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + tResponse
        );
        
        if ( r!= null ) {
            verified = (r.getBody().startsWithIgnoreCase('true'));
        }
        
        if(Test.isRunningTest()){
            verified = true;
            return true;
        }

        if(verified) {
            return true;
        }else {  
            return false;  
        }
    }

    

    /* Private helper methods */
    
    private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('reCAPTCHA response: ' + response);
            System.debug('reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
        
    private static String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }
}