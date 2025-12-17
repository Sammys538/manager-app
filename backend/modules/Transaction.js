const db = require('../db');

class Transaction {
    static tableName = 'Transactions';

    static async createTransaction(data){
        const {transaction_type, category, transaction_desc, transaction_amount, admin_id} = data;

        const sql = `INSERT INTO ${this.tableName} (transaction_type, category, transaction_desc, transaction_amount, admin_id)
        VALUES (? , ?, ?, ? , ?)`;

        try{
            const [results] = await db.query(sql, [transaction_type, category, transaction_desc, transaction_amount, admin_id]);
            return results;
        } catch (error){
            console.error("Error creating transaction: ", error);
            throw error;
        }
    }

    static async getAllTransactions(){
        const sql = `SELECT * FROM ${this.tableName} ORDER BY transaction_date DESC`;

        try{
            const [results] = await db.query(sql);
            return results;
        } catch (error){
            console.error("Error fetching all transactions: ", error);
            throw error;
        }
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