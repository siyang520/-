const fs = require('fs');
const path = require('path');
const file = path.join(__dirname, 'index.html');
let html = fs.readFileSync(file, 'utf8');
const pattern = /(<article class="work-card">[\s\S]*?<\/article>\s*)(<article class="work-card">[\s\S]*?<\/article>\s*)/;
const match = html.match(pattern);
if (!match) {
  throw new Error('Could not find first two work-card blocks.');
}
const swapped = html.replace(pattern, `${match[2]}${match[1]}`);
fs.writeFileSync(file, swapped, 'utf8');
console.log('swapped');
