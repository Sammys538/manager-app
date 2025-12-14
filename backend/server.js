const express = require("express");
const cors = require('cors');
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
require("dotenv").config();


const app = express();
const port = process.env.PORT;

app.use(cors());
app.use(express.json());

const db = require("./db");

app.get("/", (req, res) => {
    res.send("Backend is running!");
});

const authRoutes = require('./routes/auth');
app.use("/", authRoutes);


const transactionRoutes = require('./routes/transaction');
app.use("/transaction", transactionRoutes);

const offeringsRoutes = require('./routes/offerings');
app.use('/offerings', offeringsRoutes);

const summaryRoutes = require('./routes/summary');
app.use("/summary", summaryRoutes);

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`)
});