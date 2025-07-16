import { ValueTransformer } from "typeorm";

export class DecimalTransformer implements ValueTransformer {
    to(value: number): string {
        return value?.toString();
    }

    from(value: string): number {
        return parseFloat(value);
    }
}