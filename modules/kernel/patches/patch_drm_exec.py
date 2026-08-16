import sys

path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()

old_macro = """#define drm_exec_until_all_locked(exec)				\\
	for (void *__drm_exec_retry_ptr; ({			\\
		__label__ __drm_exec_retry;			\\
		__drm_exec_retry_ptr = &&__drm_exec_retry;	\\
		(void)__drm_exec_retry_ptr;			\\
		__drm_exec_retry:				\\
		drm_exec_cleanup(exec);				\\
	});)"""

new_macro = """#define drm_exec_until_all_locked(exec)				\\
	__label__ __drm_exec_retry;				\\
	__drm_exec_retry:					\\
	for (bool __retry = ({ (void)&&__drm_exec_retry; true; }); __retry; __retry = false) \\
		if (drm_exec_cleanup(exec)) {} else"""

if old_macro in content:
    content = content.replace(old_macro, new_macro)

with open(path, "w") as f:
    f.write(content)
