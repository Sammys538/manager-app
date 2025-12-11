const express = require('express');
const db = require('../db');
const router = express.Router();


router.post("/offerings", (req,res) =>{

    // USE FOR DEBUGGING
    // if(!req.body) {
    //     return res.status(400).json({error: "No Body Sent"});
    // }

    const{member_name, amount, admin_id} = req.body;

    const query = `
        INSERT INTO Offerings(member_name, amount, admin_id)
        VALUES (?, ?, ?)
    `;

    db.query(query, [member_name, amount, admin_id], (error, results) =>{
        if(error){
            console.error(error);
            return res.status(500).send("Database Error");
        }
        res.status(201).json({message:"Added Transaction", id: results.insertId});
    });
});

router.get("/offerings", (req,res) =>{
    db.query("SELECT * FROM Offerings", (error, results) =>{
        if(error){
            console.error(error);
            return res.status(500).send("Database Error");
        }
        res.json(results);
    });
});

module.exports = router;