import { execSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';


//Function to compile Typescript file
const compileTypeScript = (tsFile: string) => {
  try {
    console.log(`Compiling TypeScript file: terrascan.ts`);
    execSync(`npx tsc terrascan.ts`);
    console.log("Compilation successful.");
  } catch (error) {
    console.error("Error during TypeScript compilation: ", error);
    process.exit(1); // Exit if compilation fails
  }
};

//Installing terrascan
const installTerrascan = () => {
  try {
    console.log("Installing Terrascan...");
	execSync('curl -L https://github.com/tenable/terrascan/releases/download/v1.17.0/terrascan_1.17.0_Linux_x86_64.tar.gz -o terrascan.tar.gz');
	execSync('tar -xvzf terrascan.tar.gz');
    execSync('sudo mv terrascan /usr/local/bin/terrascan');
    execSync('terrascan version');
	console.log("Terrascan installed successfull.");
  } catch (error) {
    console.error("Error installing Terrascan: ", error);
  }
};

//Run Terrascan and save the output
const runTerrascanScan = (terraformDir: string, outputFile: string) => {
   try {
      console.log(`Running Terrascan scan on directory: ${terraformDir}`);
      const terrascanOutput = execSync(`terrascan scan -i terraform -d ${terraformDir} -o json`);

      // Display terrascan output
      console.log("Terrascan scan results:");
      console.log(terrascanOutput.toString());
      
      // save the output to a file
       fs.writeFileSync(outputFile, terrascanOutput.toString());
        console.log(`Terrascan scan complete. Output saved to ${outputFile}`);
    } catch (error) {
        console.error("Error running Terrascan scan: ", error);
    }
};

// Main function to execute the steps
const main = () => {
    const tsFile = path.resolve('./terrascan.ts');
    const terraformDir = path.resolve('./terraform');  // Replace with your Terraform directory
    const outputFile = 'terrascan-output.json';

    compileTypeScrypt(tsFile);	
    installTerrascan();
    runTerrascanScan(terraformDir, outputFile);
};

main();
