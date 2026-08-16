import sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old_section = """#define drm_exec_until_all_locked(exec)				\\
	for (void *__drm_exec_retry_ptr; ({			\\
		__label__ __drm_exec_retry;			\\
		__drm_exec_retry_ptr = &&__drm_exec_retry;	\\
		(void)__drm_exec_retry_ptr;			\\
		__drm_exec_retry:				\\
		drm_exec_cleanup(exec);				\\
	});)"""

new_section = """#define drm_exec_until_all_locked(exec)				\\
	__drm_exec_retry:					\\
	for (bool __retry = true; __retry; __retry = false)	\\
		if (drm_exec_cleanup(exec)) {} else"""

if old_section in content:
    content = content.replace(old_section, new_section)

content = content.replace("goto *__drm_exec_retry_ptr;", "goto __drm_exec_retry;")

with open(path, "w") as f:
    f.write(content)
