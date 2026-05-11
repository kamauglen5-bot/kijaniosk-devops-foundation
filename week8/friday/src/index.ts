import express from "express";

const app = express();
const PORT = 3001;

const VERSION = process.env.VERSION || "1.0.0";

app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    version: VERSION
  });
});

app.listen(PORT, () => {
  console.log(`kk-payments running on port ${PORT}`);
});
