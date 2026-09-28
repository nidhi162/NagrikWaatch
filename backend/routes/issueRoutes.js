const express = require("express");

const {
  getIssues,
  getIssueById,
  createIssue,
  updateIssue,
  deleteIssue,
} = require("../controller/issueController");

const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

router.get("/", getIssues);

router.get("/:id", getIssueById);

router.post("/", authMiddleware, createIssue);

router.put("/:id", authMiddleware, updateIssue);

router.delete("/:id", authMiddleware, deleteIssue);

module.exports = router;