public class EmployeePunchesView {

    //Variables
    public static List<List<String>> shifts;
    public static List<List<String>> punches;
    
    public static String refreshPage() {
        
        String output = '';
        
        output += '<script type=\"text/javascript\">\n';
        output += 'window.location = document.location.href.replace(\"#\", \"\");\n';
        output += '</script>\n';
        
        return output;
    }
    
    public static String showShifts() {
        
        String output = '';
        
        List<String> find = new List<String>();
        List<String> replace = new List<String>();
        
        find.add('<script');
        find.add('<style');
        find.add('"');
        find.add('\'');
        find.add('<br />');
        find.add('<br>');
        find.add('<div>');
        find.add('</div>');
        
        replace.add('&lt;script');
        replace.add('&lt;style');
        replace.add('&quot;');
        replace.add('&apos;');
        replace.add(' ');
        replace.add('');
        replace.add('');
        replace.add('');
        
        output += '[';
        
        for (Integer i = 0; i < shifts.get(0).size(); i++) {
            
            output += '{"row_id": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(shifts.get(0).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"weekday": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(shifts.get(1).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"schedule_date": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(shifts.get(2).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"start_time": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(shifts.get(3).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"end_time": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(shifts.get(4).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '"}, ';
        }
        
        output += '{}]';
        
        output = output.replace(', {}', '');
        
        return output;
    }
    
    public static String showPunches() {
        
        String output = '';
        
        List<String> find = new List<String>();
        List<String> replace = new List<String>();
        
        find.add('<script');
        find.add('<style');
        find.add('"');
        find.add('\'');
        find.add('<br />');
        find.add('<br>');
        find.add('<div>');
        find.add('</div>');
        
        replace.add('&lt;script');
        replace.add('&lt;style');
        replace.add('&quot;');
        replace.add('&apos;');
        replace.add(' ');
        replace.add('');
        replace.add('');
        replace.add('');
        
        output += '[';
        
        for (Integer i = 0; i < punches.get(0).size(); i++) {
            
            output += '{"punch_name": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(punches.get(0).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"punch_date": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(punches.get(1).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"punch_time": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(punches.get(2).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"punch_type": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(punches.get(3).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"employee_weekly_schedule": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(punches.get(4).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '"}, ';
        }
        
        output += '{}]';
        
        output = output.replace(', {}', '');
        
        return output;
    }
}
