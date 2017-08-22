@istest
public class Test_LiveAgentChatButton {

	@istest(seealldata=false)
	static void LAChatButton() {
		Contact c = new contact(lastname ='testsdvsdfsdFs');
		insert c;

		LiveAgentChatButton.getContact(c.id);

	}
}