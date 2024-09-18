import { exec } from 'child_process';

export async function runTerrascan() {
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
      const results = JSON.parse(stdout);
      resolve(results);
    });
  });
}
