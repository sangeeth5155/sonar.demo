trigger OrientationTraining_AT on Orientation_Training__c (before insert,before update) {

  Map<String, Decimal> timeConversion = new Map<String, Decimal>();
  timeConversion.put('7:00:AM',7.00);
  timeConversion.put('7:30:AM',7.30);
  timeConversion.put('8:00:AM',8.00);
  timeConversion.put('8:30:AM',8.30);
  timeConversion.put('9:00:AM',9.00);
  timeConversion.put('9:30:AM',9.30);
  timeConversion.put('10:00:AM',10.00);
  timeConversion.put('10:30:AM',10.30);
  timeConversion.put('11:00:AM',11.00);
  timeConversion.put('11:30:AM',11.30);
  timeConversion.put('12:00:PM',12.00);
  timeConversion.put('12:30:PM',12.30);
  timeConversion.put('1:00:PM',13.00);
  timeConversion.put('1:30:PM',13.30);
  timeConversion.put('2:00:PM',14.00);
  timeConversion.put('2:30:PM',14.30);
  timeConversion.put('3:00:PM',15.00);
  timeConversion.put('3:30:PM',15.30);
  timeConversion.put('4:00:PM',16.00);
  timeConversion.put('4:30:PM',16.30);
  timeConversion.put('5:00:PM',17.00);
  timeConversion.put('5:30:PM',17.30);
  timeConversion.put('6:00:PM',18.00);
  timeConversion.put('6:30:PM',18.30);
  timeConversion.put('7:00:PM',19.00);
  
  
  for(Orientation_Training__c currRec : Trigger.new)
  {
       Decimal startTime;
       Decimal endTime;
       
        if(currRec.Start_Time__c == Null && currRec.End_Time__c != Null)
           currRec.addError('Please Enter Start Time ');
        if(timeConversion.containskey(currRec.Start_Time__c))
        {
            startTime = timeConversion.get(currRec.Start_Time__c);
        }
        if(timeConversion.containskey(currRec.end_Time__c))
        {
            endTime = timeConversion.get(currRec.end_Time__c);
        }
        
        if((startTime >= endTime) && (StartTime != 19.00))
        {
            currRec.addError('End Time should be greater than start time');
        }
        
        if(startTime == 19.00)
           currRec.addError('Please enter valid Start and End Time');
  }

}