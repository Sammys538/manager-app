const db = require('../db');
const bcrypt = require('bcrypt');
const { hashPassword } = require('../utils/hash');

class User {
    static tableName = 'Users';

    static async create(data) {
        const { email, password } = data;
        const hashedPassword = await hashPassword(password);

        const sql = `INSERT INTO ${this.tableName} (email, password) VALUES (?, ?)`;

        try{
            const [result] = await db.query(sql, [email, hashedPassword]);
            return result;
        } catch(error){
            console.error("Error creating user: ", error);
            throw error;
        }
    }

    static async verifyPassword(email, password) {
        try{
            const [results] = await db.query(`SELECT * FROM ${this.tableName} WHERE email = ?`, [email]);
            if (results.length === 0){
                return false
            }
            const user = results[0];
            const isMatch = await bcrypt.compare(password, user.password);
            return isMatch;
        } catch (error) {
            console.error("Error verifying password: ", error);
            throw error;
        }
    }

    static async getUserByEmail({ email }) {
        try {
            const [results] = await db.query(
                `SELECT * FROM ${this.tableName} WHERE email = ?`,
                [email]
            );
            return results.length ? results[0] : null;
        } catch (error) {
            console.error("Error fetching by email: ", error);
            throw error;
        }
    }

}

module.exports = { User };