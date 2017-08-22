public with sharing class Utils_Sales {
	
	// Number of dates for ROE
	public static Integer NewOppsDays = 30;
	public static Integer AssociatedOppsDays = 90;

	// Dates and Date Strings
	public static Date OneYearAgoDate {
		get { return Date.today().addYears(-1); }
	}

	public static String OneYearAgoDateString {
		get { return Utils.DateToSOQLdate(OneYearAgoDate); }
	}

	public static DateTime NewOppsDate {
		get { return DateTime.Now().addDays(-1 * NewOppsDays); }
	}

	public static String NewOppsDateString {
		get { return Utils.DateTimeToSoqlDateTime(NewOppsDate); }
	}

	public static DateTime AssociatedOppsDate {
		get { return DateTime.Now().addDays(-1 * AssociatedOppsDays); }
	}

	public static String AssociatedOppsDateString {
		get { return Utils.DateTimeToSoqlDateTime(AssociatedOppsDate); }
	}

	public static String ActiveOwnerId(Id AcctID, String Channel, Id currentUserId) {
		
		Set<ID> RTids = new Set<ID>();
			
		for (Sales_Channel__c c : [select Id, Unapproved_Record_Type_Id__c, Approved_Record_Type_ID__c from Sales_Channel__c where Name = :Channel]) {
			
			RTids.add(c.Unapproved_Record_Type_ID__c);
			RTids.add(c.Approved_Record_Type_Id__c);
		}			

		system.debug('ACCTID IS ' + AcctId);

		system.debug('CHANNEL IS ' + Channel);


		//IF WE GET HERE WE HAVE AN ACTIVE OWNER FOR THE CHANNEL ON A CLOSED OPPTY
		//TODO - FIGURE OUT THE FUCKING RENEWAL STUFF
		for (Opportunity o : [select Id, Name, OwnerId, CreatedDate, Record_Type_name__c, StageName, CloseDate, LastModifiedDate from Opportunity where AccountId = :AcctId AND
			StageName = 'Closed Won'  AND RecordTypeId in :RTids AND Owner.isActive = true ORDER BY CloseDate DESC LIMIT 1]) {
				
			if (o.CloseDate > date.today().addDays(-60) || (o.OwnerId != userInfo.getUserId() && o.CloseDate > oneYearAgoDate)) {
				return o.OwnerId;
			}
			
			if (o.OwnerId == userInfo.getUserID()) {
				return 'false';
			}
			
		}

		List<Opportunity> NewlyCreatedOpps = [select Id, Name, OwnerId, CreatedDate, Record_Type_name__c, StageName, CloseDate, LastModifiedDate from Opportunity where (not StageName like '%lost%') AND AccountId = :AcctId 
			AND RecordTypeId in :RTids AND CreatedDate > :NewOppsDate AND Owner.isActive = true ORDER BY CloseDate DESC];
			

		system.debug('NEWLY CREATED OPPS ARE ' + NewlyCreatedOpps);

		if (NewlyCreatedOpps.size() > 0) {

			return NewlyCreatedOpps[0].OwnerId;
		}

		List<Opportunity> AssociatedOpps = [select Id, Name, OwnerId, CreatedDate, Record_Type_name__c, StageName, CloseDate, LastModifiedDate from Opportunity where AccountId = :AcctId
			AND RecordTypeId in :RTids AND CreatedDate > :AssociatedOppsDate AND Owner.isActive = true ORDER BY CloseDate DESC];
			
		Set<ID> AssociatedOppIDs = new Set<ID>();

		for (Opportunity o : AssociatedOpps) {

			AssociatedOppIds.add(o.id);
		}

		List<Task> recentTsks = [select Id, WhatId, CreatedDate from Task where WhatId in :associatedOppIds AND CreatedDate > :NewOppsDate];
		List<Event> recentEvents = [select Id, WhatId from Event where WhatId in :AssociatedOppIds AND CreatedDate > :NewOppsDate];

		Set<ID> ActiveOppIDs = new Set<ID>();

		if (recentTsks.size() > 0) {

			for (Task t : recentTsks) {

				ActiveOppIds.add(t.WhatId);
			}
		}

		if (recentEvents.size() > 0) {

			for (Event e : recentEvents) {

				ActiveOppIds.add(e.Whatid);
			}
		}

		List<Opportunity> ActiveOpps = [select Id, Name, OwnerId, CreatedDate, Record_Type_name__c, StageName,
			CloseDate, LastModifiedDate from Opportunity where AccountId =
				:AcctId AND Owner.isActive = true  AND RecordTypeId in :RTids
				AND Id in :ActiveOppIds ORDER BY CloseDate DESC];

		system.debug('ACTIVE OPPS ARE ' + ActiveOpps);

		if (ActiveOpps.size() > 0) {

			return ActiveOpps[0].OwnerId;
		}

		return 'false';
	}

	public class salesTaskOrEvent{
		public string recordID          {get; set;}
        public List<string> subject          {get; set;}
        public String whatName          {get; set;}
        public String whoname          {get; set;}
        public string taskOrEvent       {get; set;}
        public string timeStampString       {get; set;}
        public DateTime timeStamp       {get; set;}
	}

	public static salesTaskOrEvent getMostRecentActivty(Id AcctID, string activityType) {
		List<salesTaskOrEvent> activities = new List<salesTaskOrEvent>();
		List<salesTaskOrEvent> finalactivities = new List<salesTaskOrEvent>();
		for (Opportunity o : [select Id,
									 Name,
									 OwnerId,
									 Owner.name,
									 CreatedDate,
									 Record_Type_name__c,
									 StageName,
									 CloseDate,
									 LastModifiedDate,
									 (select id, subject, type, status, CreatedDate, who.name,What.name, LastModifiedDate, ActivityDate from Tasks ORDER BY ActivityDate DESC),
									 (select id, subject, type, ActivityDateTime, who.name,What.name,CreatedDate, LastModifiedDate from Events ORDER BY ActivityDateTime DESC)
									 from Opportunity
									 where AccountId = :AcctId
									 ORDER BY CloseDate DESC]) {

			if(!o.tasks.isEmpty() && activityType == 'Task'){
				for(task ts : o.tasks){
					salesTaskOrEvent tsk = new salesTaskOrEvent();
					tsk.recordID = ts.id;
					tsk.timeStampString = ts.ActivityDate.format();
					tsk.timeStamp = DateTime.newInstance(ts.ActivityDate.year(),ts.ActivityDate.month(),ts.ActivityDate.day());
					tsk.subject = new List<String>();
					tsk.subject.add('Subject: ' + ts.subject + ' - Contact: ' + ts.who.name);
					tsk.subject.add('Related to Opportunity: ' + o.name + ' - Stage: ' + o.StageName);
					tsk.subject.add('Record Type: ' + o.Record_Type_name__c + ' - Owner: ' + o.owner.name);
					activities.add(tsk);
				}
			}
			else if(o.events.isEmpty() && activityType == 'Event'){
				for(event ev : o.Events){
					salesTaskOrEvent evnt = new salesTaskOrEvent();
					evnt.recordID = ev.id;
					evnt.timeStampString = ev.ActivityDateTime.format('MMM dd, yyyy hh:mma z');
					evnt.timeStamp = ev.ActivityDateTime;
					evnt.subject = new List<String>();
					evnt.subject.add(ev.type + ' Event: ' + ev.subject + ' with ' + ev.who.name);
					evnt.subject.add('Related Opportunity: ' + o.name + ' - Stage: ' + o.StageName);
					evnt.subject.add('Record Type: ' + o.Record_Type_name__c + ' - Owner: ' + o.owner.name);
					activities.add(evnt);
				}
			}
		}

		if(!activities.isEmpty()){
			DateTime currentTimeStamp = datetime.now();
			for(salesTaskOrEvent ste : activities){
				if(finalactivities.isEmpty() || (ste.timeStamp > currentTimeStamp)){
					currentTimeStamp = ste.timeStamp;
					finalactivities.clear();
					finalactivities.add(ste);
				}
			}
			return finalactivities[0];
		}
		else return null;
	}		
}