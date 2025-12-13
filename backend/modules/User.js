const db = require('../db');
const bcrypt = require('bcrypt');
const { hashPassword } = require('../utils/hash');

class User {
    static tableName = 'Users';

    // Create a new user
    static async create(data) {
        const { email, password } = data;
        const hashedPassword = await hashPassword(password);

        return new Promise((resolve, reject) => {
            const sql = `INSERT INTO ${this.tableName} (email, password) VALUES (?, ?)`;
            db.query(sql, [email, hashedPassword], (error, result) => {
                if (error) {
                    console.error("Error creating user: ", error);
                    return reject(error);
                }

                resolve({result});
            });
        });
    }

    static async verifyPassword(email, password) {
        return new Promise((resolve, reject) => {
            db.query(`SELECT * FROM ${this.tableName} WHERE email = ?`, [email], (err, results) => {
                if (err) return reject(err);
                if (results.length === 0) return resolve(false);

                const user = results[0];
                const isMatch = bcrypt.compareSync(password, user.password);
                resolve(isMatch);
            });
        });
    }

    static async getUserByEmail(data){
        const { email } = data;
        return new Promise((resolve, reject) => {
            const sql = `SELECT * FROM ${this.tableName} WHERE email = ?`;
            const values = [email];
            db.query(sql, values, (error, result) => {
                if(error){
                    console.error("Error fetching by email: " + error);
                    return reject(error);
                }

                resolve(result.length ? result[0] : null);
            })
        })
    }

}

module.exports = { User };