const bcrypt = require('bcrypt');


async function hashPassword(password) {
    return await bcrypt.hashSync(password, 10);
}


module.exports = { hashPassword };