public abstract class EmployeePaycheckModel {

    //Variables
    private static String userId;
    private static List<String> employeeWeeklySchedule;
    private static String employeeWageId;
    private static List<String> employeeShiftId;
    private static Decimal taxesWithheld;
    private static String employeePaycheckId;
    private static List<Decimal> employeeNumberOfHoursPerShift;
    private static Decimal employeeWageAmount;
    
    
    //Mutators
    public static void setUserId(String thisUserId) {
        
        userId = thisUserId;
    }
    
    public static void setEmployeeWeeklySchedule(List<String> thisEmployeeWeeklySchedule) {
        
        employeeWeeklySchedule = thisEmployeeWeeklySchedule;
    }
    
    public static void setEmployeeWageId(String thisEmployeeWageId) {
        
        employeeWageId = thisEmployeeWageId;
    }
    
    public static void setEmployeeShiftId(List<String> thisEmployeeShiftId) {
        
        employeeShiftId = thisEmployeeShiftId;
    }
    
    public static void setTaxesWithheld(Decimal thisTaxesWithheld) {
        
        taxesWithheld = thisTaxesWithheld;
    }
    
    public static void setEmployeePaycheckId(String thisEmployeePaycheckId) {
        
        employeePaycheckId = thisEmployeePaycheckId;
    }
    
    public static void setEmployeeNumberOfHoursPerShift(List<Decimal> thisEmployeeNumberOfHoursPerShift) {
        
        employeeNumberOfHoursPerShift = thisEmployeeNumberOfHoursPerShift;
    }
    
    public static void setEmployeeWageAmount(Decimal thisEmployeeWageAmount) {
        
        employeeWageAmount = thisEmployeeWageAmount;
    }
    
    //Accessors
    private static String getUserId() {
        
        return userId;
    }
    
    private static List<String> getEmployeeWeeklySchedule() {
        
        return employeeWeeklySchedule;
    }
    
    private static String getEmployeeWageId() {
        
        return employeeWageId;
    }
    
    private static List<String> getEmployeeShiftId() {
        
        return employeeShiftId;
    }
    
    private static Decimal getTaxesWithheld() {
        
        return taxesWithheld;
    }
    
    private static String getEmployeePaycheckId() {
        
        return employeePaycheckId;
    }
    
    private static List<Decimal> getEmployeeNumberOfHoursPerShift() {
        
        return employeeNumberOfHoursPerShift;
    }
    
    private static Decimal getEmployeeWageAmount() {
        
        return employeeWageAmount;
    }
    
    public static List<List<String>> searchEmployeeWages() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> hourlyWage = new List<String>();
        List<String> user = new List<String>();
        List<String> withholdTaxes = new List<String>();
        
        Integer employeeWageCount = 0;
        
        try {
            
            if (Schema.SObjectType.EmployeeWage__c.isAccessible()) {
                
                for (EmployeeWage__c eachEmployeeWage: [SELECT HourlyWage__c, User__c, WithholdTaxes__c
                                                          FROM EmployeeWage__c WHERE Id = :getEmployeeWageId()
                                                          ORDER BY CreatedDate ASC]) {
                         
                     hourlyWage.add(String.valueOf(eachEmployeeWage.HourlyWage__c));
                     user.add(eachEmployeeWage.User__c);
                     withholdTaxes.add(eachEmployeeWage.WithholdTaxes__c);
                     
                     employeeWageCount++;
                }
                
                if (employeeWageCount == 0) {
                    
                    hourlyWage.add('no employee wage');
                    user.add('no employee wage');
                    withholdTaxes.add('no employee wage');
                }                
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            hourlyWage.add('fail');
            user.add('fail');
            withholdTaxes.add('fail');
        }
        
        output.add(hourlyWage);
        output.add(user);
        output.add(withholdTaxes);
        
        return output;
    }
    
