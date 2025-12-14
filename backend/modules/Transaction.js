const db = require('../db');

class Transaction {
    static tableName = 'Transactions';

    static async createTransaction(data){
        const {transaction_type, category, transaction_desc, transaction_amount, admin_id} = data;

        return new Promise((resolve, reject) => {
            const sql = `INSERT INTO ${this.tableName} (transaction_type, category, transaction_desc, transaction_amount, admin_id)
            VALUES (? , ?, ?, ? , ?)`;
            db.query(sql, [transaction_type, category, transaction_desc, transaction_amount, admin_id], (error, result) => {
                if(error){
                    console.error("Error creating transaction: ", error);
                    return reject(error);
                }

                resolve({result});
            });
        });
    }

    static async getAllTransactions(){
        return new Promise((resolve, reject) => {
            const sql = `SELECT * FROM ${this.tableName} ORDER BY transaction_date DESC`;
            db.query(sql, (error, result) => {
                if(error){
                    console.error("Error fetching all transactions: ", error);
                    return reject(error);
                }

                resolve(result);
            });
        });
    }

    static async getAllIncome(){
        const [income] = await db.query(`SELECT SUM(transaction_amount) AS total FROM ${this.tableName} WHERE transaction_type = 'Income'`);
        return income[0].total || 0;
    }

    static async getAllExpense(){
        const [expense] = await db.query(`SELECT SUM(transaction_amount) AS total FROM ${this.tableName} WHERE transaction_type = 'Expense'`);
        return expense[0].total || 0;
    }

}

module.exports = Transaction;