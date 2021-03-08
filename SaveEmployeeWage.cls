public class SaveEmployeeWage {

    public static void saveEmployeeWage(List<EmployeeWage__c> useEmployeeWages) {
        
        try {
            
            for (EmployeeWage__c eachEmployeeWage: useEmployeeWages) {
                
                if (eachEmployeeWage.HourlyWage__c < 0) {
                    
                    eachEmployeeWage.addError('Wage must be at least 0.');
                }
            }
        } catch (DMLException e) {
            
            System.debug('Sorry, but your employee wage was not saved due to the following reasons: ' + e.getMessage());
        }
    }
}
