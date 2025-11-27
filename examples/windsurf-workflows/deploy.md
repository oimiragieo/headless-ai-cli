# Deploy Workflow

This workflow automates the deployment process for the project.

## Steps

1. **Run Tests**
   - Execute: `npm test`
   - Ensure all tests pass before proceeding

2. **Build Project**
   - Execute: `npm run build`
   - Create production-ready build artifacts

3. **Deploy to Staging**
   - Execute: `npm run deploy:staging`
   - Deploy to staging environment

4. **Run Smoke Tests**
   - Execute: `npm run smoke-tests`
   - Verify deployment is successful

## Usage

Invoke this workflow in Cascade using: `/deploy`

