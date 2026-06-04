import * as fs from "fs";
import * as path from "path";

/**
 * Resolves the closest parent directory containing a package.json file.
 */
export function getPackageDir(filePath: string): string | null {
  let dir = path.dirname(filePath);
  while (dir && dir !== "/" && dir !== ".") {
    if (fs.existsSync(path.join(dir, "package.json"))) {
      return dir;
    }
    const parent = path.dirname(dir);
    if (parent === dir) break;
    dir = parent;
  }
  return null;
}
