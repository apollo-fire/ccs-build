# ccs_build
Docker Action that can build a Code Composer Studio project

## Available MSP Compiler
* 21.6.0.LTS

## Example usage
```yaml
- uses: apollo-fire/ccs-build/compiler/21.6.0@v0.0.5
  with:
    build-configuration: Debug
```
