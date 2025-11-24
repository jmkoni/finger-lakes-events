type DeepPartial<T> = T extends object ? {
    [P in keyof T]?: DeepPartial<T[P]>;
} : T;
/**
 * Deep merge two objects
 * @param target - The base object (defaults)
 * @param source - The object to merge in (user config)
 * @returns Merged object
 */
export declare function deepMerge<T extends Record<string, any>>(target: T, source: DeepPartial<T>): T;
export {};
