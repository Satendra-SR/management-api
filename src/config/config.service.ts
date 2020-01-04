import { Injectable } from '@nestjs/common';
import * as fs from 'fs';
import * as dotenv from 'dotenv';

// tslint:disable-next-line: export-name
@Injectable()
export class ConfigService {
    private readonly envConfig: {[key:string]: string}

    constructor(filePath: string) {
        if(fs.existsSync(filePath)) {
            this.envConfig = dotenv.parse(fs.readFileSync(filePath));
        }
    }
}
