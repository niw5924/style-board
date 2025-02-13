const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const serviceAccount = require("./serviceAccountKey.json");

// Firebase Admin SDK 초기화 (명시적으로 서비스 계정 사용)
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

exports.getFirebaseCustomToken = functions.https.onRequest(async (req, res) => {
  try {
    const { kakaoAccessToken } = req.body;

    if (!kakaoAccessToken) {
      return res.status(400).json({ error: "Kakao Access Token이 필요합니다." });
    }

    // Kakao API를 호출하여 사용자 정보 가져오기
    const kakaoResponse = await axios.get("https://kapi.kakao.com/v2/user/me", {
      headers: { Authorization: `Bearer ${kakaoAccessToken}` },
    });

    const kakaoUserId = kakaoResponse.data.id;
    if (!kakaoUserId) {
      throw new Error("Kakao 사용자 ID를 가져올 수 없습니다.");
    }

    const kakaoUserIdString = kakaoUserId.toString();
    console.log("Kakao 사용자 ID:", kakaoUserIdString);

    // Firebase Custom Token 생성
    const customToken = await admin.auth().createCustomToken(kakaoUserIdString);
    console.log("Firebase Custom Token 생성 성공:", customToken);

    return res.status(200).json({ firebaseCustomToken: customToken });
  } catch (error) {
    console.error("Custom Token 생성 실패:", error.message);
    return res.status(500).json({ error: "Custom Token 생성 실패", details: error.message });
  }
});
