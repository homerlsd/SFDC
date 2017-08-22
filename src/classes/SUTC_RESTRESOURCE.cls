@RestResource(urlMapping='/SUTC/*')
global with sharing class SUTC_RESTRESOURCE {

    global class survey {
        public String firstname;
        public String lastname;
        public String age;
        public String email;
        public String sex;
        public String optin;
        public String pledgenum;
    }


    @HttpGet
    global static void getSUTCPledgeTotal() {
        decimal statNumber = [SELECT Auto_Number__c FROM SUTCStat__c WHERE Auto_Number__c != NULL ORDER BY Auto_Number__c DESC LIMIT 1].Auto_Number__c;
        
        if(statNumber != null){
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf('{ "pledges" : "' + string.valueOf(statNumber) + '"}');
        }
        
    }

    /*@HttpPost
    global static void createNewSUTCList(survey[] surveys) {

        string query = 'select id,First_Name__c,Last_Name__c,Age__c,Sex__c,Email__c,Pledge_Num__c,Email_optin__c from SUTCSurvey__c where First_Name__c == null LIMIT ' + surveys.size(); 
        
        SUTCSurvey__c[] recs = database.query(query);
        SUTCSurvey__c[] newRecs = new List<SUTCSurvey__c>();



        integer i = -1;

        for(survey s : surveys){
            i++;
            SUTCSurvey__c rec = new SUTCSurvey__c();
            if(i <= rec.size())
                rec.id = recs[i].id;
            rec.First_Name__c = s.firstname;
            rec.Last_Name__c = s.lastname;
            rec.Age__c = decimal.valueOf(s.Age);
            rec.Email__c = s.email;
            rec.Sex__c = s.Sex;
            rec.Pledge_Num__c = decimal.valueOf(s.pledgenum);
            rec.Email_optin__c= s.optin == 'true' ? true : false;
            newRecs.add(rec);
        }
        

        //String msg = SUTCEmailMessageTemplates.htmlTemplate(email, firstname, decimal.valueOf(age), sex);

        upsert newRecs;

        //if(!test.isRunningTest())
            //SUTCProdMailGun.sendRequest(rec.Email__c, msg);
    }*/

    @HttpPost
    global static void createNewSUTC(String firstname, String lastname, String age, String email, String sex, String optin, String pledgenum) {

        SUTCSurvey__c rec = new SUTCSurvey__c();

        rec.First_Name__c = firstname;
        rec.Last_Name__c = lastname;
        rec.Age__c = decimal.valueOf(Age);
        rec.Email__c = email;
        rec.Sex__c = Sex;
        rec.Pledge_Num__c = decimal.valueOf(pledgenum);
        rec.Email_optin__c= optin == 'true' ? true : false;

        String msg = SUTCEmailMessageTemplates.htmlTemplate(email, firstname, decimal.valueOf(age), sex);

        insert rec;

        if(!test.isRunningTest())
            SUTCProdMailGun.sendRequest(rec.Email__c, msg);

    }
    
    @HttpPut
    global static void createSUTCPledgeNum() {
        SUTCStat__c sutcs = new SUTCStat__c();
        insert sutcs;
        decimal statNumber = [SELECT Auto_Number__c FROM SUTCStat__c WHERE ID = :sutcs.id LIMIT 1].Auto_Number__c;

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf('{ "pledge_num" : "' + string.valueOf(statNumber) + '"}');
    }

}