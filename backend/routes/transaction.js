const express = require('express');
const db = require('../db');
const router = express.Router();


router.post("/transaction", (req, res) => {

    // USE FOR DEBUGGING
    // if (!req.body) {
    //     return res.status(400).json({ error: "No body sent" });
    // }

    const {transaction_type, category, transaction_desc, transaction_amount, admin_id} = req.body;

    const query = `
        INSERT INTO Transactions(transaction_type, category, transaction_desc, transaction_amount, admin_id)
        VALUES (? , ?, ?, ? , ?)
    `;

    db.query(query, [transaction_type, category, transaction_desc, transaction_amount, admin_id], (error, results) =>{
        if(error){
            console.error(error);
            return res.status(500).send("Database Error");
        }
        res.status(201).json({message:"Added Transaction", id: results.insertId});
    });
});

router.get("/transactions", (req, res) => {
    db.query("SELECT * FROM Transactions", (error, results) =>{
        if(error){
            console.error(error);
            return res.status(500).send("Database Error");
        }
        res.json(results);
    })
})

module.exports = router;