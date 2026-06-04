import { ShoperzzPluginManifest } from "@shoperzz/common";

/**
 * Validates that all required fields exist in the plugin manifest.
 */
export function validateManifest(manifest: ShoperzzPluginManifest): void {
  const requiredFields: Array<keyof ShoperzzPluginManifest> = [
    "name",
    "version",
    "label",
    "category",
    "permissions",
    "emits",
    "listens",
  ];

  for (const field of requiredFields) {
    if (!manifest[field]) {
      throw new Error(
        `Manifest${manifest.name ? ` for "${manifest.name}"` : ""} missing required field "${String(field)}".`,
      );
    }
  }
}
