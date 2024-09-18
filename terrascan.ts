import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

describe('Terrascan Tests', () => {
  it('should detect violations in Terraform code', async () => {
    const { stdout, stderr } = await execAsync('terrascan scan -f json ./path/to/terraform/code');

    if (stderr) {
      throw new Error(stderr);
    }

    const results = JSON.parse(stdout);

    // Check for violations
    expect(results.violations).toHaveLength(1);

    // Check for specific violation details
    expect(results.violations[0].rule_id).toBe('AWS.S3.DS.High.0001');
    expect(results.violations[0].severity).toBe('HIGH');
  });
});
