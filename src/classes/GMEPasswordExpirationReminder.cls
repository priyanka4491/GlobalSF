public class GMEPasswordExpirationReminder implements Schedulable {
    public void execute(SchedulableContext sc){
        Integer passwordExpirationDuration=90;
        Date d=Date.today()+7-passwordExpirationDuration;        
        List<User> listOfUsers=[select id,name,Email,LastPasswordChangeDate from User where username like 'conductor.integration.service@monsanto.com%' or username like 'help.idm@monsanto.com%' ];
        String emailMessage='Your GME MergedDev Salesforce Password will expire soon. Please reset your password';
        try{
        for(User u:listOfUsers){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new string[] {String.valueOf(u.Email)};
                mail.setToAddresses(toAddresses);
                mail.setReplyTo('noreply@monsanto.com');  
                mail.setSenderDisplayName('Salesforce password reset reminder');  
                mail.setSubject('Password Expiration Reminder');
                mail.setPlainTextBody(emailMessage);
                mail.setHtmlBody(emailMessage);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
            }
        }
        catch (system.emailException ee){
        system.debug(ee.getMessage());}
        catch (Exception e){
        system.debug(e.getmessage());}
    }
}