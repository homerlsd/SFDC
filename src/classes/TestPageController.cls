public class TestPageController {
public String urlStuff { get; set; }
public String valueLat { get; set; }

public TestPageController(){
	urlStuff = ApexPages.currentPage().getHeaders().get('Host');
}
	
public PageReference iFoundYou() {
// Do something interesting with the values - like persisting them to a database
return null;
}
}