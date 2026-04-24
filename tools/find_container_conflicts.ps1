$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$proj = Resolve-Path (Join-Path $root '..')
Get-ChildItem -Path "$proj\lib" -Recurse -Include *.dart -File | ForEach-Object {
    $text = Get-Content -Path $_.FullName -Raw -Encoding UTF8
    $pattern = [regex] 'Container\s*\('
    $idx = 0
    while ($true) {
        $m = $pattern.Match($text, $idx)
        if (-not $m.Success) { break }
        $start = $m.Index + $m.Length - 1
        $pos = $start
        $depth = 1
        $len = $text.Length
        while ($pos -lt ($len - 1) -and $depth -gt 0) {
            $pos++
            $c = $text[$pos]
            if ($c -eq '(') { $depth++ }
            elseif ($c -eq ')') { $depth-- }
        }
        if ($depth -eq 0) {
            $snippet = $text.Substring($start+1, $pos-$start-1)
            # Parse top-level named arguments inside snippet: scan and record identifiers at depth 0
            $topLevelArgs = @()
            $slen = $snippet.Length
            $p = 0
            $nest = 0
            while ($p -lt $slen) {
                $ch = $snippet[$p]
                if ($ch -eq '(' -or $ch -eq '[' -or $ch -eq '{') { $nest++ }
                elseif ($ch -eq ')' -or $ch -eq ']' -or $ch -eq '}') { if ($nest -gt 0) { $nest-- } }
                elseif ($nest -eq 0) {
                    # try to match an identifier followed by ':'
                    if ($snippet.Substring($p) -match '^[ \t\r\n]*([a-zA-Z_][a-zA-Z0-9_]*)\s*:') {
                        $name = $matches[1]
                        $topLevelArgs += $name
                        # advance past matched name and ':'
                        $p += $matches[0].Length - 1
                    }
                }
                $p++
            }
            if ($topLevelArgs -contains 'color' -and $topLevelArgs -contains 'decoration') {
                Write-Host "FOUND_CONFLICT: $($_.FullName)" -ForegroundColor Yellow
                $contextStart = [Math]::Max(0, $m.Index - 120)
                $contextLen = [Math]::Min(400, $len - $contextStart)
                Write-Host $text.Substring($contextStart, $contextLen)
                Write-Host "`n---`n"
            }
        }
        $idx = $m.Index + 1
    }
}
Write-Host 'SEARCH COMPLETE'

