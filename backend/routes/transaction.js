const express = require('express');
const db = require('../db');
const router = express.Router();
const { Transaction } = require('../modules/Transaction');


router.post("/", async (req, res) => {
    const data = req.body;

    if(!data){
        return res.status(400).send("Missing body");
    }

    const{ transaction_type, category, transaction_desc, transaction_amount, admin_id} = data;

    if(!transaction_type || !category || !transaction_desc || !transaction_amount || !admin_id){
        return res.status(400).send("Missing values");
    }

    try{
        const transaction = await Transaction.createTransaction(data);
        res.status(201).json({message: "Transaction created"});
    } catch(error){
        res.status(500).send("Error creating transaction: " + error.message);
    }
});


router.get("/", async (req, res) => {
    try{
        const transactions = await Transaction.getAllTransactions();
        res.status(200).json({message: "Fetching Successfull", transactions: transactions});
    } catch(error){
        res.status(500).send("Error fetching transactions: " + error.message);
    }
});



module.exports = router;