import sys

path = sys.argv[1]

with open(path, "r") as f:
    content = f.read()

old_until = """#define drm_exec_until_all_locked(exec)				\\
	for (void *__drm_exec_retry_ptr; ({			\\
		__label__ __drm_exec_retry;			\\
		__drm_exec_retry_ptr = &&__drm_exec_retry;	\\
		(void)__drm_exec_retry_ptr;			\\
		__drm_exec_retry:				\\
		drm_exec_cleanup(exec);				\\
	});)"""

old_retry = """#define drm_exec_retry_on_contention(exec)			\\
	if (unlikely(drm_exec_is_contended(exec)))		\\
		goto *__drm_exec_retry_ptr"""

new_until = """#define drm_exec_until_all_locked(exec)				\\
	for (bool __exec_retry = ({ __label__ __drm_exec_retry; __drm_exec_retry: true; }); \\
	     __exec_retry; __exec_retry = false)			\\
		for (; drm_exec_cleanup(exec); )"""

new_retry = """#define drm_exec_retry_on_contention(exec)			\\
	if (unlikely(drm_exec_is_contended(exec)))		\\
		goto __drm_exec_retry"""

if old_until in content:
    content = content.replace(old_until, new_until)

if old_retry in content:
    content = content.replace(old_retry, new_retry)

content = content.replace("goto *__drm_exec_retry_ptr;", "goto __drm_exec_retry;")

with open(path, "w") as f:
    f.write(content)
