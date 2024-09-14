import { exec } from 'child_process';
import { promises as fs } from 'fs';
import path from 'path';

// Function to create a Terrascan configuration file
const createTerrascanConfig = async (configFilePath: string): Promise<void> => {
  const configContent = `
  # Example Terrascan configuration file content
  # Add your configuration here
  `;

  await fs.writeFile(configFilePath, configContent, 'utf8');
  console.log(`Configuration file created at ${configFilePath}`);
};

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

// Main function to execute the scan and save the output
const main = async () => {
  const directoryToScan = './path/to/terraform/files';
  // const terrascanConfigFile = './path/to/terrascan/config.yml'; // Update with your config file path

  try {
    // Create configuration file (if needed)
    await createTerrascanConfig(terrascanConfigFile);

    // Run the Terrascan scan
    const output = await runTerrascan(directoryToScan);

    // Save the output to a file
    const outputPath = 'terrascan_output.txt';
    await fs.writeFile(outputPath, output);
    console.log('Terrascan scan completed successfully. Output saved to', outputPath);
  } catch (error) {
    console.error('Error running Terrascan:', error);
  }
};

// Run the main function
main();
