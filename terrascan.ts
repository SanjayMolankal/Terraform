import { exec } from 'child_process';

// Function to install Terrascan
export const installTerrascan = () => {
  exec('curl -L https://github.com/tenable/terrascan/releases/latest/download/terrascan_linux_amd64.tar.gz | tar -xvz && sudo mv terrascan /usr/local/bin', (error, stdout, stderr) => {
    if (error) {
      console.error(`Error installing Terrascan: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`Error output: ${stderr}`);
      return;
    }
    console.log(`Terrascan installed: ${stdout}`);
  });
};

// Call the function to install Terrascan
installTerrascan();
