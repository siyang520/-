$htmlPath = 'index.html'
$base64Path = 'replace_image3.txt'
$html = Get-Content -Path $htmlPath -Raw
$base64 = Get-Content -Path $base64Path -Raw

# Remove first card video link
$html = [regex]::Replace($html, "\s*<a class=\"work-link\" href=\"mmexport1784018485068\.\.mp4\" target=\"_blank\" rel=\"noopener\">观看视频案例</a>\r?\n", '', 1)

# Replace third card placeholder image with PNG base64
$imgPattern = [regex] '(?s)<img src="data:image/svg\+xml;base64[^"]*" alt="作品封面 3" />'
$html = $imgPattern.Replace($html, "<img src=\"data:image/png;base64,$base64\" alt=\"作品封面 3\" />", 1)

# Insert video link into third work card
$insertPattern = [regex] '(?s)(<img src="data:image/png;base64,[^"]*" alt="作品封面 3" />.*?<ul class="tag-list">.*?</ul>\r?\n)(\s*</div>\r?\n\s*</article>)'
$html = $insertPattern.Replace($html, "$1            <a class=\"work-link\" href=\"mmexport1784018485068..mp4\" target=\"_blank\" rel=\"noopener\">观看 10 分钟视频</a>\r\n$2", 1)

Set-Content -Path $htmlPath -Value $html -Encoding utf8
Write-Host 'updated'