    public static List<String> searchEmployeeWeeklySchedules() {
        
        List<String> output = new List<String>();
        
        Integer employeeWeeklyScheduleCount = 0;
        
        try {
            
            if (Schema.SObjectType.EmployeeSchedule__c.isAccessible()) {
                
                for (EmployeeSchedule__c eachEmployeeSchedule: [SELECT Id FROM EmployeeSchedule__c
                                                          WHERE OwnerId = :getUserId() ORDER BY CreatedDate ASC]) {
                         
                     output.add(eachEmployeeSchedule.Id);
                     
                     employeeWeeklyScheduleCount++;
                }
                
                if (employeeWeeklyScheduleCount == 0) {
                    
                    output.add('no schedule');
                }
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            output.add('fail');
        }        
        
        return output;
    }
    
    public static List<List<String>> searchEmployeeShifts() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> shiftId = new List<String>();
        List<String> shiftDate = new List<String>();
        
        Integer shiftCount = 0;
        
        try {
           
            if (Schema.SObjectType.EmployeeWeeklySchedule__c.isAccessible()) {
                
                for (EmployeeWeeklySchedule__c eachEmployeeWeeklySchedule: [SELECT Id, Date__c
                     FROM EmployeeWeeklySchedule__c WHERE EmployeeSchedule__c IN :getEmployeeShiftId()
                     ORDER BY Date__c ASC]) {
                    
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
    
    public static List<List<String>> searchEmployeeAllPunches() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> punchName = new List<String>();
        List<String> punchDate = new List<String>();
        List<String> punchType = new List<String>();
        List<String> weeklySchedule = new List<String>();
        List<String> createdDate = new List<String>();
        
        Integer punchCount = 0;
        
        try {
            
            if (Schema.SObjectType.EmployeePunch__c.isAccessible()) {
                
                for (EmployeePunch__c eachEmployeePunch: [SELECT Name, Date__c, PunchType__c,
                                                          EmployeeWeeklySchedule__c, CreatedDate FROM EmployeePunch__c
                                                          ORDER BY CreatedDate ASC]) {
                         
                     punchName.add(eachEmployeePunch.Name);
                     punchDate.add(String.valueOf(eachEmployeePunch.Date__c));
                     punchType.add(eachEmployeePunch.PunchType__c);
                     weeklySchedule.add(eachEmployeePunch.EmployeeWeeklySchedule__c);
                     createdDate.add(String.valueOf(eachEmployeePunch.CreatedDate));
                     
                     punchCount++;
                }
                
                if (punchCount == 0) {
                    
                    punchName.add('no punch');
                    punchDate.add('no punch');
                    punchType.add('no punch');
                    weeklySchedule.add('no punch');
                    createdDate.add('no punch');
                }
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            punchName.add('fail');
            punchDate.add('fail');
            punchType.add('fail');
            weeklySchedule.add('fail');
            createdDate.add('fail');
        }
        
        output.add(punchName);
        output.add(punchDate);
        output.add(punchType);
        output.add(weeklySchedule);
        output.add(createdDate);
        
        return output;
    }
    
    public static List<List<String>> searchEmployeeAllPaychecks() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> paycheckId = new List<String>();
        List<String> paycheckName = new List<String>();
        
        Integer employeePaycheckCount = 0;
        
        try {
            
            if (Schema.SObjectType.Paycheck__c.isAccessible()) {
                
                for (Paycheck__c eachEmployeePaycheck: [SELECT Id, Name FROM Paycheck__c
                                                          WHERE EmployeeWage__c = :getEmployeeWageId() ORDER BY CreatedDate ASC]) {
                         
                     paycheckId.add(eachEmployeePaycheck.Id);
                     paycheckName.add(eachEmployeePaycheck.Name);
                     
                     employeePaycheckCount++;
                }
                
                if (employeePaycheckCount == 0) {
                    
                    paycheckId.add('no check');
                    paycheckName.add('no check');
                }
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            paycheckId.add('fail');
            paycheckName.add('fail');
        }
        
        output.add(paycheckId);
        output.add(paycheckName);
        
        return output;
    }
    
    public static String createPaycheck() {
        
        String output = '';
        Integer recordCount = 0;
        Decimal grossAmount = 0.0;
        
        List<PayableHour__c> shiftsToBeInserted = new List<PayableHour__c>();
        
        for (Integer i = 0; i < getEmployeeNumberOfHoursPerShift().size(); i++) {
            
            grossAmount = getEmployeeNumberOfHoursPerShift().get(i) * getEmployeeWageAmount();
            
            PayableHour__c preparePayableHour = new PayableHour__c(Hours__c = getEmployeeNumberOfHoursPerShift().get(i),
                                                                  GrossAmount__c = grossAmount,
                                                                  Paycheck__c = getEmployeePaycheckId());
            
            PayableHour__c newPayableHour = new PayableHour__c(Hours__c = preparePayableHour.Hours__c,
                                                              GrossAmount__c = preparePayableHour.GrossAmount__c,
                                                              Paycheck__c = preparePayableHour.Paycheck__c);
            
            shiftsToBeInserted.add(newPayableHour);
            
            grossAmount = 0.0;
            
            recordCount++;
        }
        
        if (recordCount > 0) {
        
          insert shiftsToBeInserted;
            
          output = 'shifts inserted';
        }       
        
        return output;
    }
    
    public static String changeNetValueOnPaycheck() {
        
        String output = '';
        List<Paycheck__c> paychecksToBeUpdated = new List<Paycheck__c>();
        
        Integer employeePaycheckCount = 0;
        
        try {
            
            if (Schema.SObjectType.EmployeeWage__c.isAccessible()) {
                
                for (Paycheck__c eachEmployeePaycheck: [SELECT TotalGross__c, TaxesWithheld__c, TotalNet__c
                                                          FROM Paycheck__c WHERE Id = :getEmployeePaycheckId()
                                                          ORDER BY CreatedDate ASC]) {
                     
                     eachEmployeePaycheck.TaxesWithheld__c = getTaxesWithheld();
                     eachEmployeePaycheck.TotalNet__c = eachEmployeePaycheck.TotalGross__c - getTaxesWithheld();
                                                              
                     paychecksToBeUpdated.add(eachEmployeePaycheck);
                     
                     employeePaycheckCount++;
                }
                
                if (employeePaycheckCount > 0) {
                    
                    update paychecksToBeUpdated;
                    
                    output = 'paycheck updated';
                }                
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            output = 'fail';
        }
        
        return output;
    }
}
