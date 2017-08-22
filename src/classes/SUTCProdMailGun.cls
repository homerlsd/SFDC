public class SUTCProdMailGun {
    @future (callout=true)
    public static void sendRequest (String email, String msg) {

        String APIKey = SUTC.MAILGUN_API_KEY;
        String APIEndPoint = SUTC.MAILGUN_API_ENDPOINT;
        Blob headerValue = Blob.valueOf('api:' + APIKey);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        String body = 'to=' + email;
        body += '&from=' + SUTC.EMAIL_FROM;
        body += '&subject=' + SUTC.EMAIL_SUBJECT;
        body += '&html=' + EncodingUtil.urlEncode(msg, 'UTF-8');
        Integer bodyLength = Body.length();

        HttpRequest req = new HttpRequest();
        req.setEndPoint(APIEndPoint);
        req.setMethod('POST');
        req.setHeader('Host', 'api.mailgun.net');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Length', string.valueOf(bodyLength));
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody(body);

        System.debug('== Request to send ==');
        System.debug(req.getBody());
        Http http = new Http();
        http.send(req);
    }
}