const Issue = require("../model/Issue");

// GET ALL ISSUES
const getIssues = async (req, res) => {
  try {
    const issues = await Issue.find()
      .populate("reportedBy", "name email")
      .sort({ createdAt: -1 });

    res.status(200).json(issues);
  } catch (error) {
    res.status(500).json({
      message: "Failed to fetch issues",
      error: error.message,
    });
  }
};


// GET SINGLE ISSUE
const getIssueById = async (req, res) => {
  try {
    const issue = await Issue.findById(req.params.id)
      .populate("reportedBy", "name email");

    if (!issue) {
      return res.status(404).json({
        message: "Issue not found",
      });
    }

    res.status(200).json(issue);
  } catch (error) {
    res.status(500).json({
      message: "Failed to fetch issue",
      error: error.message,
    });
  }
};


// CREATE ISSUE
const createIssue = async (req, res) => {
  try {
    const {
      title,
      description,
      category,
      latitude,
      longitude,
      image,
    } = req.body;

    if (
      !title ||
      !description ||
      latitude === undefined ||
      longitude === undefined
    ) {
      return res.status(400).json({
        message:
          "Title, description, latitude and longitude are required",
      });
    }

    const issue = await Issue.create({
      title,
      description,
      category,
      latitude,
      longitude,
      image: image || "",
      reportedBy: req.user.id,
    });

    res.status(201).json({
      message: "Issue created successfully",
      issue,
    });
  } catch (error) {
    res.status(500).json({
      message: "Failed to create issue",
      error: error.message,
    });
  }
};


// UPDATE ISSUE
const updateIssue = async (req, res) => {
  try {
    const issue = await Issue.findById(req.params.id);

    if (!issue) {
      return res.status(404).json({
        message: "Issue not found",
      });
    }

    issue.title =
      req.body.title || issue.title;

    issue.description =
      req.body.description || issue.description;

    issue.category =
      req.body.category || issue.category;

    issue.status =
      req.body.status || issue.status;

    issue.latitude =
      req.body.latitude ?? issue.latitude;

    issue.longitude =
      req.body.longitude ?? issue.longitude;

    issue.image =
      req.body.image ?? issue.image;

    const updatedIssue = await issue.save();

    res.status(200).json({
      message: "Issue updated successfully",
      issue: updatedIssue,
    });
  } catch (error) {
    res.status(500).json({
      message: "Failed to update issue",
      error: error.message,
    });
  }
};


// DELETE ISSUE
const deleteIssue = async (req, res) => {
  try {
    const issue = await Issue.findById(req.params.id);

    if (!issue) {
      return res.status(404).json({
        message: "Issue not found",
      });
    }

    await issue.deleteOne();

    res.status(200).json({
      message: "Issue deleted successfully",
    });
  } catch (error) {
    res.status(500).json({
      message: "Failed to delete issue",
      error: error.message,
    });
  }
};


module.exports = {
  getIssues,
  getIssueById,
  createIssue,
  updateIssue,
  deleteIssue,
};