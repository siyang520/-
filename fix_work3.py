import re
from pathlib import Path

base64_file = Path('replace_image3.txt')
html_file = Path('index.html')
html = html_file.read_text(encoding='utf-8')
base64_data = base64_file.read_text(encoding='ascii').strip()

removed, count = re.subn(
    r"\s*<a class=\"work-link\" href=\"mmexport1784018485068\.\.mp4\" target=\"_blank\" rel=\"noopener\">观看视频案例</a>\s*\n",
    '',
    html,
    count=1,
)
if count == 0:
    raise SystemExit('video link not found in first card')
html = removed

html, count = re.subn(
    r'(<img src=")data:image/svg\+xml;base64,[^\"]+(" alt="作品封面 3" />)',
    lambda m: m.group(1) + 'data:image/png;base64,' + base64_data + m.group(2),
    html,
    count=1,
)
if count == 0:
    raise SystemExit('third card placeholder image not found')

if '观看 10 分钟视频' in html:
    raise SystemExit('target video link already present')

pattern = re.compile(
    r'(<img src="data:image/png;base64,[^"]+" alt="作品封面 3" />.*?<ul class="tag-list">.*?</ul>\n)(\s*</div>\n\s*</article>)',
    re.S,
)
match = pattern.search(html)
if not match:
    raise SystemExit('third work card block not found')

insert_at = match.end(1)
html = (
    html[:insert_at]
    + '            <a class="work-link" href="mmexport1784018485068..mp4" target="_blank" rel="noopener">观看 10 分钟视频</a>\n'
    + html[insert_at:]
)

html_file.write_text(html, encoding='utf-8')
print('updated')