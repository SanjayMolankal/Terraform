import * as exec from '@actions/exec';
import * as core from '@actions/core';
import * as tc from '@actions/tool-cache';
import { execSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { makeTmpDir, stringifyError } from './utils';

export interface TerrascanOptions {
    version?: string;
    configPath?: string;
}

export interface TerrascanCommandResult {
    data?: string;
    error?: string;
}

export class Terrascan {
    private readonly version: string;
    private readonly configPath?: string;
    private setupComplete = false;

    constructor(opts: TerrascanOptions) {
        this.version = opts.version || 'latest';
        this.configPath = opts.configPath;
    }

    async scan(directory: string): Promise<TerrascanCommandResult> {
        await this.setup();
        return await this.runReportGeneratingCommand(
            `terrascan scan --path "${directory}" --format json`
        );
    }

    async runReportGeneratingCommand(cmd: string): Promise<TerrascanCommandResult> {
        await this.setup();
        const result: TerrascanCommandResult = {};

        const tmpDir = await makeTmpDir();
        const reportFile = path.join(tmpDir, 'terrascan-report.json');

        try {
            // Using lower level Node.js apis here because of an issue with lack of newline on terrascan scan output.
            // Piping the output to a file and reading the file afterward ensures the full JSON object is captured.
            execSync(`${cmd} > ${reportFile}`, { stdio: 'pipe' });
        } catch (err) {
            // Attach error data if the command failed
            result.error = stringifyError(err);
        }

        // Attach report data if any was written
        if (fs.existsSync(reportFile)) {
            result.data = fs.readFileSync(reportFile).toString();
        }

        // Print a warning for the unexpected case of a successful run with no report data
        if (!result.data && !result.error) {
            core.warning('Terrascan scan ran successfully but no report data was found');
        }

        return result;
    }

    async setup(): Promise<void> {
        if (this.setupComplete) {
            return;
        }

        core.startGroup('Setting up terrascan');
        await this.setupCli();
        core.endGroup();

        this.setupComplete = true;
    }

    async setupCli(): Promise<void> {
        const cachedPath = tc.find('terrascan', this.version);
        core.info(`Got cached path for terrascan@${this.version}: ${cachedPath}`);

        // case: found tool in cache
        if (cachedPath) {
            core.info('Skipping terrascan tool download');
            core.addPath(cachedPath);
            return;
        }

        // case: need to download tool
        core.info('Downloading terrascan tool');
        const newCachedPath = await this.downloadCli();
        core.addPath(newCachedPath);
        await exec.exec('terrascan', ['--version']);
    }

    async downloadCli(): Promise<string> {
        const tmpDir = await makeTmpDir();
        const installerUrl = `https://github.com/accuitycloud/terrascan/releases/download/v${this.version}/terrascan-linux-amd64`;

        await exec.exec('curl', ['-s', '-o', 'terrascan', installerUrl], { cwd: tmpDir });
        await exec.exec('chmod', ['+x', 'terrascan'], { cwd: tmpDir });

        const cachedDir = await tc.cacheDir(tmpDir, 'terrascan', this.version);
        core.info(`cachedDir = ${cachedDir}`);

        return cachedDir;
    }
}
