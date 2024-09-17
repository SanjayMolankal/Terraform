import { exec } from 'child_process';

async function runTerrascan() {
  return new Promise((resolve, reject) => {
    exec('terrascan scan -t aws -f .', (error, stdout, stderr) => {
      if (error) {
        reject(`Terrascan scan failed: ${error.message}`);
        return;
      }
      if (stderr) {
        reject(`Error output: ${stderr}`);
        return;
      }
      resolve(stdout);
    });
  });
}

async function main() {
  try {
    const results = await runTerrascan();
    console.log('Terrascan scan results:\n', results);
  } catch (error) {
    console.error(error);
  }
}

main();
