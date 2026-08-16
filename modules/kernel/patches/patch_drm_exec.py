import sys, re

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

new_drm_exec = """#define drm_exec_until_all_locked(exec)				\\
	__label__ __drm_exec_retry;					\\
	__drm_exec_retry:						\\
	for (bool __retry = true; __retry; __retry = false)		\\
		if (drm_exec_cleanup(exec)) {} else"""

content = re.sub(
    r'#define drm_exec_until_all_locked\(exec\).*?drm_exec_cleanup\(exec\);\s*\}\);?\)',
    new_drm_exec,
    content,
    flags=re.DOTALL
)

content = content.replace("goto *__drm_exec_retry_ptr;", "goto __drm_exec_retry;")
content = content.replace("(void)__drm_exec_retry_ptr;", "")

with open(path, "w") as f:
    f.write(content)
