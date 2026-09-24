#!/usr/bin/node
const fs = require('node:fs');
const datapath = process.argv[2] || './data.txt';
const datafile = fs.readFileSync(datapath,{encoding:'utf8'});
/**@type{number[]} */
const alls = datafile.split(/\s/).filter(Boolean).map(Number);
alls.shift();
const res = alls.reduce((ax, cx)=>ax+cx);

console.log(res);
