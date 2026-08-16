import sys, re

path = sys.argv[1]

with open(path, "r") as f:
    content = f.read()

until_pattern = re.compile(r'#define drm_exec_until_all_locked\(exec\).*?\}\s*\)\s*;\s*\)', re.DOTALL)
new_until = """#define drm_exec_until_all_locked(exec) \\
\tfor (int __drm_exec_retry = 1; __drm_exec_retry ? \\
\t     ({ __drm_exec_retry = 0; drm_exec_cleanup(exec); }) : 0; )"""
content = until_pattern.sub(new_until, content)

retry_pattern = re.compile(r'#define drm_exec_retry_on_contention\(exec\).{0,250}?goto\s+\*?__drm_exec_retry(?:_ptr)?;?(?:\s*\}\s*while\s*\(\s*0\s*\))?', re.DOTALL)
new_retry = """#define drm_exec_retry_on_contention(exec) \\
\tdo { \\
\t\tif (unlikely(drm_exec_is_contended(exec))) { \\
\t\t\t__drm_exec_retry = 1; \\
\t\t\tcontinue; \\
\t\t} \\
\t} while (0)"""
content = retry_pattern.sub(new_retry, content)

with open(path, "w") as f:
    f.write(content)
