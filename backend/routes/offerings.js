const express = require('express');
const db = require('../db');
const router = express.Router();
const Offerings = require('../modules/Offerings');


router.post("/", async (req,res) =>{
    const data = req.body;

    if(!data){
        return res.status(400).send("Missing Body");
    }

    const{ member_name, amount, admin_id, offering_date } = data;

    if(!member_name || !amount || !admin_id || !offering_date){
        return res.status(400).send("Missing values");
    }

    try{
        const offerings = await Offerings.createOffering(data);
        res.status(201).json({message: "Offerings created"});
    } catch(error){
        res.status(500).send("Error creating offerings: " + error.message);
    }
});

router.get("/", async (req,res) =>{
    try{
        const offerings = await Offerings.getAllOfferings();
        res.status(200).json({message: "Fetching SuccessFul", offerings: offerings});
    } catch(error){
        res.status(500).send("Error fetching offerings: " + error.message);
    }
});

router.get("/search", async (req, res) => {
    const {member_name} = req.query;

    if(!member_name) {
        return res.status(400).send("Missing member name");
    }

    try{
        const offerings = await Offerings.getOfferingsByName({member_name});
        res.status(200).json({message: "Fetch by name successful", offerings: offerings});
    } catch(error){
        res.status(500).send("Error fetching offerings by name: " + error);
    }
});

module.exports = router;