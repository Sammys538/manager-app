const express = require('express');
const db = require('../db');
const bcrypt = require('bcrypt');
const router = express.Router();
const jwt = require("jsonwebtoken");
const { User } = require("../modules/User");
require("dotenv").config();

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


router.post("/login", async (req, res) =>{
    const {email, password} = req.body;

    if(!email || !password){
        return res.status(400).send("Missing Body");
    }

    try{
        const user = await User.getUserByEmail( { email } );

        if(!user) {
            return res.status(401).json({error: "invalid email or password"});
        }

        const isMatch = await bcrypt.compare(password, user.password);

        if(!isMatch){
            return res.status(401).json({error: "Invalid email or password"});
        }

        const token = jwt.sign(
            {
                id_users: user.id_users,
                email: user.email
            },
            process.env.JWT_SECRET,
            { expiresIn: "1h"}
        );

        res.json({message: "Login successful", token, user: {
            email: user.email,
            id_users: user.id_users,
         }
        });
    } catch(error){
        console.error(error);
        res.status(500).json({error: "Server Error"});
    }
});


module.exports = router;
