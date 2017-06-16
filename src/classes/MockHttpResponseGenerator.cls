/* 
*
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @Description : It is used to handle the multiple requests with respect to each endpoint.
*/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {    
    Map<String, HttpCalloutMock> requests;
    public MockHttpResponseGenerator(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        return mock.respond(req);
    }

    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}