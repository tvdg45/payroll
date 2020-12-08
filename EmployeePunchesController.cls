public with sharing class EmployeePunchesController extends EmployeePunchesModel {

    //Variables
    public static List<List<String>> searchEmployeeShifts;
    public static List<List<String>> searchEmployeeAllPunches;
    public static List<List<String>> searchEmployeeShiftDates;
    public static Map<String, String> searchShiftDate = new Map<String, String>();
    public static List<List<String>> searchEmployeeLastPunch;
    public static List<List<String>> searchEmployeeLastPunchParticularShift;
    public static String employeeShiftId;
    public static Date employeeShiftDate;
    public static Time employeeShiftTime;
    public static String employeePunchType;
    
    public static String formFeedback;
    
    public static void controlCreateEmployeePunch() {
        
        employeeShiftId = Apexpages.currentPage().getParameters().get('employeeShiftId');
        employeeShiftDate = Date.today();
        employeeShiftTime = Time.newInstance(DateTime.now().hour(), DateTime.now().minute(),
        DateTime.now().second(), DateTime.now().millisecond());
        employeePunchType = Apexpages.currentPage().getParameters().get('employeePunchType');
        
        setEmployeeShiftId(employeeShiftId);
        setEmployeeShiftDate(employeeShiftDate);
        setEmployeeShiftTime(employeeShiftTime);
        setEmployeePunchType(employeePunchType);
        
        if (createEmployeePunch().Equals('success')) {
            
            formFeedback = EmployeePunchesView.refreshPage();
        } else {
            
            formFeedback = '';
        }
    }
    
    public static String getFormFeedback() {
        
        return formFeedback;
    }
    
    //Make sure an employee does not punch in when he/she is not scheduled to work
    //for that date.
    public static void searchAllShiftDates() {
        
        try {
            
            searchEmployeeShiftDates = searchEmployeeShifts();
            
            if (!(String.valueOf(searchEmployeeShiftDates.get(1).get(0)).equals('no shift')
               || String.valueOf(searchEmployeeShiftDates.get(1).get(0)).equals('fail'))) {
                
               for (Integer i = 0; i < searchEmployeeShiftDates.get(0).size(); i++) {
                   
                   searchShiftDate.put(String.valueOf(searchEmployeeShiftDates.get(0).get(i)),
                                       String.valueOf(searchEmployeeShiftDates.get(2).get(i)));
               }
            }
        } catch (Exception e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    
    public static String getEmployeeShifts() {
        
        String output = '';
        
        try {
            
            searchEmployeeShifts = searchEmployeeShifts();
            searchEmployeeAllPunches = searchEmployeeAllPunches();
            
            EmployeePunchesView.shifts = searchEmployeeShifts;
            EmployeePunchesView.punches = searchEmployeeAllPunches;
            
            output = '{\"shift\": ' + EmployeePunchesView.showShifts() + ', ' +
                '\"punch\": ' + EmployeePunchesView.showPunches() + '}';
        } catch (Exception e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            output = '{shift: [{"row_id": "", "weekday": "", "schedule_date": "", "start_time": "", "end_time": ""}], ' +
                'punch: [{"punch_name": "", "punch_date": "", "punch_time": "", "punch_type": "", "employee_weekly_schedule": ""}]}';
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
    
    //Find employee's last punch type, so he/she does not start a new shift before finishing the previous one.
    public static void searchEmployeeLastPunchType() {
        
        searchEmployeeLastPunch = searchEmployeeLastPunch();
    }
    
    //Prevent the employee from trying to end a shift that has not been started or has already been ended.
    public static void searchEmployeeLastPunchTypeParticularShift() {
        
        searchEmployeeLastPunchParticularShift = searchEmployeeLastPunchParticularShift();
    }
    
    public static void triggerValidateEmployeePunch(List<EmployeePunch__c> useEmployeePunches) {
        
        String calculateMinute = '';
        
        try {
            
            searchAllShiftDates();
            searchEmployeeLastPunchType();
            searchEmployeeLastPunchTypeParticularShift();
            
            for (EmployeePunch__c eachEmployeePunch: useEmployeePunches) {
                
                calculateMinute = calculateMinute(eachEmployeePunch.Time__c.minute());
                
                //Check if employee is scheduled to work shift.
                if ((searchEmployeeShiftDates.get(1).get(0) == 'no shift' || searchEmployeeShiftDates.get(1).get(0) == 'fail'
                    || searchEmployeeLastPunch.get(0).get(0) == 'fail'
                    || searchEmployeeLastPunchParticularShift.get(0).get(0) == 'fail')
                    && eachEmployeePunch.PunchType__c == 'Clock in') {
                    
                    eachEmployeePunch.addError('You are not scheduled for any shifts today.');
                } else {
                    
                    //If an employee is scheduled for a shift, make sure that employee only chooses a shift for today's date.
                    if (searchShiftDate.get(eachEmployeePunch.EmployeeWeeklySchedule__c) != String.valueOf(Date.today())
                       && eachEmployeePunch.PunchType__c == 'Clock in') {
                        
                        eachEmployeePunch.addError('You are not scheduled for that shift today.');
                    }
                }
                
                if (eachEmployeePunch.Date__c == null || eachEmployeePunch.Date__c != Date.today()) {
                    
                    eachEmployeePunch.addError('Today\'s date is required.');
                }
                
                if (eachEmployeePunch.Time__c == null || (eachEmployeePunch.Time__c.hour() + ':' + calculateMinute) != System.now().format('H:mm')) {
                    
                    eachEmployeePunch.addError('Today\'s current time is required.');
                }
                
                if (eachEmployeePunch.PunchType__c == 'Clock in' && searchEmployeeLastPunch.get(2).get(0) == 'Clock in') {
                    
                    eachEmployeePunch.addError('Your are still on your shift for ' + searchEmployeeLastPunch.get(1).get(0) + '. You' +
                                               ' need to clock out of that shift first.');
                }
                
                //No employee can punch out of a shift when he/she has not clocked in at least once, for a given shift date.
                //However, he should clock out of any previous shifts before starting any new shifts.
                if (eachEmployeePunch.PunchType__c == 'Clock out'
                    && (searchEmployeeLastPunchParticularShift.get(3).get(0) == 'no punch'
                       || searchEmployeeLastPunchParticularShift.get(3).get(0) == 'fail')
                    && searchEmployeeLastPunch.get(2).get(0) != 'Clock in'
                   	) {
                            
                        eachEmployeePunch.addError('You are currently not punched into any shifts for ' +
                                                   String.valueOf(Date.today()) + '.' + ' Choose a shift to get started.');
                }
                
                //An employee has punched in at least once.
                if (eachEmployeePunch.PunchType__c == 'Clock out'
                    && searchEmployeeLastPunchParticularShift.get(3).get(0) != 'no punch'
                    && searchEmployeeLastPunchParticularShift.get(3).get(0) != 'fail'
                   	) {
                    
                    //He/she must clock out of the same shift that he/she punched into.
                    if (searchEmployeeLastPunchParticularShift.get(3).get(0) != eachEmployeePunch.EmployeeWeeklySchedule__c) {
                        
                        eachEmployeePunch.addError('You are attempting to clock out on a different shift.');
                    }
                    
                    //He/she cannot clock out of the same shift that he/she is already clocked out of.
                    if (searchEmployeeLastPunchParticularShift.get(3).get(0) == eachEmployeePunch.EmployeeWeeklySchedule__c
                       && searchEmployeeLastPunch.get(2).get(0) == 'Clock out') {
                        
                        eachEmployeePunch.addError('You have already clocked out of this shift.  Choose a different shift,' +
                                                  ' or clock back into this shift.');
                    }
                }
            }
        } catch (DMLException e) {
            
            System.debug('Sorry, but your punch was not added due to the following reasons: ' + e.getMessage());
        }
    }
}
