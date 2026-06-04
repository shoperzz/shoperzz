/**
 * Determines if a given event matches any of the registered wildcard or literal pattern strings.
 */
export function isEventAllowed(event: string, patterns: string[]): boolean {
  for (const pattern of patterns) {
    if (pattern === event) return true;
    if (pattern.includes("*")) {
      const regexStr =
        "^" + pattern.replace(/\./g, "\\.").replace(/\*/g, ".*") + "$";
      const regex = new RegExp(regexStr);
      if (regex.test(event)) return true;
    }
  }
  return false;
}
