import { exec } from 'child_process';
import fs from 'fs';

async function runTerrascan(options: { target: string; format: string; outputFile?: string }) {
  const { target, format, outputFile } = options;

  return new Promise((resolve, reject) => {
    const command = `terrascan scan -t ${target} -f ${format}`;

    exec(command, (error, stdout, stderr) => {
      if (error) {
        reject(`Terrascan scan failed: ${error.message}`);
        return;
      }
      if (stderr) {
        reject(`Error output: ${stderr}`);
        return;
      }

      const results = JSON.parse(stdout);

      if (outputFile) {
        fs.writeFileSync(outputFile, JSON.stringify(results, null, 2));
      }

      resolve(results);
    });
  });
}

async function main() {
  const target = 'aws'; // Replace with your desired target (e.g., 'gcp', 'azure')
  const format = 'json'; // Replace with your desired output format (e.g., 'csv', 'yaml')
  const outputFile = 'terrascan-results.json'; // Optional: Specify an output file

  try {
    const results = await runTerrascan({ target, format, outputFile });
    console.log('Terrascan scan results:\n', results);
  } catch (error) {
    console.error(error);
  }
}

main();
