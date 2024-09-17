import * as core from '@actions/core';
import * as tc from '@actions/tool-cache';
import * as exec from '@actions/exec';

async function run() {
    try {
        const terrascanVersion = core.getInput('terrascan-version', { required: true });

        // Download and cache Terrascan
        await downloadTerrascan(terrascanVersion);

        // Run Terrascan scan
        await exec.exec('terrascan', ['scan', '--path', '.']);
    } catch (error) {
        core.setFailed(`Failed to run Terrascan: ${error.message}`);
    }
}

async function downloadTerrascan(version: string): Promise<void> {
    const tmpDir = await tc.find('terrascan', version);

    if (!tmpDir) {
        core.info(`Downloading Terrascan ${version}`);

        const installerUrl = `https://github.com/accuitycloud/terrascan/releases/download/v${version}/terrascan-linux-amd64`;

        await exec.exec('curl', ['-s', '-o', 'terrascan', installerUrl], { cwd: tmpDir });
        await exec.exec('chmod', ['+x', 'terrascan'], { cwd: tmpDir });

        const cachedDir = await tc.cacheDir(tmpDir, 'terrascan', version);
        core.info(`Cached Terrascan to ${cachedDir}`);
    }
}

run();
