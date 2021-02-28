public abstract class EmployeePunchesModel {

    //Variables
    private static String employeeShiftId;
    private static Date employeeShiftDate;
    private static Time employeeShiftTime;
    private static String employeePunchType;
    private static Date startingDateOfWeek;
    private static Date endingDateOfWeek;
    
    //Mutators
    public static void setEmployeeShiftId(String thisEmployeeShiftId) {
        
        employeeShiftId = thisEmployeeShiftId;
    }
    
    public static void setEmployeeShiftDate(Date thisEmployeeShiftDate) {
        
        employeeShiftDate = thisEmployeeShiftDate;
    }
    
    public static void setEmployeeShiftTime(Time thisEmployeeShiftTime) {
        
        employeeShiftTime = thisEmployeeShiftTime;
    }
    
    public static void setEmployeePunchType(String thisEmployeePunchType) {
        
        employeePunchType = thisEmployeePunchType;
    }
    
    public static void setStartingDateOfWeek(Date thisStartingDateOfWeek) {
        
        startingDateOfWeek = thisStartingDateOfWeek;
    }
    
    public static void setEndingDateOfWeek(Date thisEndingDateOfWeek) {
        
        endingDateOfWeek = thisEndingDateOfWeek;
    }
    
    //Accessors
    private static String getEmployeeShiftId() {
        
        return employeeShiftId;
    }
    
    private static Date getEmployeeShiftDate() {
        
        return employeeShiftDate;
    }
    
    private static Time getEmployeeShiftTime() {
        
        return employeeShiftTime;
    }
    
    private static String getEmployeePunchType() {
        
        return employeePunchType;
    }
    
    private static Date getStartingDateOfWeek() {
        
        return startingDateOfWeek;
    }
    
    private static Date getEndingDateOfWeek() {
        
        return endingDateOfWeek;
    }
    
    private static String calculateAMOrPMHour(Integer hour) {
        
        String output = '';
        
        if (hour == 0) {
            
            output += '12';
        } else {
            
            if (hour <= 12) {
                
                output += String.valueOf(hour);
            } else {
                
                output += String.valueOf(hour - 12);
            }
        }
        
        return output;
    }
    
    private static String calculateAMOrPM(Integer hour) {
        
        String output = '';
        
        if (hour < 12) {
            
            output += 'AM';
        } else {
            
            output += 'PM';
        }
        
        return output;
    }
    
    //When the time is less than ten minutes into the hour
    //the method needs to make sure that a zero comes after the colon.
    //For example, the correct time format would be 12:09, not 12:9.
    private static String calculateMinute(Integer minute) {
        
        String output = '';
        
        if (minute >= 0 && minute <= 9) {
            
            output = '0' + minute;
        } else {
            
            output = '' + minute;
        }
        
        return output;
    }
    
    public static String createEmployeePunch() {
        
        String output = '';
        
        try {
            
            List<EmployeePunch__c> employeePunchesToInsert = new List<EmployeePunch__c>();
            
            EmployeePunch__c prepareEmployeePunch = new EmployeePunch__c(EmployeeWeeklySchedule__c = getEmployeeShiftId(),
                                                                   Date__c = getEmployeeShiftDate(),
                                                                   Time__c = getEmployeeShiftTime(),
                                                                   PunchType__c = getEmployeePunchType());
            
            EmployeePunch__c newEmployeePunch = new EmployeePunch__c(EmployeeWeeklySchedule__c = prepareEmployeePunch.EmployeeWeeklySchedule__c,
                                                               Date__c = prepareEmployeePunch.Date__c,
                                                               Time__c = prepareEmployeePunch.Time__c,
                                                               PunchType__c = prepareEmployeePunch.PunchType__c);
            
            employeePunchesToInsert.add(newEmployeePunch);
            
            insert employeePunchesToInsert;
            
            output = 'success';
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            output = 'fail';
        }
        
        return output;
    }
    
    public static List<List<String>> searchEmployeeShifts() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> shiftId = new List<String>();
        List<String> weekday = new List<String>();
        List<String> scheduleDate = new List<String>();
        List<String> startTime = new List<String>();
        List<String> endTime = new List<String>();
        
        Integer shiftCount = 0;
        
        try {
            
            if (Schema.SObjectType.EmployeeWeeklySchedule__c.isAccessible()) {
                
                for (EmployeeWeeklySchedule__c eachEmployeeWeeklySchedule: [SELECT Id,
                	 Weekday__c, Date__c, Start__c, End__c
                     FROM EmployeeWeeklySchedule__c WHERE Date__c = :Date.today()
                     ORDER BY CreatedDate ASC]) {
                     
                     shiftId.add(String.valueOf(eachEmployeeWeeklySchedule.Id));
                     weekday.add(eachEmployeeWeeklySchedule.Weekday__c);
                     scheduleDate.add(String.valueOf(eachEmployeeWeeklySchedule.Date__c));
                     startTime.add(calculateAMOrPMHour(eachEmployeeWeeklySchedule.Start__c.hour()) +
                                  ':' + calculateMinute(eachEmployeeWeeklySchedule.Start__c.minute()) +
                                  ' ' + calculateAMOrPM(eachEmployeeWeeklySchedule.Start__c.hour()));
                     endTime.add(calculateAMOrPMHour(eachEmployeeWeeklySchedule.End__c.hour()) +
                                ':' + calculateMinute(eachEmployeeWeeklySchedule.End__c.minute()) +
                                ' ' + calculateAMOrPM(eachEmployeeWeeklySchedule.End__c.hour()));
                     
                     shiftCount++;
                }
            }
            
            if (shiftCount == 0) {

                shiftId.add('0');
                weekday.add('no shift');
                scheduleDate.add('no shift');
                startTime.add('no shift');
                endTime.add('no shift');
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            shiftId.add('0');
            weekday.add('fail');
            scheduleDate.add('fail');
            startTime.add('fail');
            endTime.add('fail');
        }
        
        output.add(shiftId);
        output.add(weekday);
        output.add(scheduleDate);
        output.add(startTime);
        output.add(endTime);
        
        return output;
    }
    
    public static List<List<String>> searchEmployeeAllPunches() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> punchName = new List<String>();
        List<String> punchDate = new List<String>();
        List<String> punchTime = new List<String>();
        List<String> punchType = new List<String>();
        List<String> employeeWeeklySchedule = new List<String>();
        List<String> createdDate = new List<String>();
        
        Integer punchCount = 0;
        
        try {
            
            if (Schema.SObjectType.EmployeePunch__c.isAccessible()) {
                
                for (EmployeePunch__c eachEmployeePunch: [SELECT Name, Date__c, Time__c, PunchType__c,
                                                          EmployeeWeeklySchedule__c, CreatedDate FROM EmployeePunch__c
                                                          ORDER BY CreatedDate ASC]) {
                         
                     punchName.add(eachEmployeePunch.Name);
                     punchDate.add(String.valueOf(eachEmployeePunch.Date__c));
                     punchTime.add(calculateAMOrPMHour(eachEmployeePunch.Time__c.hour()) +
                                ':' + calculateMinute(eachEmployeePunch.Time__c.minute()) +
                                ' ' + calculateAMOrPM(eachEmployeePunch.Time__c.hour()));
                     punchType.add(eachEmployeePunch.PunchType__c);
                     employeeWeeklySchedule.add(eachEmployeePunch.EmployeeWeeklySchedule__c);
                     createdDate.add(String.valueOf(eachEmployeePunch.CreatedDate));
                     
                     punchCount++;
                }
                
                if (punchCount == 0) {
                    
                    punchName.add('no punch');
                    punchDate.add('no punch');
                    punchTime.add('no punch');
                    punchType.add('no punch');
                    employeeWeeklySchedule.add('no punch');
                    createdDate.add('no punch');
                }
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            punchName.add('fail');
            punchDate.add('fail');
            punchTime.add('fail');
            punchType.add('fail');
            employeeWeeklySchedule.add('fail');
            createdDate.add('fail');
        }
        
        output.add(punchName);
        output.add(punchDate);
        output.add(punchTime);
        output.add(punchType);
        output.add(employeeWeeklySchedule);
        output.add(createdDate);
        
        return output;
    }
    
    //This method searches the last employee punch, regardless of a particular shift.
    public static List<List<String>> searchEmployeeLastPunch() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> punchName = new List<String>();
        List<String> punchDate = new List<String>();
        List<String> punchType = new List<String>();
        
        Integer punchCount = 0;
        
        try {
            
            if (Schema.SObjectType.EmployeePunch__c.isAccessible()) {
                
                for (EmployeePunch__c eachEmployeePunch: [SELECT Name, Date__c, PunchType__c FROM EmployeePunch__c
                     ORDER BY CreatedDate DESC LIMIT 1]) {
                         
                     punchName.add(eachEmployeePunch.Name);
                     punchDate.add(String.valueOf(eachEmployeePunch.Date__c));
                     punchType.add(eachEmployeePunch.PunchType__c);
                     
                     punchCount++;
                }
                
                if (punchCount == 0) {
                    
                    punchName.add('no punch');
                    punchDate.add('no punch');
                    punchType.add('no punch');
                }
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            punchName.add('fail');
            punchDate.add('fail');
            punchType.add('fail');
        }
        
        output.add(punchName);
        output.add(punchDate);
        output.add(punchType);
        
        return output;
    }

    //This method searches the last employee punch, concerning a particular shift.
    public static List<List<String>> searchEmployeeLastPunchParticularShift() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> punchName = new List<String>();
        List<String> punchDate = new List<String>();
        List<String> punchType = new List<String>();
        List<String> punchWeeklySchedule = new List<String>();
        
        Integer punchCount = 0;
        
        try {
            
            if (Schema.SObjectType.EmployeePunch__c.isAccessible()) {
                
                for (EmployeePunch__c eachEmployeePunch: [SELECT Name, Date__c, PunchType__c, EmployeeWeeklySchedule__c
                     FROM EmployeePunch__c WHERE Date__c = :Date.today() ORDER BY CreatedDate DESC LIMIT 1]) {
                     
                     punchName.add(eachEmployeePunch.Name);
                     punchDate.add(String.valueOf(eachEmployeePunch.Date__c));
                     punchType.add(eachEmployeePunch.PunchType__c);
                     punchWeeklySchedule.add(eachEmployeePunch.EmployeeWeeklySchedule__c);
                     
                     punchCount++;
                }
                
                if (punchCount == 0) {
                    
                    punchName.add('no punch');
                    punchDate.add('no punch');
                    punchType.add('no punch');
                    punchWeeklySchedule.add('no punch');
                }
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            punchName.add('fail');
            punchDate.add('fail');
            punchType.add('fail');
            punchWeeklySchedule.add('fail');
        }
        
        output.add(punchName);
        output.add(punchDate);
        output.add(punchType);
        output.add(punchWeeklySchedule);
        
        return output;
    }
    
    public static List<List<String>> searchEmployeeWeeklyShifts() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> shiftId = new List<String>();
        List<String> shiftDate = new List<String>();
        
        Integer shiftCount = 0;
        
        try {
           
            if (Schema.SObjectType.EmployeeWeeklySchedule__c.isAccessible()) {
                
                for (EmployeeWeeklySchedule__c eachEmployeeWeeklySchedule: [SELECT Id, Date__c
                     FROM EmployeeWeeklySchedule__c WHERE Date__c >= :getStartingDateOfWeek()
                     AND Date__c <= :getEndingDateOfWeek() ORDER BY Date__c ASC]) {
                    
                     shiftId.add(eachEmployeeWeeklySchedule.Id);
                     shiftDate.add(String.valueOf(eachEmployeeWeeklySchedule.Date__c));
                     
                     shiftCount++;
                }
                
                if (shiftCount == 0) {
                    
                    shiftId.add('no shift');
                    shiftDate.add('no shift');
                }
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            shiftId.add('fail');
            shiftDate.add('fail');
        }
        
        output.add(shiftId);
        output.add(shiftDate);
        
        return output;
    }    
}
