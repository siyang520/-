const fs = require('fs');
const path = require('path');
const htmlPath = path.join(__dirname, 'index.html');
const base64Path = path.join(__dirname, 'replace_image3.txt');
let html = fs.readFileSync(htmlPath, 'utf8');
const base64 = fs.readFileSync(base64Path, 'utf8').replace(/\r?\n/g, '');

const linkPattern = /\s*<a class="work-link" href="mmexport1784018485068\.\.mp4" target="_blank" rel="noopener">观看视频案例<\/a>\s*/;
if (!linkPattern.test(html)) throw new Error('video link not found in first card');
html = html.replace(linkPattern, '');

const imgPattern = /<img src="data:image\/svg\+xml;base64,[^"]*" alt="作品封面 3" \/>/;
if (!imgPattern.test(html)) throw new Error('third card placeholder image not found');
html = html.replace(imgPattern, `<img src="data:image/png;base64,${base64}" alt="作品封面 3" />`);

const insertPattern = /(<img src="data:image\/png;base64,[^"]*" alt="作品封面 3" \/>[\s\S]*?<ul class="tag-list">[\s\S]*?<\/ul>\s*)(<\/div>\s*<\/article>)/;
if (!insertPattern.test(html)) throw new Error('third work card block not found for insertion');
html = html.replace(insertPattern, `$1            <a class="work-link" href="mmexport1784018485068..mp4" target="_blank" rel="noopener">观看 10 分钟视频</a>\n$2`);

fs.writeFileSync(htmlPath, html, 'utf8');
console.log('updated');
