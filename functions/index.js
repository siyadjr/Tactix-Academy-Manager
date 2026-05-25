const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
admin.initializeApp();

// =============================================================
// 1 & 2. License Status Changes (Manager & Admin App)
// =============================================================
exports.onLicenseStatusChange = onDocumentUpdated("Managers/{managerId}", async (event) => {
  const newValue = event.data.after.data();
  const previousValue = event.data.before.data();

  const newStatus = newValue["license status"];
  const prevStatus = previousValue["license status"];

  // Return if the license status did not change
  if (newStatus === prevStatus) return null;

  // 🔴 1. Manager Requested License -> Send Notification to Admins
  if (newStatus === "pending") {
    const managerName = newValue.name || "A Manager";
    
    try {
      const adminSnapshot = await admin.firestore().collection("admin").get();
      const tokens = [];
      adminSnapshot.forEach((doc) => {
        const data = doc.data();
        if (data.fcmToken) {
          tokens.push(data.fcmToken);
        }
      });

      if (tokens.length > 0) {
        const message = {
          notification: {
            title: "New License Verification Request",
            body: `${managerName} has requested license verification.`,
          },
          tokens: tokens,
        };
        await admin.messaging().sendEachForMulticast(message);
        console.log("Admin notification sent successfully.");
      }
    } catch (error) {
      console.error("Error notifying admin:", error);
    }
  }

  // 🟢 2. Admin Approved/Rejected License -> Send Notification to Manager
  if (prevStatus === "pending" && (newStatus === "approved" || newStatus === "rejected")) {
    const managerToken = newValue.fcmToken;
    if (!managerToken || managerToken === "Not Assigned") {
      console.log("Manager fcmToken is missing.");
      return null;
    }

    try {
      const message = {
        notification: {
          title: "License Request Status",
          body: `Your coaching license verification has been ${newStatus}.`,
        },
        token: managerToken,
      };
      await admin.messaging().send(message);
      console.log(`Manager notification sent for: ${newStatus}`);
    } catch (error) {
      console.error("Error notifying manager:", error);
    }
  }

  return null;
});

// =============================================================
// 3. Player Requests to Join Team -> Send Notification to Manager
// =============================================================
exports.onPlayerJoinRequest = onDocumentUpdated("Teams/{teamId}", async (event) => {
  const newValue = event.data.after.data();
  const previousValue = event.data.before.data();
  const teamId = event.params.teamId;

  const newRequests = newValue.playersRequests || [];
  const prevRequests = previousValue.playersRequests || [];

  // Trigger only if a new player request is added
  if (newRequests.length > prevRequests.length) {
    try {
      // Query the Managers collection to find the manager of this team
      const managerSnapshot = await admin
        .firestore()
        .collection("Managers")
        .where("teamId", "==", teamId)
        .limit(1)
        .get();

      if (managerSnapshot.empty) {
        console.log("No manager found for this team.");
        return null;
      }

      const managerData = managerSnapshot.docs[0].data();
      const managerToken = managerData.fcmToken;

      if (managerToken && managerToken !== "Not Assigned") {
        const message = {
          notification: {
            title: "New Join Request",
            body: "A new player has requested to join your team.",
          },
          token: managerToken,
        };
        await admin.messaging().send(message);
        console.log("Notification sent to manager.");
      }
    } catch (error) {
      console.error("Error sending join request notification to manager:", error);
    }
  }
  return null;
});

// =============================================================
// 4. Manager Accepts Join Request -> Send Notification to Player
// =============================================================
exports.onPlayerAccepted = onDocumentUpdated("Players/{playerId}", async (event) => {
  const newValue = event.data.after.data();
  const previousValue = event.data.before.data();

  const newTeamId = newValue.teamId;
  const prevTeamId = previousValue.teamId;

  // Trigger when a player gets accepted (teamId changes from 'Not Assigned' to a valid team ID)
  if (newTeamId && newTeamId !== "Not Assigned" && prevTeamId === "Not Assigned") {
    const playerToken = newValue.fcmToken;

    if (playerToken && playerToken !== "Not Assigned") {
      try {
        const message = {
          notification: {
            title: "Join Request Accepted 🎉",
            body: "Your request to join the team has been accepted by the manager.",
          },
          token: playerToken,
        };
        await admin.messaging().send(message);
        console.log("Notification sent to player.");
      } catch (error) {
        console.error("Error sending notification to player:", error);
      }
    }
  }
  return null;
});
