const crypto = require('crypto');

//###################################################
//######----------MD5 HEX DIGEST--------#############
//###################################################
const hashed = crypto.createHash('md5').update(whatToHash).digest("hex");

//###################################################
//######--------HMAC MD5 HEX DIGEST--------##########
//###################################################
//creating hmac object 
var hmac = crypto.createHmac('md5', whatToHash);
//passing the data to be hashed
data = hmac.update(beforeHash);
//Creating the hmac in the required format
gen_hmac = data.digest('hex');