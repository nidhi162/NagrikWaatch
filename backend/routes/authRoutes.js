const express = require("express");

const {
  registerUser,
  loginUser,
} = require("../controller/authController");

const router = express.Router();

// ===============================
// REGISTER
// POST /auth/register
// ===============================

router.post("/register", registerUser);

// ===============================
// LOGIN
// POST /auth/login
// ===============================

router.post("/login", loginUser);

module.exports = router;