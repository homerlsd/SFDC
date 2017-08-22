@istest
public class Test_UtilsImplementation {
	
	@istest(seealldata=false)
	static void Test_catalogQuestions() {
		Map<string,List<String>> tempp = Utils_Implementation.catalogQuestions();
		system.assert(tempp != null);
	}
}