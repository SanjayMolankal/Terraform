import { exec } from 'child_process';

type ExecCallback = (error: Error | null, stdout: string, stderr: string) => void;

// Function to run Terrascan scan
const runTerrascan = (directory: string): Promise<string> => {
  return new Promise((resolve, reject) => {
    exec(`terrascan scan -d ${directory}`, (error: Error | null, stdout: string, stderr: string) => {
      if (error) {
        reject(`Error: ${stderr}`);
      } else {
        resolve(stdout);
      }
    });
  });
};

// Example usage
const directoryToScan = './Terraform/';

runTerrascan(directoryToScan)
  .then((output) => {
    console.log('Terrascan Output:', output);
  })
  .catch((error) => {
    console.error('Error running Terrascan:', error);
  });
