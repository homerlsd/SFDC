global class ClientAffiliation_Validator{ 

	private static boolean blnAlreadyDone = false; 

	public static boolean hasAlreadyDone(){ return blnAlreadyDone; }
	 
	public static void setAlreadyDone() {
		blnAlreadyDone = true;
	} 

}