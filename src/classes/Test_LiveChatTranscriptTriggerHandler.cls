@istest
public class Test_LiveChatTranscriptTriggerHandler {
	
	@istest(seealldata=false)
	static void Test_Upsert() {
		//Set up test data

		Contact con = new Contact(email=Label.Test_LiveChatTranscriptTriggerHandler_email,lastName='LeBeau');
		insert con;

		Case c = new Case(subject='test',contactid=con.id,Live_Agent_Transcript_Send_Email__c = Label.Test_LiveChatTranscriptTriggerHandler_email, Send_Live_Agent_Transcript__c=true);
		insert c;

		LiveChatVisitor lv = new LiveChatVisitor();
		insert lv;

		LiveCHatTranscript t = new LiveCHatTranscript(body='089-43-4545',LiveChatVisitorID = lv.id,caseID=c.id);
		insert t;

		LiveCHatTranscript ocr = [select id, body,Send_Transcript_Email__c from LiveCHatTranscript where id = : t.id];
		system.assert(ocr.body.contains('XXX-XX-XXXX'));
		system.assert(ocr.Send_Transcript_Email__c == true);
	}
}