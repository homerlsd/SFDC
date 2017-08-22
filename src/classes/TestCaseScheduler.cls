@istest
private class TestCaseScheduler {
	public TestCaseScheduler() {
		CaseScheduler cs = new CaseScheduler();
		database.executeBatch(cs,200);
	}
}