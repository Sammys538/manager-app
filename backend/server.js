const express = require("express");
const mysql = require("mysql2");
require("dotenv").config();


const app = express();
const port = 3000;

app.use(express.json());

const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.connect(err => {
    if(err) {
        console.error("Error connecting to MySQL: ", err);
        return;
    }
    console.log("Connected to MySQL");
});





app.get("/", (req, res) => {
    res.send("Backend is running!");
});



app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`)
});