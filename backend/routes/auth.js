const express = require('express');
const db = require('../db');
const bcrypt = require('bcrypt');
const router = express.Router();
const { User } = require("../modules/User");

router.post("/signup", async (req, res) => {
    const {email, password} = req.body;

    if(!email || !password){
        return res.status(500).send("Login Credentials Required");
    }

    try {
        const user = await User.create({email, password});
        res.status(200).json({message: "User created"});
    } catch(err){
        res.status(500).send("Error creating user: " + err.message);
    }
});


router.post("/login", (req, res) =>{
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


module.exports = router;
