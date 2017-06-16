@isTest
public class updateFederationIDHandlerTest{

    static testMethod void updateFederationIDHandlerTestMethod() {
        test.startTest();
        List<User> usrList = TestUtilClass.createTestUsers('System Administrator',1);
        system.assertequals('admUser0@asdf.com',usrList[0].Email);
        test.stopTest();
    }
}