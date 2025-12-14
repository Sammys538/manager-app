const express = require('express');
const router = express.Router();
const { getSummary } = require('../modules/Summary');

router.get("/", async (req, res) => {
    try{
        const summary = await getSummary();
        res.json(summary);
    } catch(error){
        console.error(error);
        res.status(500).json({error: "Failed to fetch summary"});
    }
});

module.exports = router;