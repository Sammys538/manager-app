const db = require('../db');

class Offerings {
    static tableName = 'Offerings';

    static async createOffering(data){
        const {member_name, amount, admin_id, offering_date} = data;

        const sql = `INSERT INTO ${this.tableName} (member_name, amount, admin_id, offering_date)
        VALUES (?, ?, ?, ?)`;

        try{
            const [results] = await db.query(sql, [member_name, amount, admin_id, offering_date]);
            return results;
        } catch (error){
            console.error("Error creating offering: ", error);
            throw error;
        }
    } 

    static async getAllOfferings(){
        const sql = `SELECT * FROM ${this.tableName} ORDER BY offering_date DESC`;

        try{
            const [results] = await db.query(sql);
            return results;
        } catch (error){
            console.error("Error fetching offerings: ", error);
            throw error;
        }
    }

    static async getOfferingsByName({member_name}){
        try{
            const [results] = await db.query(`SELECT * FROM ${this.tableName} WHERE
            member_name = ?`, [member_name]);
            return results.length ? results[0] : null;
        } catch (error){
            console.error("Error fetching by name: ", error);
            throw error;
        }
    }

    static async getTotalIncome(){
        const [income] = await db.query(`SELECT SUM(amount) AS total FROM ${this.tableName}`);
        return income[0].total || 0;
    }
}

module.exports = Offerings;