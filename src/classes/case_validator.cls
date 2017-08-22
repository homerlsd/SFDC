global class case_validator{ 

	private static boolean blnAlreadyDone = false; 

	public static boolean hasAlreadyDone(){ return blnAlreadyDone; }
	 
	public static void setAlreadyDone() {
		blnAlreadyDone = true;
	} 

}