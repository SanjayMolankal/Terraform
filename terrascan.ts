import { exec } from 'child_process';

// Function to run Terrascan scan
const runTerrascan = (directory: string): Promise<string> => {
  return new Promise((resolve, reject) => {
    exec(`terrascan scan -d ${directory}`, (error, stdout, stderr) => {
      if (error) {
        reject(`Error: ${stderr}`);
      }
      resolve(stdout);
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
