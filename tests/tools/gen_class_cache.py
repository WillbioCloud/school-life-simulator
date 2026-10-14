#!/usr/bin/env python3
"""Generate res://.godot/global_script_class_cache.cfg for a template (non-editor) Godot binary."""
import os, re, sys
root = sys.argv[1]
entries = []
for dirpath, _, files in os.walk(root):
    if '/.godot' in dirpath or '/.git' in dirpath:
        continue
    for f in files:
        if not f.endswith('.gd'):
            continue
        path = os.path.join(dirpath, f)
        src = open(path, encoding='utf-8').read()
        m = re.search(r'^class_name\s+([A-Za-z_][A-Za-z0-9_]*)', src, re.M)
        if not m:
            continue
        b = re.search(r'^extends\s+([A-Za-z_][A-Za-z0-9_.]*)', src, re.M)
        base = b.group(1) if b else 'RefCounted'
        rel = os.path.relpath(path, root).replace(os.sep, '/')
        entries.append((m.group(1), base, 'res://' + rel))
entries.sort()
os.makedirs(os.path.join(root, '.godot'), exist_ok=True)
items = []
for cls, base, path in entries:
    items.append('{\n"base": &"%s",\n"class": &"%s",\n"icon": "",\n"is_abstract": false,\n"is_tool": false,\n"language": &"GDScript",\n"path": "%s"\n}' % (base, cls, path))
open(os.path.join(root, '.godot', 'global_script_class_cache.cfg'), 'w', encoding='utf-8').write('list=Array[Dictionary]([' + ', '.join(items) + '])\n')
print('classes:', ', '.join(c for c, _, _ in entries))
