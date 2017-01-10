export class Application {
    id: number;
    name: string;
    message: string;
    version: string;
    script: string;
    quitCode: number;
    dependency: Application[];
}