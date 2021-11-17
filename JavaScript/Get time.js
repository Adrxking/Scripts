const moment = require('moment-timezone');

// Hora en china
const timestam = Date.now()
const a = moment.tz(timestam, "Asia/Taipei");
const b = a.format();
const replace1 = b.replace('T', ' ');
const timestamp = replace1.replace('+08:00', '');