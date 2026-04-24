import re
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
files = list(root.glob('lib/**/*.dart'))

def find_conflicts(text):
    conflicts = []
    for m in re.finditer(r"Container\s*\(", text):
        start = m.end() - 1
        pos = start
        depth = 1
        L = len(text)
        while pos + 1 < L and depth > 0:
            pos += 1
            c = text[pos]
            if c == '(':
                depth += 1
            elif c == ')':
                depth -= 1
        if depth == 0:
            snippet = text[start+1:pos]
            if re.search(r"\bcolor\s*:\s*", snippet) and re.search(r"\bdecoration\s*:\s*", snippet):
                context_start = max(0, m.start()-120)
                context_end = min(L, pos+120)
                conflicts.append((m.start(), snippet, text[context_start:context_end]))
    return conflicts

any_found = False
for f in files:
    s = f.read_text(encoding='utf-8')
    conf = find_conflicts(s)
    if conf:
        any_found = True
        print('FOUND_CONFLICT:', f)
        for idx, snippet, context in conf:
            print('\n--- context ---')
            print(context)
            print('--- end context ---\n')

if not any_found:
    print('NO_CONFLICTS_FOUND')

