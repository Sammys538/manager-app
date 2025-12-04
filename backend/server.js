const express = require("express");
const mysql = require("mysql2");
require("dotenv").config();


const app = express();
const port = 3000;

app.use(express.json());

// const db = mysql.createConnection({
//     host: process.env.DB_HOST,
//     user: process.env.DB_USER,
//     password: process.env.DB_PASSWORD,
//     database: process.env.DB_NAME
// });

// db.connect(err => {
//     if(err) {
//         console.error("Error connecting to MySQL: ", err);
//         return;
//     }
//     console.log("Connected to MySQL");
// });

app.get("/", (req, res) => {
    res.send("Backend is running!");
});

//Transaction Routes
app.post("/transaction", (req, res) => {
    const {type, amount, description, date} = req.body;

    console.log("transaction received: " + req.body);

    res.json({message: "transaction received", data: req.body});
})

app.get("/transaction", (req, res) => {
    const sample = [
    { id: 1, type: "Income", amount: 200, description: "Service Money"},
    { id: 2, type: "Expenses", amount: 20, description: "Purchases"}
    ]

    res.json(sample);
})

//Users Routes
app.post("/users", (req, res) => {
    const {name, email} = req.body;
    console.log("New user", req.body);

    res.json({message: "New User Added", data: req.body});

})

app.get("/users", (req, res) => {
    const userSample = [
        {id: 1, name: "Sam" , email: "dummy@email.com"},
        {id: 2, name: "Jane Doe", email: "Test@test.com"}
    ]

    res.json(userSample);
})



app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`)
});