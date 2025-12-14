const db = require('../db');
const Transaction = require('./Transaction');
const Offerings = require('./Offerings');


async function getSummary() {
    const transactionIncome = Number(await Transaction.getAllIncome());
    const offeringsIncome = Number(await Offerings.getTotalIncome());
    const totalIncome = transactionIncome + offeringsIncome;

    const expenses = Number(await Transaction.getAllExpense());

    return{totalIncome, expenses, balance: totalIncome - expenses};
}

module.exports = { getSummary };