
const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

// Home API
app.get("/", (req, res) => {
    res.json({
        message: "AWS ECS application is running!",
        environment: process.env.ENVIRONMENT || "local"
    });
});

// Health Check API
app.get("/health", (req, res) => {
    res.status(200).json({
        status: "healthy"
    });
});

// Start server only when this file is executed directly
if (require.main === module) {
    app.listen(PORT, "0.0.0.0", () => {
        console.log(`Application running on port ${PORT}`);
    });
}

// Export app for Jest and Supertest
module.exports = app;
