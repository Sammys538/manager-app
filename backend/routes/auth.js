const express = require('express');
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
        // const hashPassword = await bcrypt.hash(password, 10);

        // const sql = `INSERT INTO Users (email, password) 
        // VALUES (?, ?)`;
        // db.query(sql, [email, hashPassword], (err, result) => {
        //     if(err){
        //         return res.status(500).send("Error saving user credentials");
        //     } else {
        //         res.send("User created");
        //     }
        // });
    } catch(err){
        res.status(500).send("Error creating user: " + err.message);
    }
});

module.exports = router;
