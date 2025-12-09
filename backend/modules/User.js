const db = require('../db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

class User {
    static tableName = 'Users';

    // Hash password
    static hashPassword(password) {
        return bcrypt.hashSync(password, 10);
    }

    // Create a new user
    static async create(data) {
        const { email, password } = data;
        const hashedPassword = this.hashPassword(password);

        return new Promise((resolve, reject) => {
            const sql = `INSERT INTO ${this.tableName} (email, password) VALUES (?, ?)`;
            db.query(sql, [email, hashedPassword], (error, result) => {
                if (error) {
                    console.error("Error creating user: ", error);
                    return reject(err);
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

}

module.exports = { User };