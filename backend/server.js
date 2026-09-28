const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const app = express();

const PORT = process.env.PORT || 5000;

// ===============================
// MIDDLEWARE
// ===============================

app.use(cors());
app.use(express.json());

// ===============================
// TEST ROUTE
// ===============================

app.get("/", (req, res) => {
  res.status(200).json({
    success: true,
    message: "NagrikWaatch API is running 🚀",
  });
});

// ===============================
// AUTH ROUTES
// ===============================

const authRoutes = require("./routes/authRoutes");

app.use("/auth", authRoutes);

// ===============================
// MONGODB + SERVER
// ===============================

async function startServer() {
  try {
    await mongoose.connect(process.env.MONGO_URI);

    console.log("MongoDB connected successfully ✅");

    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error("MongoDB connection failed ❌");
    console.error(error.message);
  }
}

startServer();
