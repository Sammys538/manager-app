const express = require("express");
const cors = require('cors');
require("dotenv").config();


const app = express();
const port = process.env.PORT;

app.use(cors());
app.use(express.json());

const db = require("./db");

app.get("/", (req, res) => {
    res.send("Backend is running!");
});

//Transaction Routes
app.post("/transactions", (req, res) => {

    // DEBUGGING
    // if (!req.body) {
    //     return res.status(400).json({ error: "No body sent" });
    // }

    const {transaction_type, category, transaction_desc, transaction_amount, admin_id} = req.body;

    const query = `
        INSERT INTO Transactions(transaction_type, category, transaction_desc, transaction_amount, admin_id)
        VALUES (? , ?, ?, ? , ?)
    `;

    db.query(query, [transaction_type, category, transaction_desc, transaction_amount, admin_id], (err, results) =>{
        if(err){
            console.error(err);
            return res.status(500).send("Database Error");
        }
        res.status(201).json({message:"Added Transaction", id: results.insertId});
    });
});

app.get("/transactions", (req, res) => {
    db.query("SELECT * FROM Transactions", (err, results) =>{
        if(err){
            console.error(err);
            return res.status(500).send("Database Error");
        }
        res.json(results);
    })
})

//Users Routes
app.post("/users", (req,res) =>{

    // DEBUGGING
    // if (!req.body) {
    //     return res.status(400).json({ error: "No body sent" });
    // }

    const {name, email, number, role} = req.body;

    const query = `
        INSERT INTO Users(name, email, number, role) 
        VALUES (?, ?, ?, ?)
    `;

    db.query(query, [name, email, number, role], (err, results) =>{
        if(err){
            console.error(err);
            return res.status(500).send("Database Error");
        }
        res.json({message: "User added", id: results.insertId});
    });
});


app.get("/users", (req, res) => {
    db.query("SELECT * FROM Users", (err, results) =>{
        if(err){
            console.error(err);
            return res.status(500).send("Database Error");
        }
        res.json(results);
    })
})

//Offerings Routes
app.post("/offerings", (req,res) =>{

    // DEBUGGING
    // if(!req.body) {
    //     return res.status(400).json({error: "No Body Sent"});
    // }

    const{member_name, amount, admin_id} = req.body;

    const query = `
        INSERT INTO Offerings(member_name, amount, admin_id)
        VALUES (?, ?, ?)
    `;

    db.query(query, [member_name, amount, admin_id], (err, results) =>{
        if(err){
            console.error(err);
            return res.status(500).send("Database Error");
        }
        res.status(201).json({message:"Added Transaction", id: results.insertId});
    });
});

app.get("/offerings", (req,res) =>{
    db.query("SELECT * FROM Offerings", (err, results) =>{
        if(err){
            console.error(err);
            return res.status(500).send("Database Error");
        }
        res.json(results);
    });
});





app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`)
});