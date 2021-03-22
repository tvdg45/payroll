public with sharing class EmployeePaycheckController extends EmployeePaycheckModel {
    
    //Variables
    public static List<DateTime> searchEmployeePunchesPerShift = new List<DateTime>();
    
    public static String formFeedback;
    
    public static Decimal calculateTotalHoursPerDate() {
        
        Decimal output = 0.0;
        Decimal hours = 0.0;
        Integer minutes = 0;
        
        for (Integer i = 0; i < searchEmployeePunchesPerShift.size(); i += 2) {
            
            minutes = Integer.valueOf((searchEmployeePunchesPerShift.get(i + 1).getTime() - searchEmployeePunchesPerShift.get(i).getTime()) / 1000 / 60);
            hours = Decimal.valueOf(minutes).divide(60, 2);
            
            output += hours;
            
            minutes = 0;
            hours = 0.0;
        }
        
        return output;
    }
    
    //Print a list of shifts that a particular employee has worked.
    //Allow the manager to create the paycheck by selecting the check number
    //and associating worked shifts with it.
    public static String getEmployeeShiftHistory() {
        
        String output = '';
        Decimal totalHoursPerDate = 0;
        String employeeWageId = '';
        List<List<String>> searchEmployeeWages = new List<List<String>>();
        String userId = '';
        List<String> searchEmployeeWeeklySchedules = new List<String>();
        List<List<String>> searchEmployeeAllShifts = new List<List<String>>();
        List<List<String>> searchEmployeeAllPunches = new List<List<String>>();
        List<List<String>> searchEmployeeAllPaychecks = new List<List<String>>();
        Integer workedShifts = 0;
        
        employeeWageId = ApexPages.currentPage().getparameters().get('id');
        
        setEmployeeWageId(employeeWageId);
        
        searchEmployeeWages = searchEmployeeWages();
        
        if (searchEmployeeWages.get(0).get(0) != 'no employee wage' && searchEmployeeWages.get(0).get(0) != 'fail') {
            
            setUserId(searchEmployeeWages.get(1).get(0));
            
            searchEmployeeWeeklySchedules = searchEmployeeWeeklySchedules();
            
            if (searchEmployeeWeeklySchedules.get(0) != 'no schedule' && searchEmployeeWeeklySchedules.get(0) != 'fail') {
                
                setEmployeeShiftId(searchEmployeeWeeklySchedules);
                
                searchEmployeeAllShifts = searchEmployeeShifts();
                
                if (searchEmployeeAllShifts.get(0).get(0) != 'no shift' && searchEmployeeAllShifts.get(0).get(0) != 'fail') {
                    
                    searchEmployeeAllPunches = searchEmployeeAllPunches();
                    
                    if (searchEmployeeAllPunches.get(0).get(0) != 'fail') {
                        
                        if (searchEmployeeAllPunches.get(0).get(0) != 'no punch'
                            && searchEmployeeAllPaychecks().get(0).get(0) != 'no check'
                            && searchEmployeeAllPaychecks().get(0).get(0) != 'fail') {
                            
                            searchEmployeeAllPaychecks = searchEmployeeAllPaychecks();
                            
                            output += '{"employee_paychecks": ';
                            output += '[';
                            
                            for (Integer i = 0; i < searchEmployeeAllPaychecks.get(0).size(); i++) {
                                
                               	output += '{"paycheck_id": "' + searchEmployeeAllPaychecks.get(0).get(i) + '", ' +
                                    '"paycheck_number": "' + searchEmployeeAllPaychecks.get(1).get(i) + '"}, ';
                            }
                                
                            output += '{}], ';
                            output += '"employee_weekly_shifts": ';
                            output += '[';
                            
                            for (Integer i = 0; i < searchEmployeeAllShifts.get(0).size(); i++) {
                                
                                if(math.mod(searchEmployeeAllPunches.get(0).size(), 2) == 0) {
                                    
                                    for (Integer j = 0; j < searchEmployeeAllPunches.get(0).size(); j++) {
                                        
                                        if (searchEmployeeAllShifts.get(0).get(i) == searchEmployeeAllPunches.get(3).get(j)) {
                                            
                                            searchEmployeePunchesPerShift.add(DateTime.valueOf(searchEmployeeAllPunches.get(4).get(j)));
                                        }
                                    }
                                } else {
                                    
                                    for (Integer j = 0; j < searchEmployeeAllPunches.get(0).size() - 1; j++) {
                                        
                                        if (searchEmployeeAllShifts.get(0).get(i) == searchEmployeeAllPunches.get(3).get(j)) {
                                            
                                            searchEmployeePunchesPerShift.add(DateTime.valueOf(searchEmployeeAllPunches.get(4).get(j)));
                                        }
                                    }
                                }
                                
                                totalHoursPerDate = calculateTotalHoursPerDate();
                                
                                if (totalHoursPerDate > 0) {
                                    
                                    output += '{"shift_id": "' + searchEmployeeAllShifts.get(0).get(i) + '", ' +
                                        '"date": "' + searchEmployeeAllShifts.get(1).get(i) + '", ' +
                                        '"number_of_hours": ' + totalHoursPerDate + '}, ';
                                    
                                    workedShifts++;
                                }
                                
                                searchEmployeePunchesPerShift.clear();
                                totalHoursPerDate = 0;
                            }
                            
                            output += '{}]';
                            
                            output = output.replaceAll(', \\{\\}', '');
                            
                            output += '}';
                                
                            if (workedShifts == 0) {
                                
                                output = 'no shift';
                            }
                        } else {
                            
                            output = 'no shift';
                        }
                    } else {
                        
                        output = 'no shift';
                    }
                } else {
                    
                    output = 'no shift';
                }
            } else {
                
                output = 'no shift';
            }
        } else {
            
            output = 'no shift';
        }
        
        return output;
    }
    
    public static void controlCreatePaycheck() {
        
        String output = '';
        Decimal totalHoursPerDate = 0;
        String employeeWageId = '';
        Decimal decTaxesWithheld = 0.0;
        String paycheckId = '';
        String shiftId = '';
        String taxesWithheld = '';
        List<List<String>> searchEmployeeWages = new List<List<String>>();
        List<String> searchEmployeeWeeklySchedules = new List<String>();
        List<List<String>> searchEmployeeAllShifts = new List<List<String>>();
        List<List<String>> searchEmployeeAllPunches = new List<List<String>>();
        Map<String, Decimal> numberOfHoursPerShift = new Map<String, Decimal>();
        
        employeeWageId = ApexPages.currentPage().getparameters().get('id');
        paycheckId = Apexpages.currentPage().getParameters().get('paycheckId');
        shiftId = Apexpages.currentPage().getParameters().get('shiftId');
        taxesWithheld = Apexpages.currentPage().getParameters().get('taxesWithheld');
        
        setEmployeeWageId(employeeWageId);
        
        searchEmployeeWages = searchEmployeeWages();
        
        if (searchEmployeeWages.get(0).get(0) != 'no employee wage' && searchEmployeeWages.get(0).get(0) != 'fail') {
            
            setUserId(searchEmployeeWages.get(1).get(0));
            
            searchEmployeeWeeklySchedules = searchEmployeeWeeklySchedules();
            
            if (searchEmployeeWeeklySchedules.get(0) != 'no schedule' && searchEmployeeWeeklySchedules.get(0) != 'fail') {
                
                setEmployeeShiftId(searchEmployeeWeeklySchedules);
                
                searchEmployeeAllShifts = searchEmployeeShifts();
                
                if (searchEmployeeAllShifts.get(0).get(0) != 'no shift' && searchEmployeeAllShifts.get(0).get(0) != 'fail') {
                    
                    searchEmployeeAllPunches = searchEmployeeAllPunches();
                    
                    if (searchEmployeeAllPunches.get(0).get(0) != 'fail') {
                        
                        if (searchEmployeeAllPunches.get(0).get(0) != 'no punch') {
                                
                            for (Integer i = 0; i < searchEmployeeAllShifts.get(0).size(); i++) {
                                
                                if(math.mod(searchEmployeeAllPunches.get(0).size(), 2) == 0) {
                                    
                                    for (Integer j = 0; j < searchEmployeeAllPunches.get(0).size(); j++) {
                                        
                                        if (searchEmployeeAllShifts.get(0).get(i) == searchEmployeeAllPunches.get(3).get(j)) {
                                            
                                            searchEmployeePunchesPerShift.add(DateTime.valueOf(searchEmployeeAllPunches.get(4).get(j)));
                                        }
                                    }
                                } else {
                                    
                                    for (Integer j = 0; j < searchEmployeeAllPunches.get(0).size() - 1; j++) {
                                        
                                        if (searchEmployeeAllShifts.get(0).get(i) == searchEmployeeAllPunches.get(3).get(j)) {
                                            
                                            searchEmployeePunchesPerShift.add(DateTime.valueOf(searchEmployeeAllPunches.get(4).get(j)));
                                        }
                                    }
                                }
                                
                                totalHoursPerDate = calculateTotalHoursPerDate();
                                
                                numberOfHoursPerShift.put(searchEmployeeAllShifts.get(0).get(i), totalHoursPerDate);
                                
                                searchEmployeePunchesPerShift.clear();
                                totalHoursPerDate = 0;
                            }
                            
                            output = 'shifts found';
                        } else {
                            
                            output = 'no shift';
                        }
                    } else {
                        
                        output = 'no shift';
                    }
                } else {
                    
                    output = 'no shift';
                }
            } else {
                
                output = 'no shift';
            }
        } else {
            
            output = 'no shift';
        }
        
        if (output == 'shifts found') {
            
            try {
                
                decTaxesWithheld = Decimal.valueOf(taxesWithheld);
               
                if (shiftId == '') {
                    
                    output = 'no shift selected';
                } else if (decTaxesWithheld < 0) {
                    
                    output = 'taxes withheld negative number';
                } else if (decTaxesWithheld > 0 && searchEmployeeWages.get(2).get(0) == 'No') {
                    
                    output = 'cannot withhold taxes';
                } else {
                    
                    output = addShiftsToPaycheck(paycheckId, shiftId, Decimal.valueOf(searchEmployeeWages.get(0).get(0)), numberOfHoursPerShift);
                    
                    setEmployeePaycheckId(paycheckId);
                    setTaxesWithheld(decTaxesWithheld);
                                  
                    output = changeNetValueOnPaycheck();
                }
            } catch (Exception e) {
                
                output = 'taxes withheld not a number';
            } 
        }
        
        if (output == 'paycheck updated' || output == 'no shift') {
            
            output = EmployeePaycheckView.refreshPage();
        } else if (output == 'no shift selected') {
            
            output = EmployeePaycheckView.createPaycheckNoShiftSelectedMessage();
        } else if (output == 'taxes withheld negative number') {
            
            output = EmployeePaycheckView.createPaycheckNegativeNumberErrorMessage();
        } else if (output == 'cannot withhold taxes') {
            
            output = EmployeePaycheckView.createPaycheckCannotWithholdTaxesErrorMessage();
        } else {
            
            output = EmployeePaycheckView.createPaycheckNotANumberErrorMessage();
        }
        
        formFeedback = output;
    }
    
    private static String addShiftsToPaycheck(String paycheckId, String shiftId, Decimal employeeWageAmount, Map<String, Decimal> numberOfHoursPerShift) {
        
        String output = '';
        List<String> eachShiftId = new List<String>();
        List<Decimal> eachSelectedShiftNumberOfHours = new List<Decimal>();
        
        shiftId = shiftId + '{}';
        shiftId = shiftId.replaceAll(',\\{\\}', '');
        shiftId = shiftId.replaceAll('\\{\\}', '');
        
        eachShiftId = shiftId.split(',');
        
        output += shiftId;
        
        //The for loop selects only the shifts that should be factored into the given paycheck.
        for (Integer i = 0; i < eachShiftId.size(); i++) {
            
            eachSelectedShiftNumberOfHours.add(numberOfHoursPerShift.get(eachShiftId.get(i)));
        }
        
        if (eachSelectedShiftNumberOfHours.size() > 0) {
            
            setEmployeePaycheckId(paycheckId);
            setEmployeeWageAmount(employeeWageAmount);
            setEmployeeNumberOfHoursPerShift(eachSelectedShiftNumberOfHours);
            
            output = createPaycheck();
        }
        
        return output;
    }
    
    public static String getFormFeedback() {
        
        return formFeedback;
    }
}
