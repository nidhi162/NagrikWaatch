const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const authRoutes = require("./routes/authRoutes");
const issueRoutes = require("./routes/issueRoutes");

const app = express();

// ===============================
// CONFIG
// ===============================

const PORT = process.env.PORT || 10000;

// ===============================
// MIDDLEWARE
// ===============================

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ===============================
// HEALTH CHECK
// ===============================

app.get("/", (req, res) => {
  res.json({
    message: "NagrikWaatch API is running 🚀",
    status: "online",
  });
});

// ===============================
// ROUTES
// ===============================

app.use("/auth", authRoutes);
app.use("/issues", issueRoutes);

// ===============================
// 404 HANDLER
// ===============================

app.use((req, res) => {
  res.status(404).json({
    message: "Route not found",
    path: req.originalUrl,
  });
});

// ===============================
// START SERVER
// ===============================

async function startServer() {
  try {
    const mongoUri = process.env.MONGO_URI;

    // Safe diagnostic — does NOT print your password
    console.log("MONGO_URI exists:", !!mongoUri);

    if (!mongoUri) {
      throw new Error("MONGO_URI environment variable is missing");
    }

    console.log(
      "MONGO_URI starts with:",
      mongoUri.substring(0, 15)
    );

    // Check MongoDB URI format
    if (
      !mongoUri.startsWith("mongodb://") &&
      !mongoUri.startsWith("mongodb+srv://")
    ) {
      throw new Error(
        "MONGO_URI must start with mongodb:// or mongodb+srv://"
      );
    }

    await mongoose.connect(mongoUri);

    console.log("MongoDB connected successfully ✅");

    app.listen(PORT, "0.0.0.0", () => {
      console.log(`Server running on port ${PORT}`);
    });
  } catch (error) {
    console.error("MongoDB connection failed ❌");
    console.error(error.message);

    process.exit(1);
  }
}

startServer();