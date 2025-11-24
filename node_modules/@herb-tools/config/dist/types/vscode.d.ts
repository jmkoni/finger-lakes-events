export interface VSCodeExtensionsJson {
    recommendations?: string[];
    unwantedRecommendations?: string[];
}
/**
 * Adds the Herb VSCode extension to the recommended extensions list
 * Returns true if the extension was added, false if it was already present
 */
export declare function addHerbExtensionRecommendation(projectPath: string): boolean;
/**
 * Gets the relative path to the extensions.json file from the project root
 */
export declare function getExtensionsJsonRelativePath(): string;
