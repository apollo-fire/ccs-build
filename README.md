# ccs_build
Docker Action that can build a Code Composer Studio project

## Available MSP Compilers
* 21.6.0.LTS (default)

## Example usage
```yaml
- uses: apollo-fire/ccs-build@v0.0.4
  with:
    build-configuration: Debug
```
