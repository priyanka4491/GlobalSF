/*
Created By: Vijay Ramesh
Created Date: 08/12/2016
Description:  This trigger is doing update call of SAML Federation Id to Federation Id.
*/
trigger updateFederationID on User (before insert, before update) {
    List<User> liUsers = new List<User>();
    liUsers = Trigger.new;
    updateFederationIDHandler.updateFederationId(liUsers);
}