path = "$out/include/drm/drm_exec.h"
with open(path, "r") as f:
    content = f.read()

new_block = """#define drm_exec_until_all_locked(exec)				\\
	for (bool __exec_retry = ({ __label__ __drm_exec_retry; __drm_exec_retry: true; }); \\
	     __exec_retry; __exec_retry = false)			\\
		for (; drm_exec_cleanup(exec); )

#define drm_exec_retry_on_contention(exec)			\\
	if (unlikely(drm_exec_is_contended(exec)))		\\
		goto __drm_exec_retry"""

import re
pattern = r"#define drm_exec_until_all_locked\(exec\).*?#define drm_exec_retry_on_contention\(exec\).*?goto \*__drm_exec_retry_ptr;"
content = re.sub(pattern, new_block, content, flags=re.DOTALL)

if "goto *__drm_exec_retry_ptr;" in content:
    content = content.replace("goto *__drm_exec_retry_ptr;", "goto __drm_exec_retry;")

with open(path, "w") as f:
    f.write(content)
