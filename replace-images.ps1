$base64Text = Get-Content -Path .\base64-images.txt -Raw
$sections = $base64Text -split 'FILE:' | Where-Object { $_ -ne '' }
if ($sections.Count -lt 2) {
    Write-Error '未找到足够的 base64 图像数据。'
    exit 1
}
$firstSection = $sections[0].Trim()
$secondSection = $sections[1].Trim()
$firstBase64 = $firstSection.Substring($firstSection.IndexOf("`n") + 1).Trim()
$secondBase64 = $secondSection.Substring($secondSection.IndexOf("`n") + 1).Trim()
$htmlLines = Get-Content -Path .\index.html
$replacement1 = "src=`"data:image/png;base64,$firstBase64`""
$replacement2 = "src=`"data:image/png;base64,$secondBase64`""
$htmlLines = $htmlLines | ForEach-Object {
    if ($_ -match 'alt="作品封面 1"') {
        $_ -replace 'src="[^"]+"', $replacement1
    } elseif ($_ -match 'alt="作品封面 2"') {
        $_ -replace 'src="[^"]+"', $replacement2
    } else {
        $_
    }
}
Set-Content -Path .\index.html -Value $htmlLines -Encoding UTF8
Write-Host '替换完成'