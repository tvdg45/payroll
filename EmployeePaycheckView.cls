public class EmployeePaycheckView {

    public static String createPaycheckNoShiftSelectedMessage() {
        
        String output = '';
        
        output += '<script>\n';
        output += 'document.getElementById("create_paycheck_feedback").innerHTML = "<br /><label><span style=\\"color: red; font-size: 12pt\\">You must add at least one worked shift to a paycheck.</span></label>";\n';
        output += '</script>\n';
        
        return output;
    }
    
    public static String createPaycheckNegativeNumberErrorMessage() {
        
        String output = '';
        
        output += '<script>\n';
        output += 'document.getElementById("create_paycheck_feedback").innerHTML = "<br /><label><span style=\\"color: red; font-size: 12pt\\">Taxes withheld must be 0 or a positive number.</span></label>";\n';
        output += '</script>\n';
        
        return output;
    }
    
    public static String createPaycheckCannotWithholdTaxesErrorMessage() {
        
        String output = '';
        
        output += '<script>\n';
        output += 'document.getElementById("create_paycheck_feedback").innerHTML = "<br /><label><span style=\\"color: red; font-size: 12pt\\">Taxes cannot be withheld from this employee.  Enter a 0 for taxes withheld.</span></label>";\n';
        output += '</script>\n';
        
        return output;
    }
    
    public static String createPaycheckNotANumberErrorMessage() {
        
        String output = '';
        
        output += '<script>\n';
        output += 'document.getElementById("create_paycheck_feedback").innerHTML = "<br /><label><span style=\\"color: red; font-size: 12pt\\">Taxes witheld must be a whole number or decimal number.</span></label>";\n';
        output += '</script>\n';
        
        return output;
    }
    
    public static String refreshPage() {
        
        String output = '';
        
        output += '<script type=\"text/javascript\">\n';
        output += 'window.location = document.location.href.replace(\"#\", \"\");\n';
        output += '</script>\n';
        
        return output;
    }
}
