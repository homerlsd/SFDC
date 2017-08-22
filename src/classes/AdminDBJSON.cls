public class AdminDBJSON {

	//SAMPLE JSON STRING THAT THIS CLASS IS EXPECTING:
	//{ "username" : "someUsername", "Attributes" : { "rallyID" : "SomeRallyID", "client" : "someClient", "affiliation" : "someAffiliation" } }

	public class Attributes {
		public String rallyID;
		public String client;
		public String affiliation;
	}

	public String username;
	public Attributes Attributes;

	
	public static AdminDBJSON parse(String json) {
		return (AdminDBJSON) System.JSON.deserialize(json, AdminDBJSON.class);
	}
}