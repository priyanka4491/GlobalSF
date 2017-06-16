Public class updateFederationIDHandler
{
    public static void updateFederationId (List<User> liUsers)
    {
        for(User userRecord : liUsers)
        {
           if(userRecord.FederationIdentifier != null)
            {
            userRecord.Fed_Id_Integration_Key__c = userRecord.FederationIdentifier;
            }
        }
    }
}