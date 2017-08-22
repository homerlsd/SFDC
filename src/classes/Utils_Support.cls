global class Utils_Support {
	
	public static Map<integer, string> MonthMap(){
        Map<integer, string> mmap = new Map<integer, string>();
        mmap.put(1,'January');
        mmap.put(2,'February');
        mmap.put(3,'March');
        mmap.put(4,'April');
        mmap.put(5,'May');
        mmap.put(6,'June');
        mmap.put(7,'July');
        mmap.put(8,'August');
        mmap.put(9,'September');
        mmap.put(10,'October');
        mmap.put(11,'November');
        mmap.put(12,'December');
        return mmap;
    }

    public static Map<Decimal,Integer> getCost(string[] rolenames){
    	decimal temp = 0;
    	integer cnt = 0;
    	
    	for(User u : [select id, Annual_Cost__c from User where isActive = true AND UserRole.name IN :rolenames AND CreatedDate < TODAY]){
    		if(u.Annual_Cost__c != null){
    			decimal monthlyCost = u.Annual_Cost__c/12;
    			cnt++;
    			temp+= monthlyCost;
    		}
    	}

    	Map<Decimal,Integer> mappy = new Map<Decimal,Integer>();
    	mappy.put(temp,cnt);

    	return mappy;
    }
}