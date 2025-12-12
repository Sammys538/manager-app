const db = require('../db');

class Offerings {
    static tableName = 'Offerings';

    static async createOffering(data){
        const {member_name, amount, admin_id, offering_date} = data;

        return new Promise((resolve, reject) => {
            const sql = `INSERT INTO ${this.tableName} (member_name, amount, admin_id, offering_date)
            VALUES (?, ?, ?, ?)`;

            db.query(sql, [member_name, amount, admin_id, offering_date], (error,result) =>{
                if(error){
                    console.error("Error creating offerings: ", error);
                    return reject(error);
                }

                resolve({result});
            });
        });
    } 

    static async getAllOfferings(){
        return new Promise((resolve, reject) => {
            const sql = `SELECT * FROM ${this.tableName} ORDER BY offering_date DESC`;
            db.query(sql, (error, result) => {
                if(error){
                    console.error("Error fetching all offerings: " + error);
                    return reject(error);
                }

                resolve(result);
            });
        });
    }

    static async getOfferingsByName(data){
        const { member_name } = data;
        return new Promise((resolve, reject) => {
            const sql = `SELECT * FROM ${this.tableName} WHERE member_name = ?`;
            const values = [member_name];
            db.query(sql, values, (error, result) => {
                if(error){
                    console.error("Error fetching by name: " + error);
                    return reject(error);
                }
                resolve(result);

            });
        });
    }
}

module.exports = { Offerings };