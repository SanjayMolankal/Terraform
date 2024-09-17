import * as terrascan from '@pulumi/terrascan';

async function main() {
  try {
    const results = await terrascan.scan({
       directory: './',
       include: ['*.tf', '*.tfvars'],
      // exclude: ['**/.terraform', '**/terraform.lock.hcl'],
    });

    // Process the scan results
    console.log(results);
  } catch (error) {
    console.error('Terrascan scan failed:', error);
  }
}

main();
