const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const fcm = admin.messaging();

exports.sendGeneralNotification = functions
    .region("us-central1")
    .firestore.document("notifications/{documentId}")
    .onCreate(async(snap, context) => {
        const notificationData = snap.data();
        let attachments;

        if (notificationData.attachments) {
            attachments = notificationData.attachments;
        }

        const message = {
            notification: {
                title: notificationData.title,
                body: notificationData.message,
            },
            data: {
                ...(attachments ? { attachments: JSON.stringify(attachments) } : {}),
                createdTime: notificationData.notificationTime.toDate().toUTCString(),
            },
            topic: "test-notification",
        };

        return fcm
            .send(message)
            .then(function(response) {
                return console.log("Successfully sent message:", response);
            })
            .catch(function(error) {
                return console.log("Error sending message:", error);
            });
    });