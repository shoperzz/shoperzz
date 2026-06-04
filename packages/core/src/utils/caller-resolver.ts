/**
 * Resolves the file path of the caller function by parsing the V8 stack trace.
 * Skips files matching the exclude pattern to find the originating package/file.
 */
export function getCallerFile(excludePattern = "packages/core/src"): string | null {
  const originalFunc = Error.prepareStackTrace;
  try {
    const err = new Error();
    Error.prepareStackTrace = (_, stack) => stack;
    const stack = err.stack as unknown as NodeJS.CallSite[] | undefined;
    if (!stack) return null;

    const currentFile = stack[0]?.getFileName();
    for (let i = 1; i < stack.length; i++) {
      const callerFile = stack[i]?.getFileName();
      if (
        callerFile &&
        callerFile !== currentFile &&
        !callerFile.includes(excludePattern)
      ) {
        return callerFile;
      }
    }
  } catch (e) {
    // ignore error
  } finally {
    Error.prepareStackTrace = originalFunc;
  }
  return null;
}
