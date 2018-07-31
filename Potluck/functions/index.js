const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.addEventToUsers = functions.firestore
.document('events/{eventID}')
.onCreate((snap, context) => {
      // Get an object representing the document
      const event = snap.data();
      console.log("eventID: " + event.eventID);
      
      // add the event to the host user document, and any users that exist
      addEventToUserDoc(event.host.userID, event.eventID);

      for (var i = 0; i < event.invites.length; i++) {
      	// send out emails to the guests
      	sendInvites(event.invites[i].email)

      	// add the event to the user doc
      	if (event.invites[i].userID) {
      		addEventToUserDoc(event.invites[i].userID, event.eventID);
      	}
      }
      return true;
  });

function addEventToUserDoc(userID, eventID) {
	const userRef = admin.firestore().collection('users').doc(userID);

	// get the user document by userID, append events/eventID [String]
	admin.firestore().runTransaction(transaction => {
		return transaction.get(userRef).then(doc => {
			const user = doc.data();
			if (user.events) {
				const updatedEvents = user.events;
				updatedEvents.push(eventID);
				transaction.update(userRef, { events: updatedEvents }, { merge: true });
			} else {
				transaction.set(userRef, { 'events': [eventID] }, { merge: true });
			}
		});
	}).then(function () {
		console.log("Function completed successfully. Event added to user: " + userID);
	}).catch(function (error) {
		console.log("Function failed: ", error);
	});
}

function sendInvites(userEmail) {

}
