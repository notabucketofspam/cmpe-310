const fs = require('node:fs');
const datafile = fs.readFileSync('./data.txt',{encoding:'utf8'});
/**@type{number[]} */
const alls = datafile.split(/\s/).filter(Boolean).map(Number);
alls.shift();
const res = alls.reduce((ax, cx)=>ax+cx);

console.log(res);
