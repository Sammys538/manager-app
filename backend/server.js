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


// app.post("/signup", async (req, res) => {
//     const {email, password} = req.body;

//     try {
//         const hashPassword = await bcrypt.hash(password, 10);

//         const sql = `INSERT INTO Users (email, password) 
//         VALUES (?, ?)`;
//         db.query(sql, [email, hashPassword], (err, result) => {
//             if(err){
//                 return res.status(500).send("Error saving user credentials");
//             } else {
//                 res.send("User created");
//             }
//         });
//     } catch(err){
//         res.status(500).send("Server Error");
//     }
// });

const authRoutes = require('./routes/auth');
app.use("/api/auth", authRoutes);


app.post("/login", (req, res) =>{
    const {email, password} = req.body;

    db.query("SELECT * FROM Users WHERE email = ?", [email], async (err, results) => {
        if(err) {
            return res.status(500).send("Error");
        }
        
        if(results.length == 0){
            return res.status(500).send("User was not found");
        }

        const emailUser = results[0];

        const comparison = await bcrypt.compare(password, emailUser.password);


        if(!comparison){
            return res.status(400).send("Incorrect Password");
        }

        res.send("Login successful");
    });


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